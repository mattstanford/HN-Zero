//
//  HNWebBrowserVC.m
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNWebBrowserVC.h"
#import "HNTheme.h"

@interface HNWebBrowserVC ()

@end

@implementation HNWebBrowserVC

@synthesize webView, currentURL, bottomBarView, navigateBackButton, navigateForwardButton, connectionStatusLabel, bottomBarMask, historyPosition, historyLength, isLoadingNewPage, isBackwardNavActive, isForwardNavActive, theme;

static const CGFloat BOTTOM_BAR_HEIGHT = 30;

- (id)initWithTheme:(HNTheme *)theTheme {
    
    self = [super init];
    if (self) {
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        
        webView = [[UIWebView alloc] initWithFrame:screenBounds];
        webView.delegate = self;
        webView.scalesPageToFit = YES;
        [self.view addSubview:webView];
        
        self.theme = theTheme;
        
        bottomBarView = [[UIView alloc] initWithFrame:CGRectZero];
        bottomBarView.backgroundColor = theTheme.titleBarColor;
        [self.view addSubview:bottomBarView];
        
        navigateBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [navigateBackButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchDown];
        [bottomBarView addSubview:navigateBackButton];
        
        navigateForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [navigateForwardButton addTarget:self action:@selector(forwardButtonTouched) forControlEvents:UIControlEventTouchDown];
        [bottomBarView addSubview:navigateForwardButton];
        
        connectionStatusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        connectionStatusLabel.textAlignment = NSTextAlignmentCenter;
        //connectionStatusLabel.text = @"Test Status!!!";
        connectionStatusLabel.font =  [UIFont fontWithName:@"Helvetica" size:11];
        connectionStatusLabel.textColor = [UIColor whiteColor];
        [bottomBarView addSubview:connectionStatusLabel];
        
        //Counter for the number of components requesting the bottom bar to be displayed
        // like the history buttons or the status message
        bottomBarMask = 0;
        
        [self resetNavButtons];
        
        currentURL = @"http://news.ycombinator.com";
        
        isLoadingNewPage = FALSE;
        isForwardNavActive = FALSE;
        isBackwardNavActive = FALSE;
        
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
    CGFloat webViewHeight = self.view.frame.size.height;
    
    if (bottomBarView.hidden == FALSE)
    {
        webViewHeight -= BOTTOM_BAR_HEIGHT;
    }
    
    self.webView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, webViewHeight);
    self.bottomBarView.frame = CGRectMake(0, webViewHeight, self.view.frame.size.width , BOTTOM_BAR_HEIGHT);
    
    //Add navigation buttons to bottom bar
    CGFloat navigateButtonHeight = BOTTOM_BAR_HEIGHT - 15;
    CGFloat navigateButtonWidth = navigateButtonHeight;
    CGFloat backNavigateButtonX = 10;
    CGFloat forwardNavigateButtonX = backNavigateButtonX + navigateButtonWidth + 15;
    CGFloat navigateButtonY = (BOTTOM_BAR_HEIGHT / 2) - (navigateButtonHeight / 2);
    CGFloat statusLabelX = forwardNavigateButtonX + navigateButtonWidth + 5;
    CGFloat statusLabelWidth = self.view.frame.size.width - (statusLabelX * 2);
    CGFloat statusLabelHeight = BOTTOM_BAR_HEIGHT - 10;
    CGFloat statusLabelY = (BOTTOM_BAR_HEIGHT / 2) - (statusLabelHeight / 2);
    
    self.navigateBackButton.frame = CGRectMake(backNavigateButtonX, navigateButtonY, navigateButtonWidth, navigateButtonHeight);
    self.navigateForwardButton.frame = CGRectMake(forwardNavigateButtonX, navigateButtonY, navigateButtonWidth, navigateButtonHeight);
    self.connectionStatusLabel.frame = CGRectMake(statusLabelX, statusLabelY, statusLabelWidth, statusLabelHeight);
    
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"shouldstartload: %i", navigationType);
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        isLoadingNewPage = TRUE;

    }
    
    return TRUE;
}



- (void) setBottomBarStatus:(bottomBarStatus)mask turnOn:(BOOL)isOn
{

    if (isOn)
    {
        bottomBarMask |= mask;
    }
    else
    {
        bottomBarMask &= ~mask;
    }
    
    if (bottomBarMask)
    {
        self.bottomBarView.hidden = FALSE;
    }
    else
    {
        self.bottomBarView.hidden = TRUE;
    }
    
    //Reset the frame to show/hide bottom bar
    [self viewWillLayoutSubviews];
    
}

