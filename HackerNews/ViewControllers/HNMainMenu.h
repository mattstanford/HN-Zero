//
//  HNMainMenu.h
//  HackerNews
//
//  Created by Matthew Stanford on 10/15/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNArticleListVC;

@interface HNMainMenu : UITableViewController
{
    HNArticleListVC *articleListVC;
    NSArray *mainItems;
}

@property (nonatomic, strong) HNArticleListVC *articleListVC;
@property (nonatomic, strong) NSArray *mainItems;

-(id) initWithStyle:(UITableViewStyle)style withArticleVC:(HNArticleListVC *)theArticleListVC;

@end
