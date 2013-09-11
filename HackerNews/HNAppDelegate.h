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

@class HNArticleListVC;
@class HNWebBrowserVC;
@class HNCommentVC;

@interface HNAppDelegate : UIResponder <UIApplicationDelegate>
{    
    UIWindow *window;
    UINavigationController *navController;
    HNArticleListVC *articleListVC;
    HNWebBrowserVC *webBrowserVC;
    HNCommentVC *commentVC;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) HNArticleListVC *articleListVC;
@property (strong, nonatomic) HNWebBrowserVC *webBrowserVC;
@property (strong, nonatomic) HNCommentVC *commentVC;

@end
