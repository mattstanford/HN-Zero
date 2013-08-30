//
//  HNAppDelegate.h
//  HackerNews
//
//  Created by Matthew Stanford on 8/24/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNArticleListVC.h""

@class HNArticleListVC;

@interface HNAppDelegate : UIResponder <UIApplicationDelegate>
{    
    UIWindow *window;
    HNArticleListVC *articleListVC;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HNArticleListVC *articleListVC;

@end
