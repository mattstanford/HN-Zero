//
//  HNWebBrowserVC.h
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNTheme;

@interface HNWebBrowserVC : UIViewController <UIWebViewDelegate>
{
    UIWebView *webView;
    NSString *currentURL;
    UIView *bottomBarView;
    
    UIButton *navigateBackButton;
    UIButton *navigateForwardButton;
    int historyPosition;
    int historyLength;
    
    HNTheme *theme;
}

- (id)initWithTheme:(HNTheme *)theTheme;
- (void) setURL:(NSString *)newUrl forceUpdate:(BOOL)doForceUpdate;

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *currentURL;
@property (strong, nonatomic) UIView *bottomBarView;
@property (strong, nonatomic) UIButton *navigateBackButton;
@property (strong, nonatomic) UIButton *navigateForwardButton;
@property (assign, nonatomic) int historyPosition;
@property (assign, nonatomic) int historyLength;
@property (strong, nonatomic) HNTheme *theme;


@end
