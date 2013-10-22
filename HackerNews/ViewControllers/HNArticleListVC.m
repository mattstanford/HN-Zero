//
//  HNArticleListVC.m
//  HackerNews
//
//  Created by Matthew Stanford on 8/29/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNArticleListVC.h"
#import "AFHTTPRequestOperation.h"
#import "HNParser.h"
#import "HNArticle.h"
#import "HNArticleContainerVC.h"
#import "HNTheme.h"

@implementation HNArticleListVC

@synthesize articles, webBrowserVC, commentVC, downloadController, articleContainerVC, theme;

- (id)initWithStyle:(UITableViewStyle)style withWebBrowserVC:(HNWebBrowserVC *)webVC andCommentVC:(HNCommentVC *)commVC articleContainer:(HNArticleContainerVC *)articleContainer withTheme:(HNTheme *)theTheme
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.title = @"Hacker News";
        
        //Set this so custom "HNTouchableView" won't have delays when calling "touchesBegan"
        self.tableView.delaysContentTouches = NO;
        
        webBrowserVC = webVC;
        commentVC = commVC;
        articleContainerVC = articleContainer;
        
        articles = [[NSArray alloc] init];
        
        downloadController = [[HNDownloadController alloc] initWithUrl:@"https://news.ycombinator.com"];
        
        //This is an example of the site when there is a "black bar" on the header (i.e. a famous tech person died
        //downloadController = [[HNDownloadController alloc] initWithUrl:@"http://www.waybackletter.com/archive/20111005.html"];
        
        downloadController.downloadDelegate = self;
        self.theme = theTheme;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Setup the pull-to-refresh control
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [self getTimeUpdatedString];
    [refresh addTarget:self action:@selector(downloadFrontPageArticles) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    //Register custom tableviewcell class with tableview
    [self.tableView registerClass:[HNArticleCell class] forCellReuseIdentifier:@"Cell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self downloadFrontPageArticles];
    
}

- (BOOL) shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)reloadButtonPressed
{
    [self downloadFrontPageArticles];
}

-(void) setUrl:(NSString *)url andTitle:(NSString *)title
{
    self.downloadController.url = url;
    self.title = title;
}

- (void) downloadFrontPageArticles
{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Updating..."];
    [downloadController beginDownload];
    
}

- (NSAttributedString *) getTimeUpdatedString
{
    NSAttributedString *returnString = nil;

    NSDate *currentDateTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"h:mm a MM/dd/yy"];
    
    NSString *dateString = [[NSString alloc] initWithFormat:@"Updated at %@",[dateFormatter stringFromDate:currentDateTime]];
    
    returnString = [[NSAttributedString alloc] initWithString:dateString];
    
    
    return returnString;
}

#pragma mark HNDownloadControllerDelegate

-(void) downloadDidComplete:(id)data
{
    NSArray *parsedArticles = [HNParser parseArticles:data];
    
    self.articles = parsedArticles;
    [self.tableView reloadData];
    
    //Update refresh control
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [self getTimeUpdatedString];
}

-(void) downloadFailed
{
    NSLog(@"Download failed!");
}

#pragma mark HNArticleCellDelegate

/*
 Determine if a url is a "self" post, i.e. the "article" is just a local URL to the comments
 page, which normally includes a some text content at the header.
 */
-(BOOL)isSelfPost:(NSString *)url
{
    NSString *selfPost = [HNParser getMatch:url fromRegex:@"(^item\\?id=\\d+$)"];
    
    if (selfPost)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
    
}

-(void) didTapArticle:(HNArticleCell *)cellTapped
{
    NSInteger index = [cellTapped tag];
    
    if (index >= 0 && index <= [articles count])
    {
        HNArticle *article = [articles objectAtIndex:index];
        
        if ([self isSelfPost:article.url])
        {
            [self didTapComment:cellTapped];
        }
        else
        {
        
            [articleContainerVC doPresentArticle:article];

            [self.navigationController pushViewController:articleContainerVC animated:YES];
        }

    }
}

-(void) didTapComment:(HNArticleCell *)cellTapped
{
    NSInteger index = [cellTapped tag];
    
    if (index >= 0 && index <= [articles count])
    {
        HNArticle *article = [articles objectAtIndex:index];

        [articleContainerVC doPresentCommentForArticle:article];
        [self.navigationController pushViewController:articleContainerVC animated:YES];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
       return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [articles count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNArticle *article = [self.articles objectAtIndex:indexPath.row];
    NSString *infoText = [article getInfoText];
    
    return [HNArticleCell getCellHeightForWidth:self.view.frame.size.width withArticleTitle:article.title withInfoText:infoText withTitleFont:self.theme.articleTitleFont withInfoFont:self.theme.articleInfoFont];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    HNArticleCell *cell = (HNArticleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[HNArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    HNArticle *article = [self.articles objectAtIndex:indexPath.row];
    cell.articleTitleLabel.text = article.title;
    cell.infoLabel.text = [article getInfoText];
    cell.delegate = self;
    cell.tag = indexPath.row;
    
    cell.numCommentsLabel.text = article.numComments;
    
    cell.articleTitleLabel.font = self.theme.articleTitleFont;
    cell.infoLabel.font = self.theme.articleInfoFont;
    cell.numCommentsLabel.font = self.theme.articleNumCommentsFont;
        
    return cell;
}

@end
