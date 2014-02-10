//
//  HNWebBrowserVC.h
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNTheme;

typedef NS_OPTIONS(NSUInteger, bottomBarStatus) {
    BOTTOM_BAR_HISTORY_EXISTS = (1 << 0),
    BOTTOM_BAR_STATUS_SHOWING = (1 << 1)
};

@interface HNWebBrowserVC : UIViewController <UIWebViewDelegate>
{
    UIWebView *webView;
    NSString *currentURL;
    UIView *bottomBarView;
    
    UIButton *navigateBackButton;
    UIButton *navigateForwardButton;
    UILabel *connectionStatusLabel;
    
    bottomBarStatus bottomBarMask;
    
    int historyPosition;
    int historyLength;
    BOOL isLoadingNewPage;
    
    BOOL isForwardNavActive;
    BOOL isBackwardNavActive;
    
    BOOL isBottomBarShowing;
    
    HNTheme *theme;
}

- (id)initWithTheme:(HNTheme *)theTheme;
- (void) setURL:(NSString *)newUrl forceUpdate:(BOOL)doForceUpdate;

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *currentURL;
@property (strong, nonatomic) UIView *bottomBarView;
@property (strong, nonatomic) UIButton *navigateBackButton;
@property (strong, nonatomic) UIButton *navigateForwardButton;
@property (strong, nonatomic) UILabel *connectionStatusLabel;
@property (assign, nonatomic) bottomBarStatus bottomBarMask;
@property (assign, nonatomic) int historyPosition;
@property (assign, nonatomic) int historyLength;
@property (assign, nonatomic) BOOL isLoadingNewPage;
@property (assign, nonatomic) BOOL isForwardNavActive;
@property (assign, nonatomic) BOOL isBackwardNavActive;
@property (assign, nonatomic) BOOL isBottomBarShowing;
@property (strong, nonatomic) HNTheme *theme;


@end
