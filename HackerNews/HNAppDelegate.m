//
//  HNAppDelegate.m
//  HackerNews
//
//  Created by Matthew Stanford on 8/24/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNAppDelegate.h"
#import "HNTheme.h"
#import "HNArticleContainerVC.h"
#import "HNMainMenu.h"
#import "HNMenuLink.h"
#import "GAI.h"
#import <MMDrawerController/MMDrawerController.h>

@implementation HNAppDelegate

@synthesize window, navController, articleListVC, webBrowserVC, commentWebBrowserVC, commentVC, theme, articleContainerVC, mainMenuVC, splitVC;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Google Analytics
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-49248907-1"];
    
    //Enable URL on-disk caching
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:2 * 1024 * 1024
                                                            diskCapacity:100 * 1024 * 1024
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    [self initializeUI];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) initializeUI
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.theme = [[HNTheme alloc] init];
    [self setDefaultTheme:self.theme];
    
    self.webBrowserVC = [[HNWebBrowserVC alloc] initWithTheme:self.theme];
    self.commentWebBrowserVC = [[HNWebBrowserVC alloc] initWithTheme:self.theme];
    
    self.commentVC = [[HNCommentVC alloc] initWithStyle:UITableViewStylePlain withTheme:self.theme webBrowser:self.commentWebBrowserVC];
    
    self.articleContainerVC = [[HNArticleContainerVC alloc] initWithArticleVC:self.webBrowserVC andCommentsVC:self.commentVC];
    
         //self.articleListVC = [[HNArticleListVC alloc] initWithStyle:UITableViewStylePlain withWebBrowserVC:self.webBrowserVC andCommentVC:self.commentVC articleContainer:articleContainerVC withTheme:self.theme];
    
    //[self setupMainMenu];
    NSArray *menuLinks = [self initializeMenuLinks];
    
    if (NSClassFromString(@"UISplitViewController") != nil && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        
        //First initialze the drawer controller with its root view controllers
        splitVC = [[MGSplitViewController alloc] init];
        splitVC.showsMasterInPortrait = YES;
        splitVC.view.backgroundColor = [UIColor lightGrayColor];
        self.articleContainerVC.splitVC = splitVC;
        
        
        self.mainMenuVC = [[HNMainMenu alloc] initWithStyle:UITableViewStyleGrouped withArticleVC:nil withMenuLinks:menuLinks];
        MMDrawerController *drawerController = [self setupDrawerControllerWithCenterVC:splitVC leftVC:self.mainMenuVC];
        
        self.articleListVC = [[HNArticleListVC alloc] initWithStyle:UITableViewStylePlain withWebBrowserVC:self.webBrowserVC andCommentVC:self.commentVC articleContainer:articleContainerVC withTheme:self.theme withDrawerController:drawerController];
        
        //Finish setting up the main menu VC
        self.mainMenuVC.articleListVC = self.articleListVC;
        [self.mainMenuVC goToMenuLink:[menuLinks objectAtIndex:0]];
        
        
        //[self setupMainMenuWithLinks:menuLinks withArticleListVC:self.articleListVC];
        
        //Initialze the splitVC and finish initiazing the rest of the UI
        UINavigationController *articleListNavController = [[UINavigationController alloc] initWithRootViewController:articleListVC];
        
        [self setTitleBarColors:self.theme withNavController:articleListNavController];
        
        UINavigationController *articleContainerNavController = [[UINavigationController alloc] initWithRootViewController:articleContainerVC];
        
        [self setTitleBarColors:self.theme withNavController:articleContainerNavController];
        
        splitVC.viewControllers = [NSArray arrayWithObjects:articleListNavController, articleContainerNavController, nil];
        splitVC.delegate = articleListVC;
        
        
        [self.window setRootViewController:drawerController];
        //[self.window setRootViewController:articleListNavController];
    }
    else
    {
        self.articleListVC = [[HNArticleListVC alloc] initWithStyle:UITableViewStylePlain withWebBrowserVC:self.webBrowserVC andCommentVC:self.commentVC articleContainer:articleContainerVC withTheme:self.theme];
        
        
        self.mainMenuVC = [[HNMainMenu alloc] initWithStyle:UITableViewStyleGrouped withArticleVC:self.articleListVC withMenuLinks:menuLinks];
        [self setupMainMenuWithLinks:menuLinks withArticleListVC:self.articleListVC];
        
        self.navController = [[UINavigationController alloc] initWithRootViewController:self.mainMenuVC];
        
        [self.mainMenuVC goToMenuLink:[menuLinks objectAtIndex:0]];
        
        [self setTitleBarColors:self.theme withNavController:self.navController];
        [self.window setRootViewController:self.navController];
        
    }

    
    self.window.backgroundColor = [UIColor whiteColor];
}

