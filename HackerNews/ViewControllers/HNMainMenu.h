//
//  HNMainMenu.h
//  HackerNews
//
//  Created by Matthew Stanford on 10/15/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNArticleListVC;
@class HNAbout;
@class HNMenuLink;
@class HNTheme;

@interface HNMainMenu : UITableViewController

@property (nonatomic, strong) HNArticleListVC *articleListVC;

-(id) initWithStyle:(UITableViewStyle)style withTheme:(HNTheme *)theme withArticleVC:(HNArticleListVC *)theArticleListVC withMenuLinks:(NSArray *)menuLinks;
- (void) goToMenuLink:(HNMenuLink *)link;

@end
