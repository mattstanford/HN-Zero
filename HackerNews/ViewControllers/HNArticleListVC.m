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
#import "HNWebBrowserVC.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"
#import "HNIconDownloadController.h"
#import <MMDrawerController/MMDrawerController.h>
#import <MMDrawerBarButtonItem.h>
#import "HNSettings.h"

@interface HNArticleListVC ()

@property (strong, nonatomic) NSMutableArray *articles;
@property (strong, nonatomic) HNArticleContainerVC *articleContainerVC;
@property (strong, nonatomic) HNWebBrowserVC *webBrowserVC;
@property (strong, nonatomic) HNCommentVC *commentVC;
@property (strong, nonatomic) HNDownloadController *articleListDownloadController;
@property (strong, nonatomic) HNTheme *theme;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSURL *moreArticlesUrl;
@property (assign, nonatomic) BOOL isDownloadAppending;
@property (assign, nonatomic) BOOL shouldScrollToTopAfterDownload;
@property (strong, nonatomic) HNLinkGetter *linkGetter;
@property (assign, nonatomic) int currentPage;
@property (nonatomic, weak) MMDrawerController *drawerControllerDelegate;
@property (nonatomic, strong) HNIconDownloadController *iconDownloadController;
@property (assign, nonatomic) BOOL isScrolling;
@property (nonatomic, strong) HNSettings *settings;

@end

@implementation HNArticleListVC

- (id)initWithStyle:(UITableViewStyle)style
   withWebBrowserVC:(HNWebBrowserVC *)webVC
       andCommentVC:(HNCommentVC *)commVC
   articleContainer:(HNArticleContainerVC *)articleContainer
          withTheme:(HNTheme *)theTheme
withDrawerController:(MMDrawerController *)drawerController
withDownloadController:(HNDownloadController *)downloadController
        andSettings:(HNSettings *)settings
{
    self = [super init];
    if (self)
    {
        self.drawerControllerDelegate = drawerController;
        
        self = [self initWithStyle:style
                  withWebBrowserVC:webVC
                      andCommentVC:self.commentVC
                  articleContainer:articleContainer
                         withTheme:theTheme
            withDownloadController:downloadController
                andSettings:settings];
        
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
   withWebBrowserVC:(HNWebBrowserVC *)webVC
       andCommentVC:(HNCommentVC *)commVC
   articleContainer:(HNArticleContainerVC *)articleContainer
          withTheme:(HNTheme *)theTheme
withDownloadController:(HNDownloadController *)downloadController
        andSettings:(HNSettings *)settings
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.title = @"Hacker News";
        self.url = [NSURL URLWithString:@"https://news.ycombinator.com"];
        
        //Set this so custom "HNTouchableView" won't have delays when calling "touchesBegan"
        self.tableView.delaysContentTouches = NO;
        
        //Delegate for UIScrollViewDelegate
        self.tableView.delegate = self;
        
        self.webBrowserVC = webVC;
        self.commentVC = commVC;
        self.articleContainerVC = articleContainer;
        
        self.iconDownloadController = [[HNIconDownloadController alloc] init];
        self.articleListDownloadController = downloadController;
        self.isDownloadAppending = NO;
        self.shouldScrollToTopAfterDownload = NO;
        
//        self.linkGetter = [[HNLinkGetter alloc] init];
//        self.linkGetter.linkGetterDelegate = self;
        self.currentPage = 0;
        
        //This is an example of the site when there is a "black bar" on the header (i.e. a famous tech person died
        //downloadController = [[HNDownloadController alloc] initWithUrl:@"http://www.waybackletter.com/archive/20111005.html"];
        
        self.articleListDownloadController.articleDownloadDelegate = self;
        self.theme = theTheme;
        
        //Get article cache
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"articles"])
//        {
//            NSData *articlesArchive = [[NSUserDefaults standardUserDefaults] objectForKey:@"articles"];
//            self.articles = [NSKeyedUnarchiver unarchiveObjectWithData:articlesArchive];
//            [self.tableView reloadData];
//        }
        
        
        
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            //Make sure separator lines go all the way across in iOS 7
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
            //Also make sure "scroll to top" functionality doesn't scroll too far
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
        self.tableView.backgroundColor = self.theme.tableViewBackgroundColor;
        self.tableView.separatorColor = self.theme.infoColor;
        
        self.settings = settings;
        
    }
    return self;
}

#pragma mark View lifecycle

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Google analytics tracking
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Article List"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
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
    
    //iPad specific
    if (self.drawerControllerDelegate)
    {
        MMDrawerBarButtonItem *hamburgerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(hamburgerPushed:)];
        //UIBarButtonItem *hamburgerButton = [[UIBarButtonItem alloc] initWithTitle:@"Hambuger!" style:UIBarButtonItemStylePlain target:self action:@selector(hamburgerPushed:)];
        [[self navigationItem] setLeftBarButtonItem:hamburgerButton];
    }
}

- (BOOL) shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark Custom methods

