//
//  HNUiUtils.m
//  HN Zero
//
//  Created by Matt Stanford on 9/22/14.
//  Copyright (c) 2014 Matthew Stanford. All rights reserved.
//

#import "HNUiUtils.h"
#import "HNTheme.h"

@implementation HNUiUtils

+ (void) setTitleBarColors:(HNTheme *)theTheme withNavController:(UINavigationController *)theNavController
{
    if ([theNavController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
    {
        NSDictionary *navTextAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor whiteColor], UITextAttributeTextColor,
                                      nil];
        
        theNavController.navigationBar.titleTextAttributes = navTextAttrs;
        theNavController.navigationBar.barTintColor = theTheme.titleBarColor;
        theNavController.navigationBar.tintColor = theTheme.titleBarTextColor;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
    }
    else
    {
        theNavController.navigationBar.tintColor = theTheme.titleBarColor;
    }
    
}

@end
