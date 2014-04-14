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
@class MGSplitViewController;

@interface HNArticleContainerVC : UIViewController
{
    HNWebBrowserVC *articleVC;
    HNCommentVC *commentsVC;
    HNArticle *currentArticle;
}

@property (nonatomic, strong) HNWebBrowserVC *articleVC;
@property (nonatomic, strong) HNCommentVC *commentsVC;
@property (nonatomic, weak) UIViewController *currentVC;
@property (nonatomic, strong) HNArticle *currentArticle;
@property (nonatomic, weak) MGSplitViewController *splitVC;

-(id) initWithArticleVC:(HNWebBrowserVC *)theArticleVC andCommentsVC:(HNCommentVC *)theCommentsVC;
-(void) doPresentArticle:(HNArticle *)article onClearBlock:(void (^)())clearBlock;
-(void) doPresentCommentForArticle:(HNArticle *)article;

@end
