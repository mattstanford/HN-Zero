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

@synthesize webView, currentURL, bottomBarView, navigateBackButton, navigateForwardButton, historyPosition, historyLength;

static const CGFloat BOTTOM_BAR_HEIGHT = 30;

- (id)init {
    
    self = [super init];
    if (self) {
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        
        webView = [[UIWebView alloc] initWithFrame:screenBounds];
        webView.delegate = self;
        webView.scalesPageToFit = YES;
        [self.view addSubview:webView];
        
        bottomBarView = [[UIView alloc] initWithFrame:CGRectZero];
        bottomBarView.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:bottomBarView];
        
        navigateBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [navigateBackButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchDown];
        [bottomBarView addSubview:navigateBackButton];
        
        navigateForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [navigateForwardButton addTarget:self action:@selector(forwardButtonTouched) forControlEvents:UIControlEventTouchDown];
        [bottomBarView addSubview:navigateForwardButton];
        
        [self resetNavButtons];
        
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
    CGFloat webViewHeight = self.view.frame.size.height - BOTTOM_BAR_HEIGHT;
    
    self.webView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, webViewHeight);
    self.bottomBarView.frame = CGRectMake(0, webViewHeight, self.view.frame.size.width , BOTTOM_BAR_HEIGHT);
    
    //Add navigation buttons to bottom bar
    CGFloat navigateButtonHeight = BOTTOM_BAR_HEIGHT - 15;
    CGFloat navigateButtonWidth = navigateButtonHeight;
    CGFloat backNavigateButtonX = 10;
    CGFloat forwardNavigateButtonX = backNavigateButtonX + navigateButtonWidth + 15;
    CGFloat navigateButtonY = (BOTTOM_BAR_HEIGHT / 2) - (navigateButtonHeight / 2);
    
    self.navigateBackButton.frame = CGRectMake(backNavigateButtonX, navigateButtonY, navigateButtonWidth, navigateButtonHeight);
    self.navigateForwardButton.frame = CGRectMake(forwardNavigateButtonX, navigateButtonY, navigateButtonWidth, navigateButtonHeight);
    
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        [self activateBackNavButton];
        historyPosition++;
        
        if (historyPosition > historyLength)
        {
            historyLength = historyPosition;
        }
    }
    
    return TRUE;
}

- (void) resetNavButtons
{
    historyPosition = 0;
    historyLength = 0;
    
    //Set images
    [self deactivateBackNavButton];
    [self deactivateForwardNavButton];
}

- (void) activateBackNavButton
{
    [navigateBackButton setImage:[UIImage imageNamed:@"triangle-reverse.png"] forState:UIControlStateNormal];
    [navigateBackButton setImage:[UIImage imageNamed:@"triangle-blue-reverse.png"] forState:UIControlStateHighlighted];
}

- (void) activateForwardNavButton
{
    [navigateForwardButton setImage:[UIImage imageNamed:@"triangle"] forState:UIControlStateNormal];
    [navigateForwardButton setImage:[UIImage imageNamed:@"triangle-blue"] forState:UIControlStateHighlighted];
    
}

- (void) deactivateBackNavButton
{
    [navigateBackButton setImage:[UIImage imageNamed:@"triangle-grey-reverse.png"] forState:UIControlStateNormal];
    [navigateBackButton setImage:[UIImage imageNamed:@"triangle-grey-reverse.png"] forState:UIControlStateHighlighted];
}

- (void) deactivateForwardNavButton
{
    [navigateForwardButton setImage:[UIImage imageNamed:@"triangle-grey.png"] forState:UIControlStateNormal];
    [navigateForwardButton setImage:[UIImage imageNamed:@"triangle-grey.png"] forState:UIControlStateHighlighted];
}

- (void) backButtonTouched
{
    if (historyPosition > 0)
    {
        historyPosition--;
        [self.webView goBack];
        
        [self activateForwardNavButton];
        
        if (historyPosition == 0)
        {
            [self deactivateBackNavButton];
        }
        
    }
}

- (void) forwardButtonTouched
{
    if (historyPosition < historyLength)
    {
        historyPosition++;
        [self.webView goForward];
        
        [self activateBackNavButton];
        
        if (historyPosition == historyLength)
        {
            [self deactivateForwardNavButton];
        }
    }
}

- (void) setURL:(NSString *)newUrl forceUpdate:(BOOL)doForceUpdate
{
    if(doForceUpdate || historyLength > 0 || ![newUrl isEqualToString:self.currentURL])
    {
        [self resetNavButtons];
        
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
