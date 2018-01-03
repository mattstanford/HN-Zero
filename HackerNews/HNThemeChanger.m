//
//  HNThemeChanger.m
//  HN Zero
//
//  Created by Matt Stanford on 1/13/17.
//  Copyright © 2017 Matthew Stanford. All rights reserved.
//

#import "HNThemeChanger.h"
#import "HNTheme.h"
#import "HNThemedViewController.h"

NSString * const kThemeSelectionKey = @"ThemeSelection";

@interface HNThemeChanger ()

@property (nonatomic, strong) NSMutableArray *themedVCs;

@end

@implementation HNThemeChanger

-(id) init
{
    self = [super init];
    if (self)
    {
        self.themedVCs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)switchViewsToTheme:(HNTheme *)theme
{
    if (self.themedVCs != nil)
    {
        for(UIViewController<HNThemedViewController> *viewController in self.themedVCs)
        {
            [viewController changeTheme:theme];
        }
    }
    
    [self saveSelection:theme];
    self.selectedTheme = theme;
}

-(void)addThemedViewController:(UIViewController<HNThemedViewController> *)viewController
{
    [self.themedVCs addObject:viewController];
}

-(void)saveSelection:(HNTheme *)theme
{
    NSString *valueToSave = theme.name;
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:kThemeSelectionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)loadSavedTheme
{
    HNTheme *savedTheme;
    NSString *savedThemeName = [[NSUserDefaults standardUserDefaults] stringForKey:kThemeSelectionKey];
    
    if (self.themes != nil && self.themes.count > 0)
    {
        if (savedThemeName != nil && savedThemeName.length > 0)
        {
            for (HNTheme *theme in self.themes)
            {
                if ([theme.name isEqualToString:savedThemeName])
                {
                    savedTheme = theme;
                    break;
                }
            }
        }
        
        if (savedTheme == nil)
        {
            savedTheme = [self.themes objectAtIndex:0];
        }
        
        [self switchViewsToTheme:savedTheme];
    }
}


@end
