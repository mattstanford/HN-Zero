//
//  HNWebBrowserVC.m
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNWebBrowserVC.h"
#import "HNTheme.h"
#import "HNConnectionStatusLabel.h"

@interface HNWebBrowserVC ()

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) NSString *currentURL;
@property (strong, nonatomic) UIView *bottomBarView;
@property (strong, nonatomic) UIButton *navigateBackButton;
@property (strong, nonatomic) UIButton *navigateForwardButton;
@property (strong, nonatomic) HNConnectionStatusLabel *connectionStatusLabel;
@property (assign, nonatomic) bottomBarStatus bottomBarMask;
@property (assign, nonatomic) int historyPosition;
@property (assign, nonatomic) int historyLength;
@property (assign, nonatomic) BOOL isLoadingNewPage;
@property (assign, nonatomic) BOOL isForwardNavActive;
@property (assign, nonatomic) BOOL isBackwardNavActive;
@property (assign, nonatomic) BOOL isBottomBarShowing;
@property (copy, nonatomic) void (^onClearBlock)(void);
@property (assign, nonatomic) BOOL isPendingUrlRequest;
@property (strong, nonatomic) HNTheme *theme;

@end

@implementation HNWebBrowserVC

static const CGFloat BOTTOM_BAR_HEIGHT = 30;
static const CGFloat STATUS_BAR_DELAY = 0.5;

#define BLANK_PAGE @"about:blank"

#pragma mark View lifecycle

- (id)initWithTheme:(HNTheme *)theTheme {
    
    self = [super init];
    if (self) {
        
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        
        self.webView = [[UIWebView alloc] initWithFrame:screenBounds];
        self.webView.delegate = self;
        self.webView.scalesPageToFit = YES;
        [self.view addSubview:self.webView];
        
        self.theme = theTheme;
        
        self.bottomBarView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        self.bottomBarView.backgroundColor = theTheme.titleBarColor;
        [self.view addSubview:self.bottomBarView];
        
        self.navigateBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.navigateBackButton addTarget:self action:@selector(backButtonTouched) forControlEvents:UIControlEventTouchDown];
        [self.bottomBarView addSubview:self.navigateBackButton];
        
        self.navigateForwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.navigateForwardButton addTarget:self action:@selector(forwardButtonTouched) forControlEvents:UIControlEventTouchDown];
        [self.bottomBarView addSubview:self.navigateForwardButton];
        
        self.connectionStatusLabel = [[HNConnectionStatusLabel alloc] initWithFrame:CGRectZero];
        self.connectionStatusLabel.textAlignment = NSTextAlignmentCenter;
        self.connectionStatusLabel.backgroundColor = [UIColor clearColor];
        self.connectionStatusLabel.font =  [UIFont fontWithName:@"Helvetica" size:11];
        self.connectionStatusLabel.textColor = [UIColor whiteColor];
        [self.bottomBarView addSubview:self.connectionStatusLabel];
        
        //Counter for the number of components requesting the bottom bar to be displayed
        // like the history buttons or the status message
        self.bottomBarMask = 0;
        self.isBottomBarShowing = FALSE;
        
        [self resetNavButtons];
        
        self.currentURL = @"http://news.ycombinator.com";
        self.isPendingUrlRequest = FALSE;
        
        self.isLoadingNewPage = FALSE;
        self.isForwardNavActive = FALSE;
        self.isBackwardNavActive = FALSE;
        
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
    CGFloat webViewBoundsHeight = self.view.frame.size.height;
    
    if (self.isBottomBarShowing)
    {
        webViewBoundsHeight -= BOTTOM_BAR_HEIGHT;
    }
    
    self.webView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    self.bottomBarView.frame = CGRectMake(0, webViewBoundsHeight, self.view.frame.size.width , BOTTOM_BAR_HEIGHT);
    
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

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadPendingUrl];
}

#pragma mark Bottom bar status functions

- (void) setBottomBarStatus:(bottomBarStatus)mask value:(BOOL)isOn
{

    if (isOn)
    {
        self.bottomBarMask |= mask;
    }
    else
    {
        self.bottomBarMask &= ~mask;
    }
    
    if (self.bottomBarMask && !self.isBottomBarShowing)
    {
        [self animateBottomBar:TRUE];
    }
    else if(!self.bottomBarMask && self.isBottomBarShowing)
    {
        [self animateBottomBar:FALSE];
    }
    
}

- (void) animateBottomBar:(BOOL)shouldGoUp
{
    CGFloat barPos = 0;
    
    if (shouldGoUp) {
        barPos = self.view.frame.size.height - BOTTOM_BAR_HEIGHT;
    }
    else
    {
        barPos = self.view.frame.size.height;
    }
    
    if (shouldGoUp) {
        self.isBottomBarShowing = TRUE;
    }
    else {
        self.isBottomBarShowing = FALSE;
    }

    /*
     Set the bounds, not the frame, since UIWebView has issues re-drawing the view when we
     re-draw the frame
     */
    self.webView.bounds = CGRectMake(self.webView.frame.origin.x, self.webView.frame.origin.y, self.webView.frame.size.width, barPos);
    
    [UIView animateWithDuration:STATUS_BAR_DELAY animations:^{

        self.bottomBarView.frame = CGRectMake(self.bottomBarView.frame.origin.x, barPos, self.bottomBarView.frame.size.width, self.bottomBarView.frame.size.height);
        
    }];
    
}

