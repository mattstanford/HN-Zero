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
#import "HNUtils.h"

@implementation HNArticleListVC

@synthesize articles, webBrowserVC, commentVC, downloadController, articleContainerVC, theme, url, moreArticlesUrl, isDownloadAppending, shouldScrollToTopAfterDownload;

- (id)initWithStyle:(UITableViewStyle)style withWebBrowserVC:(HNWebBrowserVC *)webVC andCommentVC:(HNCommentVC *)commVC articleContainer:(HNArticleContainerVC *)articleContainer withTheme:(HNTheme *)theTheme
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.title = @"Hacker News";
        self.url = [NSURL URLWithString:@"https://news.ycombinator.com"];
        
        //Set this so custom "HNTouchableView" won't have delays when calling "touchesBegan"
        self.tableView.delaysContentTouches = NO;
        
        webBrowserVC = webVC;
        commentVC = commVC;
        articleContainerVC = articleContainer;
        
        downloadController = [[HNDownloadController alloc] init];
        isDownloadAppending = NO;
        shouldScrollToTopAfterDownload = NO;
        
        //This is an example of the site when there is a "black bar" on the header (i.e. a famous tech person died
        //downloadController = [[HNDownloadController alloc] initWithUrl:@"http://www.waybackletter.com/archive/20111005.html"];
        
        downloadController.downloadDelegate = self;
        self.theme = theTheme;
        
        //Get article cache
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"articles"])
        {
            NSData *articlesArchive = [[NSUserDefaults standardUserDefaults] objectForKey:@"articles"];
            self.articles = [NSKeyedUnarchiver unarchiveObjectWithData:articlesArchive];
            [self.tableView reloadData];
        }
        
        
        
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            //Make sure separator lines go all the way across in iOS 7
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
            //Also make sure "scroll to top" functionality doesn't scroll too far
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Setup the pull-to-refresh control
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(downloadFreshArticles) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    //Register custom tableviewcell class with tableview
    [self.tableView registerClass:[HNArticleCell class] forCellReuseIdentifier:@"Cell"];
    
    
    //[self downloadFreshArticles];
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self downloadFreshArticles];
    
}

- (BOOL) shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

-(void) setUrl:(NSURL *)newUrl andTitle:(NSString *)title
{
    self.url = newUrl;
    self.title = title;
    
    [self downloadFreshArticles];
    
    shouldScrollToTopAfterDownload = YES;
}

- (void) downloadFreshArticles
{
    [self downloadFrontPageArticles:NO];
}

- (void) downloadFrontPageArticles:(BOOL)append
{
    NSURL *downloadUrl = nil;
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Updating..."];
    
    if (append)
    {
        isDownloadAppending = YES;
        downloadUrl= self.moreArticlesUrl;
    }
    else
    {
        isDownloadAppending = NO;
        downloadUrl = self.url;
    }
   
    [downloadController beginDownload:downloadUrl];
    
}

- (void) scrollToTop
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    shouldScrollToTopAfterDownload = NO;
}

#pragma mark HNDownloadControllerDelegate

-(void) downloadDidComplete:(id)data
{
    NSArray *parsedArticles = [HNParser parseArticles:data];
    
    //Update articles array
    [self updateArticlesInTable:parsedArticles];
    
    //Update the "more articles" link
    [self updateGetMoreArticlesLink:data];
    
    //Reload data in the table
    [self.tableView reloadData];
    
    //Scroll to top if necessary
    if (shouldScrollToTopAfterDownload)
    {
        [self scrollToTop];
    }
    
    //Update cache
    if (parsedArticles)
    {
        NSData *articlesArchive = [NSKeyedArchiver archivedDataWithRootObject:parsedArticles];
        [[NSUserDefaults standardUserDefaults] setObject:articlesArchive forKey:@"articles"];
    }
    
    
    //Update refresh control
    [self.refreshControl endRefreshing];
    self.refreshControl.attributedTitle = [HNUtils getTimeUpdatedString];
}

-(void) updateArticlesInTable:(NSArray *)parsedArticles
{
    if (parsedArticles)
    {
        if (isDownloadAppending)
        {
            NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.articles];
            [tempArray addObjectsFromArray:parsedArticles];
        
            self.articles = tempArray;
        }
        else
        {
            self.articles = parsedArticles;
        }
    }
    
}

-(void) updateGetMoreArticlesLink:(NSData *)data
{
    NSString *newPath = [HNParser getMoreArticlesLink:data];
    if (newPath)
    {
        self.moreArticlesUrl = [[NSURL alloc] initWithScheme:self.url.scheme host:self.url.host path:newPath];
    }
    
}

-(void) downloadFailed
{
    NSLog(@"Download failed!");
    shouldScrollToTopAfterDownload = NO;
}

#pragma mark HNArticleCellDelegate

/*
 Determine if a url is a "self" post, i.e. the "article" is just a local URL to the comments
 page, which normally includes a some text content at the header.
 */
-(BOOL)isSelfPost:(NSString *)newUrl
{
    NSString *selfPost = [HNParser getMatch:newUrl fromRegex:@"(^item\\?id=\\d+$)"];
    
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

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selcted!!");
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset < 200 && !self.downloadController.isDownloading)
    {
        NSLog(@"load MOAR!");
        
        [self downloadFrontPageArticles:YES];
    }
}

@end
