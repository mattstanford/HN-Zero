//
//  HNWebBrowserVC.m
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNWebBrowserVC.h"

@interface HNWebBrowserVC ()

@end

@implementation HNWebBrowserVC

@synthesize webView, currentURL;

- (id)init {
    
    self = [super init];
    if (self) {
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        
        webView = [[UIWebView alloc] initWithFrame:screenBounds];
        webView.delegate = self;
        webView.scalesPageToFit = YES;
        [self.view addSubview:webView];
        
        currentURL = @"http://news.ycombinator.com";
        
    }
    return self;
}

- (BOOL) shouldAutorotate
{
    return YES;
}

- (NSUInteger) supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void) viewWillLayoutSubviews
{   
    self.webView.frame = self.view.frame;
}

- (void) setURL:(NSString *)newUrl forceUpdate:(BOOL)doForceUpdate
{
    if(doForceUpdate || ![newUrl isEqualToString:self.currentURL])
    {
        [self loadUrl:@"about:blank"];
        [self loadUrl:newUrl];
    }
}

- (void) loadUrl:(NSString *)newUrl
{
    NSURL *url = [NSURL URLWithString:newUrl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    currentURL = newUrl;
    [webView loadRequest:requestObj];
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
  //  NSLog(@"started loading page");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
  //  NSLog(@"finished loading page");
}

@end
