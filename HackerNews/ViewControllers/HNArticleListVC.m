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

@interface HNArticleListVC ()

@end

@implementation HNArticleListVC

@synthesize articles, webBrowserVC, commentVC, downloadController, cellFont, infoFont, numCommentsFont;

- (id)initWithStyle:(UITableViewStyle)style withWebBrowserVC:(HNWebBrowserVC *)webVC andCommentVC:(HNCommentVC *)commVC;
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.title = @"Hacker News";
        
        //Set this so custom "HNTouchableView" won't have delays when calling "touchesBegan"
        self.tableView.delaysContentTouches = NO;
        
        webBrowserVC = webVC;
        commentVC = commVC;
        
        articles = [[NSArray alloc] init];
        
        downloadController = [[HNDownloadController alloc] initWithUrl:@"https://news.ycombinator.com"];
        
        //This is an example of the site when there is a "black bar" on the header (i.e. a famous tech person died
        //downloadController = [[HNDownloadController alloc] initWithUrl:@"http://www.waybackletter.com/archive/20111005.html"];
        
        downloadController.downloadDelegate = self;
        
        self.cellFont = [UIFont systemFontOfSize:14];
        self.infoFont = [UIFont systemFontOfSize:12];
        self.numCommentsFont = [UIFont systemFontOfSize:12];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                     target:self
                                     action:@selector(reloadButtonPressed)];
    //[[self.navigationController navigationItem] setRightBarButtonItem:reloadButton];
    self.navigationItem.rightBarButtonItem = reloadButton;
    
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


- (void) downloadFrontPageArticles
{
    [downloadController beginDownload];
    
}

- (NSString *) getInfoText:(HNArticle *)article
{
    NSMutableString *infoString = [[NSMutableString alloc] init];
    
    if (article.score)
    {
        [infoString appendFormat:@"%@ points", article.score];
    }
    
    if (article.timePosted)
    {
        
        if (infoString.length > 0)
        {
            [infoString appendFormat:@" • "];
        }
        
        [infoString appendString:article.timePosted];
    }
    
    if (article.domainName)
    {
        
        if (infoString.length > 0)
        {
            [infoString appendFormat:@" • "];
        }
        
        [infoString appendFormat:@"%@", article.domainName];
        
    }
    
    if (article.user)
    {
        
        if (infoString.length > 0)
        {
            [infoString appendFormat:@" • "];
        }
        
        [infoString appendFormat:@"%@", article.user];
    }
    
    return infoString;
}

#pragma mark HNDownloadControllerDelegate

-(void) downloadDidComplete:(id)data
{
    NSArray *parsedArticles = [HNParser parseArticles:data];
    
    self.articles = parsedArticles;
    [self.tableView reloadData];
}

-(void) downloadFailed
{
    NSLog(@"Download failed!");
}

#pragma mark HNArticleCellDelegate

-(void) didTapArticle:(HNArticleCell *)cellTapped
{
    NSInteger index = [cellTapped tag];
    
    if (index >= 0 && index <= [articles count])
    {
        HNArticle *article = [articles objectAtIndex:index];
        NSString *selectedUrl = article.url;
        self.webBrowserVC.title = article.title;
        
        [self pushWebVCWithUrl:selectedUrl];
    }
}

-(void) didTapComment:(HNArticleCell *)cellTapped
{
    NSInteger index = [cellTapped tag];
    
    if (index >= 0 && index <= [articles count])
    {
        HNArticle *article = [articles objectAtIndex:index];
        NSString *commentId = article.commentLinkId;
        self.commentVC.currentCommentId = commentId;
        self.commentVC.title = article.title;
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}

-(void) pushWebVCWithUrl:(NSString *)url
{
    [webBrowserVC setURL:url];
    [self.navigationController pushViewController:webBrowserVC animated:YES];
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
    NSString *infoText = [self getInfoText:article];
    
    return [HNArticleCell getCellHeightForWidth:self.view.frame.size.width withArticleTitle:article.title withInfoText:infoText withTitleFont:self.cellFont withInfoFont:self.infoFont];

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
    cell.infoLabel.text = [self getInfoText:article];
    cell.delegate = self;
    cell.tag = indexPath.row;
    
    cell.numCommentsLabel.text = article.numComments;
    
    cell.articleTitleLabel.font = self.cellFont;
    cell.infoLabel.font = self.infoFont;
    cell.numCommentsLabel.font = self.numCommentsFont;
        
    return cell;
}

@end
