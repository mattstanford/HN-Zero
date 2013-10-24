//
//  HNWebBrowserVC.h
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNWebBrowserVC : UIViewController <UIWebViewDelegate>
{
    UIWebView *webView;
    NSString *currentURL;
}

- (void) setURL:(NSString *)newUrl forceUpdate:(BOOL)doForceUpdate;

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *currentURL;


@end