-(void) setupMainMenuWithLinks:(NSArray *)menuLinks withArticleListVC:(HNArticleListVC *)articleList
{
    self.mainMenuVC = [[HNMainMenu alloc] initWithStyle:UITableViewStyleGrouped withArticleVC:articleList withMenuLinks:menuLinks];
    [self.mainMenuVC goToMenuLink:[menuLinks objectAtIndex:0]];
}

-(MMDrawerController *) setupDrawerControllerWithCenterVC:(UIViewController *)centerVC leftVC:(UIViewController *)leftVC
{
    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:centerVC leftDrawerViewController:leftVC];
    [drawerController setRestorationIdentifier:@"MMDrawer"];
    [drawerController setMaximumRightDrawerWidth:100.0];
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    return drawerController;
    
}

- (NSArray *) initializeMenuLinks
{
    NSArray *menuLinks = nil;
    
    HNMenuLink *frontPage = [[HNMenuLink alloc] init];
    frontPage.title = @"Front Page";
    frontPage.url = [NSURL URLWithString:@"https://news.ycombinator.com"];
    
    HNMenuLink *askHN = [[HNMenuLink alloc] init];
    askHN.title = @"Ask HN";
    askHN.url = [NSURL URLWithString:@"https://news.ycombinator.com/ask"];
    
    HNMenuLink *newHN = [[HNMenuLink alloc] init];
    newHN.title = @"New";
    newHN.url = [NSURL URLWithString:@"https://news.ycombinator.com/newest"];
    
    menuLinks = [[NSArray alloc] initWithObjects:frontPage, askHN, newHN, nil];

    
    return menuLinks;
}

- (void) setDefaultTheme:(HNTheme *)appTheme
{
    CGFloat defaultFontSize = 13.0;
    CGFloat defaultTitleSize = 15.0;
    
    appTheme.titleBarColor = [UIColor colorWithRed:1.0 green:.4 blue:0.0 alpha:1.0];
    appTheme.titleBarTextColor = [UIColor whiteColor];
    
    appTheme.articleTitleFont = [UIFont fontWithName:@"Helvetica" size:defaultTitleSize];
    appTheme.articleInfoFont = [UIFont fontWithName:@"Helvetica" size:defaultFontSize];
    appTheme.articleNumCommentsFont = [UIFont fontWithName:@"Helvetica" size:defaultFontSize];
    
    appTheme.commentFontSize = defaultFontSize;
    appTheme.commentNormalFont = [UIFont fontWithName:@"Helvetica" size:defaultFontSize];
    appTheme.commentBoldFont = [UIFont fontWithName:@"Helvetica-Bold" size:defaultFontSize];
    appTheme.commentItalicFont = [UIFont fontWithName:@"Helvetica-Oblique" size:defaultFontSize];
    appTheme.commentCodeFont = [UIFont fontWithName:@"Courier" size:defaultFontSize];
    
    appTheme.commentTitleFont = [UIFont fontWithName:@"Helvetica-Bold" size:defaultTitleSize];
    appTheme.commentInfoFont = [UIFont fontWithName:@"Helvetica" size:defaultFontSize];
    appTheme.commentPostFont = [UIFont fontWithName:@"Helvetica" size:defaultFontSize];
    
}

- (void) setTitleBarColors:(HNTheme *)theTheme withNavController:(UINavigationController *)theNavController
{
    if ([theNavController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
    {
        NSDictionary *navTextAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor whiteColor], UITextAttributeTextColor,
                                     nil];
        
        theNavController.navigationBar.titleTextAttributes = navTextAttrs;
        theNavController.navigationBar.barTintColor = theTheme.titleBarColor;
        theNavController.navigationBar.tintColor = theTheme.titleBarTextColor;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
    }
    else
    {
        theNavController.navigationBar.tintColor = theTheme.titleBarColor;
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
