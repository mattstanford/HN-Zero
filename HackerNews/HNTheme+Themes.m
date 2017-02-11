//
//  HNTheme+Themes.m
//  HN Zero
//
//  Created by Matt Stanford on 1/13/17.
//  Copyright © 2017 Matthew Stanford. All rights reserved.
//

#import "HNTheme+Themes.h"

@implementation HNTheme (Themes)

+(HNTheme *)classicTheme
{
    HNTheme *appTheme = [[HNTheme alloc] init];
    
    appTheme.name = @"HN Zero Classic";
    
    CGFloat defaultFontSize = 13.0;
    CGFloat defaultTitleSize = 15.0;
    
    appTheme.titleBarColor = [UIColor colorWithRed:1.0 green:.4 blue:0.0 alpha:1.0];
    appTheme.titleBarTextColor = [UIColor whiteColor];
    
    appTheme.cellBackgroundColor = [UIColor whiteColor];
    appTheme.titleTextColor = [UIColor blackColor];
    appTheme.infoColor = [UIColor lightGrayColor];
    appTheme.normalTextColor = [UIColor blackColor];
    appTheme.commentLinkColor = [UIColor blueColor];
    appTheme.opColor = [UIColor blueColor];
    
    appTheme.articleTitleFont = [UIFont fontWithName:@"Helvetica" size:defaultTitleSize];
    appTheme.articleInfoFont = [UIFont fontWithName:@"Helvetica" size:defaultFontSize];
    appTheme.articleNumCommentsFont = [UIFont fontWithName:@"Helvetica" size:defaultFontSize];
    
    appTheme.tableViewBackgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1.00];
    
    appTheme.commentFontSize = defaultFontSize;
    appTheme.commentNormalFont = [UIFont fontWithName:@"Helvetica" size:defaultFontSize];
    appTheme.commentBoldFont = [UIFont fontWithName:@"Helvetica-Bold" size:defaultFontSize];
    appTheme.commentItalicFont = [UIFont fontWithName:@"Helvetica-Oblique" size:defaultFontSize];
    appTheme.commentCodeFont = [UIFont fontWithName:@"Courier" size:defaultFontSize];
    
    appTheme.commentTitleFont = [UIFont fontWithName:@"Helvetica-Bold" size:defaultTitleSize];
    appTheme.commentInfoFont = [UIFont fontWithName:@"Helvetica" size:defaultFontSize];
    appTheme.commentPostFont = [UIFont fontWithName:@"Helvetica" size:defaultFontSize];
    
    return appTheme;
}

+(HNTheme *)darkTheme
{
    HNTheme *appTheme = [[HNTheme alloc] init];
    
    appTheme.name = @"Dark Mode";
    
    CGFloat defaultFontSize = 13.0;
    CGFloat defaultTitleSize = 15.0;
    
    appTheme.titleBarColor = [UIColor blackColor];
    appTheme.titleBarTextColor = [UIColor whiteColor];
    
    appTheme.cellBackgroundColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.18 alpha:1.00];
    appTheme.titleTextColor = [UIColor colorWithRed:0.92 green:0.96 blue:0.97 alpha:1.00];
    appTheme.infoColor = [UIColor grayColor];
    appTheme.normalTextColor =  [UIColor colorWithRed:0.92 green:0.96 blue:0.97 alpha:1.00];
    appTheme.commentLinkColor = [UIColor colorWithRed:0.13 green:0.78 blue:0.98 alpha:1.00];
    appTheme.opColor = [UIColor colorWithRed:0.13 green:0.78 blue:0.98 alpha:1.00];
    
    appTheme.tableViewBackgroundColor = [UIColor blackColor];
    
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
    
    return appTheme;
}

@end