#pragma mark Navigation functions

- (void) resetNavButtons
{
    self.historyPosition = 0;
    self.historyLength = 0;
    
    //Set images
    [self deactivateBackNavButton];
    [self deactivateForwardNavButton];
    
    [self setBottomBarStatus:BOTTOM_BAR_HISTORY_EXISTS value:FALSE];
}

- (void) activateBackNavButton
{
    [self.navigateBackButton setImage:[UIImage imageNamed:@"triangle-reverse.png"] forState:UIControlStateNormal];
    [self.navigateBackButton setImage:[UIImage imageNamed:@"triangle-blue-reverse.png"] forState:UIControlStateHighlighted];
    
    self.isBackwardNavActive = TRUE;
}

- (void) activateForwardNavButton
{
    [self.navigateForwardButton setImage:[UIImage imageNamed:@"triangle"] forState:UIControlStateNormal];
    [self.navigateForwardButton setImage:[UIImage imageNamed:@"triangle-blue"] forState:UIControlStateHighlighted];
    
    self.isForwardNavActive = TRUE;
    
}

- (void) deactivateBackNavButton
{
    [self.navigateBackButton setImage:[UIImage imageNamed:@"triangle-grey-reverse.png"] forState:UIControlStateNormal];
    [self.navigateBackButton setImage:[UIImage imageNamed:@"triangle-grey-reverse.png"] forState:UIControlStateHighlighted];
    
    self.isBackwardNavActive = FALSE;
}

- (void) deactivateForwardNavButton
{
    [self.navigateForwardButton setImage:[UIImage imageNamed:@"triangle-grey.png"] forState:UIControlStateNormal];
    [self.navigateForwardButton setImage:[UIImage imageNamed:@"triangle-grey.png"] forState:UIControlStateHighlighted];
    
    self.isForwardNavActive = FALSE;
}

- (void) backButtonTouched
{
    if (self.isBackwardNavActive)
    {
        [self.webView goBack];
        [self moveHistoryBackward];
    }
}

- (void) forwardButtonTouched
{
    if(self.isForwardNavActive)
    {
        [self.webView goForward];
        [self moveHistoryForward];
    }
}

- (void) resetHistoryWithNewLink
{
    //[self setBottomBarVisible:TRUE];
    [self setBottomBarStatus:BOTTOM_BAR_HISTORY_EXISTS value:TRUE];
    
    //Need to make sure the "forward" history is erased when new link is clicked
    self.historyLength = self.historyPosition;
    
    [self moveHistoryForward];
}

- (void) moveHistoryBackward
{
    if (self.historyPosition > 0)
    {
        [self activateForwardNavButton];
        self.historyPosition--;
        
        if (self.historyPosition == 0)
        {
            [self deactivateBackNavButton];
        }
        
    }
}

- (void) moveHistoryForward
{
    [self activateBackNavButton];
        
    self.historyPosition++;
        
    //Clicked a link, increasing history
    if (self.historyPosition > self.historyLength)
    {
         self.historyLength = self.historyPosition;
    }
        
    //Got to end of history
    if (self.historyPosition == self.historyLength)
    {
        [self deactivateForwardNavButton];
    }
}

#pragma mark URL Loading functions

- (void) setURL:(NSString *)newUrl forceUpdate:(BOOL)doForceUpdate onClearBlock:(void (^)())clearBlock
{
    if(doForceUpdate || self.historyLength > 0 || ![newUrl isEqualToString:self.currentURL])
    {
        [self resetNavButtons];
        
        self.onClearBlock = clearBlock;
        self.currentURL = newUrl;
        [self loadUrl:BLANK_PAGE];
        
        self.bottomBarMask = 0;
    }
}

- (void) loadPendingUrl
{
    if (self.isPendingUrlRequest) {
        [self loadUrl:self.currentURL];
        self.isPendingUrlRequest = FALSE;
    }
}

- (void) loadUrl:(NSString *)newUrl
{
    NSURL *url = [NSURL URLWithString:newUrl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:requestObj];
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        self.isLoadingNewPage = TRUE;
        
    }
    
    return TRUE;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.connectionStatusLabel setStatusText:@"Loading..."];
    [self setBottomBarStatus:BOTTOM_BAR_STATUS_SHOWING value:TRUE];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    if ([self.webView.request.URL.absoluteString isEqualToString:BLANK_PAGE]) {
        //[self loadUrl:currentURL];
        self.isPendingUrlRequest = TRUE;
        
        if (self.onClearBlock) self.onClearBlock();
    }
    else
    {
    
        if (self.isLoadingNewPage)
        {
            NSLog(@"loading new page");
            [self resetHistoryWithNewLink];
            self.isLoadingNewPage = FALSE;
        }
        
        [self setBottomBarStatus:BOTTOM_BAR_STATUS_SHOWING value:FALSE];
        
        [self.connectionStatusLabel setFinalStatusText:@"Finished!" duration:STATUS_BAR_DELAY];
    }
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"loading paged FAILED");
}

#pragma mark HNThemedViewController

-(void)changeTheme:(HNTheme *)theme
{
    self.theme = theme;
    self.bottomBarView.backgroundColor = theme.titleBarColor;
}

@end