-(void) hamburgerPushed:(id)sender
{
    [self.drawerControllerDelegate toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
   
}

-(void) closeDrawer
{
    [self.drawerControllerDelegate closeDrawerAnimated:YES completion:nil];
}

-(void) setUrl:(NSURL *)newUrl andTitle:(NSString *)title
{
    self.url = newUrl;
    self.title = title;
    
    [self downloadFreshArticles];
    
    self.shouldScrollToTopAfterDownload = YES;
}

- (void) downloadFreshArticles
{
    //Reset download controller so pending downloads won't try to update on our "fresh" list
    self.articleListDownloadController.articleDownloadDelegate = nil;
    self.articleListDownloadController = [[HNDownloadController alloc] init];
    self.articleListDownloadController.articleDownloadDelegate = self;
    self.articleListDownloadController.settings = _settings;
    
    [self.commentVC resetDownloadController:self.articleListDownloadController];
    
    [self downloadFrontPageArticles:NO];
}

- (void) downloadFrontPageArticles:(BOOL)append
{
    NSURL *downloadUrl = nil;
    NSDictionary *attributes = @ {NSForegroundColorAttributeName : self.theme.titleTextColor};

    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:@"Updating..." attributes:attributes];
    self.refreshControl.attributedTitle = titleString;
    
    if (append)
    {
        if(self.moreArticlesUrl)
        {
            self.isDownloadAppending = YES;
            downloadUrl= self.moreArticlesUrl;
        }
        
    }
    else
    {
        self.isDownloadAppending = NO;
        downloadUrl = self.url;
    }
   
    [self.articleListDownloadController beginArticleDownload:downloadUrl];
    
}

- (void) scrollToTop
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    self.shouldScrollToTopAfterDownload = NO;
}

#pragma mark HNDownloadControllerDelegate

-(void) didGetArticleIds
{
    //Update refresh control
    _articles = [[NSMutableArray alloc] init];
    [self.tableView reloadData];
    
    [self.refreshControl endRefreshing];
    
    NSString *updateString = [HNUtils getTimeUpdatedString];
    NSDictionary *attributes = @{NSForegroundColorAttributeName: self.theme.titleTextColor};
    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:updateString attributes:attributes];
    self.refreshControl.attributedTitle = titleString;
}

-(void) didGetArticle:(HNArticle *)article
{
    //NSLog(@"Got article!");
    [_articles addObject:article];
    
    if (_isScrolling == FALSE)
    {
        [self.tableView reloadData];
    }
}

-(void) didGetArticleWithComments:(HNArticle *)article
{
    for (NSInteger j=0; j < article.comments.count; j++)
    {
        HNArticle *articleCandidate = [_articles objectAtIndex:j];
        if ([article.objectId isEqualToNumber:articleCandidate.objectId])
        {
            [_articles replaceObjectAtIndex:j withObject:article];
            
            if (_isScrolling == FALSE)
            {
                [self.tableView reloadData];
            }

            break;
        }
    }
}

//-(void) downloadDidComplete:(id)data downloadController:(HNDownloadController *)downloadController
//{
//    if (downloadController == self.articleListDownloadController)
//    {
//        [self articleListDownloadComplete:data];
//    }
//}

-(void) allArticlesDownloaded:(id)data
{
    NSArray *parsedArticles = [HNParser parseArticles:data];
    
    if (parsedArticles.count > 0)
    {
        [self updateArticlesInTable:parsedArticles];
        
        //Update the "more articles" link
        [self updateGetMoreArticlesLink:data];
        
        //Reload data in the table
        [self.tableView reloadData];
        
        //Scroll to top if necessary
        if (self.shouldScrollToTopAfterDownload)
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
        
        NSString *updateString = [HNUtils getTimeUpdatedString];
        NSDictionary *attributes = @{NSForegroundColorAttributeName: self.theme.titleTextColor};
        NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:updateString attributes:attributes];
        self.refreshControl.attributedTitle = titleString;
        
    }
    else
    {
        /*
         No parsed articles means the "more articles link" could be expired
        If we successfully get a new link, the callback for this function will
        try to download again
         */
        [self.linkGetter getCurrentMoreArticlesUrlForPage:self.currentPage];
        
    }

}

//#pragma mark LinkGetter Delegate
//
//-(void) didGetLink:(NSURL *)linkUrl
//{
//    NSLog(@"Got new link: %@", linkUrl);
//    [self.articleListDownloadController beginDownload:linkUrl];
//}
//
//-(void) didFailToGetLink
//{
//    NSLog(@"Link getter failed to get more articles URL!");
//}
//
//
//-(void) downloadFailed
//{
//    NSLog(@"Download failed!");
//    self.shouldScrollToTopAfterDownload = NO;
//}

#pragma mark HNArticleCellDelegate

