//
//  HNThemedViewController.h
//  HN Zero
//
//  Created by Matt Stanford on 1/13/17.
//  Copyright © 2017 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNTheme.h"

@protocol HNThemedViewController <NSObject>

@required
-(void)changeTheme:(HNTheme *)theme;


@end
