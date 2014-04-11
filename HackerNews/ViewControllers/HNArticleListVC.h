//
//  HNArticleListVC.h
//  HackerNews
//
//  Created by Matthew Stanford on 8/29/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNWebBrowserVC.h"
#import "HNDownloadController.h"
#import "HNArticleCell.h"
#import "HNCommentVC.h"
#import "HNLinkGetter.h"

@class HNArticleContainerVC;
@class HNTheme;
@class MMDrawerController;

@interface HNArticleListVC : UITableViewController  <downloadControllerDelegate, HNArticleCellDelegate, HNLinkGetterDelegate, UISplitViewControllerDelegate>
{
    NSArray *articles;
    HNWebBrowserVC *webBrowserVC;
    HNCommentVC *commentVC;
    HNDownloadController *downloadController;
    HNArticleContainerVC *articleContainerVC;
    
    HNTheme *theme;
    
    NSURL *url;
    NSURL *moreArticlesUrl;
    BOOL isDownloadAppending;
    BOOL shouldScrollToTopAfterDownload;
    
    HNLinkGetter *linkGetter;
    int currentPage;
}

- (id)initWithStyle:(UITableViewStyle)style withWebBrowserVC:(HNWebBrowserVC *)webVC andCommentVC:(HNCommentVC *)commVC articleContainer:(HNArticleContainerVC *)articleContainer withTheme:(HNTheme *)theTheme withDrawerController:(MMDrawerController *)drawerController;
- (id)initWithStyle:(UITableViewStyle)style withWebBrowserVC:(HNWebBrowserVC *)webVC andCommentVC:(HNCommentVC *)commVC articleContainer:(HNArticleContainerVC *)articleContainer withTheme:(HNTheme *)theTheme;
- (void) downloadFreshArticles;
- (void) setUrl:(NSURL *)newUrl andTitle:(NSString *)title;
- (void) closeDrawer;

@property (strong, nonatomic) NSArray *articles;
@property (strong, nonatomic) HNArticleContainerVC *articleContainerVC;
@property (strong, nonatomic) HNWebBrowserVC *webBrowserVC;
@property (strong, nonatomic) HNCommentVC *commentVC;
@property (strong, nonatomic) HNDownloadController *downloadController;
@property (strong, nonatomic) HNTheme *theme;
@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSURL *moreArticlesUrl;
@property (assign, nonatomic) BOOL isDownloadAppending;
@property (assign, nonatomic) BOOL shouldScrollToTopAfterDownload;
@property (strong, nonatomic) HNLinkGetter *linkGetter;
@property (assign, nonatomic) int currentPage;

@end
