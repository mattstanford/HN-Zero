//
//  HNUiUtils.h
//  HN Zero
//
//  Created by Matt Stanford on 9/22/14.
//  Copyright (c) 2014 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNTheme;

@interface HNUiUtils : NSObject

+ (void) setTitleBarColors:(HNTheme *)theTheme withNavController:(UINavigationController *)theNavController;

@end