-(void) didTapArticle:(HNArticleCell *)cellTapped
{
    
    NSInteger index = [cellTapped tag];
    
    if (index >= 0 && index <= [self.articles count])
    {
        HNArticle *article = [self.articles objectAtIndex:index];
        
        //if ([HNParser isSelfPost:article.url])
        if ([article isSelfPost])
        {
            [self didTapComment:cellTapped];
        }
        else
        {
            [self.articleContainerVC doPresentArticle:article onClearBlock:^{
                [self presentArticleOrComment];
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    [self.articleContainerVC.articleVC loadPendingUrl];
                }
                
            }];
        }

    }
}

-(void) didTapComment:(HNArticleCell *)cellTapped
{
    NSInteger index = [cellTapped tag];
    
    if (index >= 0 && index <= [self.articles count])
    {
        HNArticle *article = [self.articles objectAtIndex:index];

        [self.articleContainerVC doPresentCommentForArticle:article];
        [self presentArticleOrComment];
        
    }
}

-(void) presentArticleOrComment
{
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
    {
        [self.navigationController pushViewController:self.articleContainerVC animated:YES];
    }
}

#pragma mark - UIScrollView delegate

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isScrolling = TRUE;
}

-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _isScrolling = FALSE;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
       return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.articles count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNArticle *article = [self.articles objectAtIndex:indexPath.row];
    
    return [HNArticleCell getCellHeightForWidth:self.view.frame.size.width withArticle:article withTitleFont:self.theme.articleTitleFont withInfoFont:self.theme.articleInfoFont];
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
    cell.backgroundColor = self.theme.cellBackgroundColor;
    cell.articleTitleLabel.text = article.title;
    cell.infoLabel.text = [article getInfoText];
    cell.delegate = self;
    cell.tag = indexPath.row;
    
    if([article.type isEqualToString:@"story"])
    {
        cell.commentViewDisabled = FALSE;
        
        if (article.numComments == nil)
        {
            cell.numCommentsLabel.text = @" ";
        }
        else
        {
            cell.numCommentsLabel.text = article.numComments;
        }
    }
    else
    {
        cell.commentViewDisabled = TRUE;
    }
    
    cell.articleTitleLabel.font = self.theme.articleTitleFont;
    cell.articleTitleLabel.textColor = self.theme.titleTextColor;
    cell.infoLabel.font = self.theme.articleInfoFont;
    cell.infoLabel.textColor = self.theme.infoColor;
    cell.numCommentsLabel.font = self.theme.articleNumCommentsFont;
    cell.numCommentsLabel.textColor = self.theme.titleTextColor;
    
    
    if ([article isSelfPost])
    {
        cell.domainIconImageView.image = [UIImage imageNamed:@"default_icon.png"];
    }
    else if (article.domainName && ![article.domainName isEqualToString:@""] && article.image == nil)
    {
       /* NSString *iconUrl = [NSString stringWithFormat:@"http://www.google.com/s2/favicons?domain=%@", article.domainName];
        NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:iconUrl]];
        UIImage* image = [[UIImage alloc] initWithData:imageData];
        cell.domainIconImageView.image = image;*/
        
        cell.domainIconImageView.image = [UIImage imageNamed:@"default_icon.png"];
        
        [self.iconDownloadController getGoogleIcon:article.domainName success:^(UIImage *image) {
            article.image = image;
            cell.domainIconImageView.image = image;
        }];
//        [self.iconDownloadController downloadIcon:article.domainName
//            success:^(NSData *imageData){
//            
//                NSLog(@"Got icon!");
//                
//                UIImage* image = [[UIImage alloc] initWithData:imageData];
//                cell.domainIconImageView.image = image;
//            }];
    }
    else
    {
        cell.domainIconImageView.image = article.image;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selcted!!");
}

//-(void) scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSInteger currentOffset = scrollView.contentOffset.y;
//    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
//    
//    if (maximumOffset - currentOffset < 200 && !self.articleListDownloadController.isDownloading && ![self.linkGetter isGettingNewLink])
//    {
//        NSLog(@"load MOAR!");
//        
//        [self downloadFrontPageArticles:YES];
//    }
//}

#pragma mark Helper functions

-(void) updateArticlesInTable:(NSArray *)parsedArticles
{
    
    if (self.isDownloadAppending)
    {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.articles];
        [tempArray addObjectsFromArray:parsedArticles];
        
        self.articles = tempArray;
        self.currentPage++;
    }
    else
    {
        self.articles = parsedArticles;
        self.currentPage = 0;
    }
}

-(void) updateGetMoreArticlesLink:(NSData *)data
{
    NSString *newPath = [HNParser getMoreArticlesLink:data];
    if (newPath)
    {
        self.moreArticlesUrl = [[NSURL alloc] initWithScheme:self.url.scheme host:self.url.host path:newPath];
    }
    else
    {
        self.moreArticlesUrl = nil;
    }
    
}


#pragma mark HNThemedViewController

-(void)changeTheme:(HNTheme *)theme
{
    self.theme = theme;
    self.tableView.backgroundColor = self.theme.tableViewBackgroundColor;
    self.tableView.separatorColor = self.theme.infoColor;
    [self.tableView reloadData];
}
     
     
     
     



@end
