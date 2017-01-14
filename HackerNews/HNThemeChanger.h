//
//  HNThemeChanger.h
//  HN Zero
//
//  Created by Matt Stanford on 1/13/17.
//  Copyright © 2017 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNThemedViewController.h"

@class HNTheme;

@interface HNThemeChanger : UIView

-(void)switchViewsToTheme:(HNTheme *)theme;
-(void)addThemedViewController:(UIViewController<HNThemedViewController> *)viewController;

@end
