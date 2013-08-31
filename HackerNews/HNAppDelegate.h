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

@class HNArticleListVC;
@class HNWebBrowserVC;

@interface HNAppDelegate : UIResponder <UIApplicationDelegate>
{    
    UIWindow *window;
    HNArticleListVC *articleListVC;
    HNWebBrowserVC *webBrowserVC;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HNArticleListVC *articleListVC;
@property (strong, nonatomic) HNWebBrowserVC *webBrowserVC;

@end
