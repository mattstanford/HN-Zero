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
#import "HNThemedViewController.h"

@class HNArticleContainerVC;
@class HNTheme;
@class MMDrawerController;
@class HNSettings;

@interface HNArticleListVC : UITableViewController  <articleDownloadDelegate, HNArticleCellDelegate, UIScrollViewDelegate, HNThemedViewController>

- (id)initWithStyle:(UITableViewStyle)style
   withWebBrowserVC:(HNWebBrowserVC *)webVC
       andCommentVC:(HNCommentVC *)commVC
   articleContainer:(HNArticleContainerVC *)articleContainer
          withTheme:(HNTheme *)theTheme
withDrawerController:(MMDrawerController *)drawerController
withDownloadController:(HNDownloadController *)downloadController
        andSettings:(HNSettings *)settings;

- (id)initWithStyle:(UITableViewStyle)style
   withWebBrowserVC:(HNWebBrowserVC *)webVC
       andCommentVC:(HNCommentVC *)commVC
   articleContainer:(HNArticleContainerVC *)articleContainer
          withTheme:(HNTheme *)theTheme
withDownloadController:(HNDownloadController *)downloadController
        andSettings:(HNSettings *)settings;

- (void) downloadFreshArticles;
- (void) setUrl:(NSURL *)newUrl andTitle:(NSString *)title;
- (void) closeDrawer;



@end
