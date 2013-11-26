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

@class HNArticleContainerVC;
@class HNTheme;

@interface HNArticleListVC : UITableViewController  <downloadControllerDelegate, HNArticleCellDelegate>
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
}

- (id)initWithStyle:(UITableViewStyle)style withWebBrowserVC:(HNWebBrowserVC *)webVC andCommentVC:(HNCommentVC *)commVC articleContainer:(HNArticleContainerVC *)articleContainer withTheme:(HNTheme *)theTheme;
- (void) downloadFreshArticles;
- (void) setUrl:(NSURL *)newUrl andTitle:(NSString *)title;

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

@end