- (void) resetNavButtons
{
    historyPosition = 0;
    historyLength = 0;
    
    //Set images
    [self deactivateBackNavButton];
    [self deactivateForwardNavButton];
    
    //[self setBottomBarVisible:FALSE];
    [self setBottomBarStatus:BOTTOM_BAR_HISTORY_EXISTS turnOn:FALSE];
}

- (void) activateBackNavButton
{
    [navigateBackButton setImage:[UIImage imageNamed:@"triangle-reverse.png"] forState:UIControlStateNormal];
    [navigateBackButton setImage:[UIImage imageNamed:@"triangle-blue-reverse.png"] forState:UIControlStateHighlighted];
    
    isBackwardNavActive = TRUE;
}

- (void) activateForwardNavButton
{
    [navigateForwardButton setImage:[UIImage imageNamed:@"triangle"] forState:UIControlStateNormal];
    [navigateForwardButton setImage:[UIImage imageNamed:@"triangle-blue"] forState:UIControlStateHighlighted];
    
    isForwardNavActive = TRUE;
    
}

- (void) deactivateBackNavButton
{
    [navigateBackButton setImage:[UIImage imageNamed:@"triangle-grey-reverse.png"] forState:UIControlStateNormal];
    [navigateBackButton setImage:[UIImage imageNamed:@"triangle-grey-reverse.png"] forState:UIControlStateHighlighted];
    
    isBackwardNavActive = FALSE;
}

- (void) deactivateForwardNavButton
{
    [navigateForwardButton setImage:[UIImage imageNamed:@"triangle-grey.png"] forState:UIControlStateNormal];
    [navigateForwardButton setImage:[UIImage imageNamed:@"triangle-grey.png"] forState:UIControlStateHighlighted];
    
    isForwardNavActive = FALSE;
}

- (void) backButtonTouched
{
    if (isBackwardNavActive)
    {
        [self.webView goBack];
        [self moveHistoryBackward];
    }
}

- (void) forwardButtonTouched
{
    if(isForwardNavActive)
    {
        [self.webView goForward];
        [self moveHistoryForward];
    }
}

- (void) resetHistoryWithNewLink
{
    //[self setBottomBarVisible:TRUE];
    [self setBottomBarStatus:BOTTOM_BAR_HISTORY_EXISTS turnOn:TRUE];
    
    //Need to make sure the "forward" history is erased when new link is clicked
    self.historyLength = self.historyPosition;
    
    [self moveHistoryForward];
}

- (void) moveHistoryBackward
{
    if (historyPosition > 0)
    {
        [self activateForwardNavButton];
        historyPosition--;
        
        if (historyPosition == 0)
        {
            [self deactivateBackNavButton];
        }
        
    }
}

- (void) moveHistoryForward
{
    [self activateBackNavButton];
        
    historyPosition++;
        
    //Clicked a link, increasing history
    if (historyPosition > historyLength)
    {
         historyLength = historyPosition;
    }
        
    //Got to end of history
    if (historyPosition == historyLength)
    {
        [self deactivateForwardNavButton];
    }
}

- (void) setURL:(NSString *)newUrl forceUpdate:(BOOL)doForceUpdate
{
    if(doForceUpdate || historyLength > 0 || ![newUrl isEqualToString:self.currentURL])
    {
        [self resetNavButtons];
        
        [self loadUrl:@"about:blank"];
        [self loadUrl:newUrl];
        self.bottomBarMask = 0;
    }
}

- (void) loadUrl:(NSString *)newUrl
{
    NSURL *url = [NSURL URLWithString:newUrl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    currentURL = newUrl;
    [webView loadRequest:requestObj];
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    self.connectionStatusLabel.text = @"Loading...";
    [self setBottomBarStatus:BOTTOM_BAR_STATUS_SHOWING turnOn:TRUE];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (isLoadingNewPage)
    {
        NSLog(@"loading new page");
        [self resetHistoryWithNewLink];
        self.isLoadingNewPage = FALSE;
    }
    
    [self setBottomBarStatus:BOTTOM_BAR_STATUS_SHOWING turnOn:FALSE];
    self.connectionStatusLabel.text = @"";
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"loading paged FAILED");
    //self.isLoadingNewPage = FALSE;
}

@end
