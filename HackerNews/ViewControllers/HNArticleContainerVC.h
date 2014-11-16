//
//  HNArticleContainerVC.h
//  HackerNews
//
//  Created by Matthew Stanford on 10/5/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNArticleListVC.h"

@class HNArticle;
@class HNWebBrowserVC;
@class HNCommentVC;

@interface HNArticleContainerVC : UIViewController

@property (nonatomic, strong) HNWebBrowserVC *articleVC;
@property (nonatomic, strong) HNCommentVC *commentsVC;
@property (nonatomic, weak) UIViewController *splitVC;

-(id) initWithArticleVC:(HNWebBrowserVC *)theArticleVC andCommentsVC:(HNCommentVC *)theCommentsVC;
-(void) doPresentArticle:(HNArticle *)article onClearBlock:(void (^)())clearBlock;
-(void) doPresentCommentForArticle:(HNArticle *)article;

@end
