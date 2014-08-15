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
#import <MGSplitViewController/MGSplitViewController.h>

@class HNArticleContainerVC;
@class HNTheme;
@class MMDrawerController;

@interface HNArticleListVC : UITableViewController  <downloadControllerDelegate, HNArticleCellDelegate, HNLinkGetterDelegate, MGSplitViewControllerDelegate>

- (id)initWithStyle:(UITableViewStyle)style withWebBrowserVC:(HNWebBrowserVC *)webVC andCommentVC:(HNCommentVC *)commVC articleContainer:(HNArticleContainerVC *)articleContainer withTheme:(HNTheme *)theTheme withDrawerController:(MMDrawerController *)drawerController;
- (id)initWithStyle:(UITableViewStyle)style withWebBrowserVC:(HNWebBrowserVC *)webVC andCommentVC:(HNCommentVC *)commVC articleContainer:(HNArticleContainerVC *)articleContainer withTheme:(HNTheme *)theTheme;
- (void) downloadFreshArticles;
- (void) setUrl:(NSURL *)newUrl andTitle:(NSString *)title;
- (void) closeDrawer;



@end
