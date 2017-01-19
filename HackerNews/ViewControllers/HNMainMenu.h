//
//  HNMainMenu.h
//  HackerNews
//
//  Created by Matthew Stanford on 10/15/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNThemedViewController.h"

@class HNArticleListVC;
@class HNMenuLink;
@class HNTheme;
@class HNSettings;
@class HNThemeChanger;

@interface HNMainMenu : UITableViewController <HNThemedViewController>

@property (nonatomic, strong) HNArticleListVC *articleListVC;
@property (nonatomic, strong) HNThemeChanger *themeChanger;


-(id) initWithStyle:(UITableViewStyle)style
          withTheme:(HNTheme *)theme
      withArticleVC:(HNArticleListVC *)theArticleListVC
      withMenuLinks:(NSArray *)menuLinks
        andSettings:(HNSettings *)settings;
- (void) changeMenuLink:(HNMenuLink *)link;

@end
