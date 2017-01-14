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
            NSLog(@"changing view!");
            [viewController changeTheme:theme];
        }
    }
}

-(void)addThemedViewController:(UIViewController<HNThemedViewController> *)viewController
{
    [self.themedVCs addObject:viewController];
}

@end
