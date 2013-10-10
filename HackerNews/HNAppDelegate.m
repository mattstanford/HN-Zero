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

@implementation HNAppDelegate

@synthesize window, navController, articleListVC, webBrowserVC, commentWebBrowserVC, commentVC, theme, articleContainerVC;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.theme = [[HNTheme alloc] init];
    [self setDefaultTheme:self.theme];
    
    self.webBrowserVC = [[HNWebBrowserVC alloc] init];
    self.commentWebBrowserVC = [[HNWebBrowserVC alloc] init];
    
    self.commentVC = [[HNCommentVC alloc] initWithStyle:UITableViewStylePlain withTheme:self.theme webBrowser:self.commentWebBrowserVC];
    
    self.articleContainerVC = [[HNArticleContainerVC alloc] initWithArticleVC:self.webBrowserVC andCommentsVC:self.commentVC];
    
    self.articleListVC = [[HNArticleListVC alloc] initWithStyle:UITableViewStylePlain withWebBrowserVC:self.webBrowserVC andCommentVC:self.commentVC articleContainer:articleContainerVC withTheme:self.theme];
    
    self.navController = [[UINavigationController alloc] initWithRootViewController:self.articleListVC];
    self.navController.navigationBar.tintColor = [UIColor orangeColor];
    [self.window setRootViewController:self.navController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) setDefaultTheme:(HNTheme *)appTheme
{
    CGFloat defaultFontSize = 12.0;
    CGFloat defaultTitleSize = 14.0;
    
    appTheme.articleTitleFont = [UIFont fontWithName:@"Helvetica" size:defaultTitleSize];
    appTheme.articleInfoFont = [UIFont fontWithName:@"Helvetica" size:defaultFontSize];
    appTheme.articleNumCommentsFont = [UIFont fontWithName:@"Helvetica" size:defaultFontSize];
    
    appTheme.commentFontSize = defaultFontSize;
    appTheme.commentNormalFont = [UIFont fontWithName:@"Helvetica" size:defaultFontSize];
    appTheme.commentBoldFont = [UIFont fontWithName:@"Helvetica-Bold" size:defaultFontSize];
    appTheme.commentItalicFont = [UIFont fontWithName:@"Helvetica-Oblique" size:defaultFontSize];
    appTheme.commentCodeFont = [UIFont fontWithName:@"Courier" size:defaultFontSize];
    
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
