//
//  HNWebBrowserVC.h
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNThemedViewController.h"

@class HNTheme;
@class HNConnectionStatusLabel;

typedef NS_OPTIONS(NSUInteger, bottomBarStatus) {
    BOTTOM_BAR_HISTORY_EXISTS = (1 << 0),
    BOTTOM_BAR_STATUS_SHOWING = (1 << 1)
};

@interface HNWebBrowserVC : UIViewController <UIWebViewDelegate, HNThemedViewController>

- (id)initWithTheme:(HNTheme *)theTheme;
- (void) setURL:(NSString *)newUrl forceUpdate:(BOOL)doForceUpdate onClearBlock:(void (^)())clearBlock;
- (void) loadPendingUrl;


@end
