//
//  HNNavigationViewController.m
//  HN Zero
//
//  Created by Matt Stanford on 1/13/17.
//  Copyright © 2017 Matthew Stanford. All rights reserved.
//

#import "HNNavigationViewController.h"

@interface HNNavigationViewController ()

@end

@implementation HNNavigationViewController

-(void)changeTheme:(HNTheme *)theme
{
    if ([self.navigationBar respondsToSelector:@selector(setBarTintColor:)])
    {
        NSDictionary *navTextAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor whiteColor], UITextAttributeTextColor,
                                      nil];
        
        self.navigationBar.titleTextAttributes = navTextAttrs;
        self.navigationBar.barTintColor = theme.titleBarColor;
        self.navigationBar.tintColor = theme.titleBarTextColor;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
    }
    else
    {
        self.navigationBar.tintColor = theme.titleBarColor;
    }
}

@end
