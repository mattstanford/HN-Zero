//
//  HNAppDelegate.h
//  HackerNews
//
//  Created by Matthew Stanford on 8/24/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNArticleListVC.h"
#import "HNWebBrowserVC.h"
#import "HNCommentVC.h"
#import <MGSplitViewController/MGSplitViewController.h>

@class HNArticleListVC;
@class HNWebBrowserVC;
@class HNCommentVC;
@class HNTheme;
@class HNArticleContainerVC;
@class HNMainMenu;

@interface HNAppDelegate : UIResponder <UIApplicationDelegate>
{    
    UIWindow *window;
    UINavigationController *navController;
    HNArticleListVC *articleListVC;
    HNWebBrowserVC *webBrowserVC;
    HNWebBrowserVC *commentWebBrowserVC;
    HNCommentVC *commentVC;
    HNTheme *theme;
    HNArticleContainerVC *articleContainerVC;
    HNMainMenu *mainMenuVC;
    
    MGSplitViewController *splitVC;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) HNArticleListVC *articleListVC;
@property (strong, nonatomic) HNWebBrowserVC *webBrowserVC;
@property (strong, nonatomic) HNWebBrowserVC *commentWebBrowserVC;
@property (strong, nonatomic) HNCommentVC *commentVC;
@property (strong, nonatomic) HNTheme *theme;
@property (strong, nonatomic) HNArticleContainerVC *articleContainerVC;
@property (strong, nonatomic) HNMainMenu *mainMenuVC;
@property (strong, nonatomic) MGSplitViewController *splitVC;

@end
