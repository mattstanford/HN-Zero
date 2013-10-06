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
{
    HNWebBrowserVC *articleVC;
    HNCommentVC *commentsVC;
    HNArticle *currentArticle;
}

@property (nonatomic, strong) HNWebBrowserVC *articleVC;
@property (nonatomic, strong) HNCommentVC *commentsVC;
@property (nonatomic, weak) UIViewController *currentVC;
@property (nonatomic, strong) HNArticle *currentArticle;

-(id) initWithArticleVC:(HNWebBrowserVC *)theArticleVC andCommentsVC:(HNCommentVC *)theCommentsVC;
-(void) doPresentArticle:(HNArticle *)article;
-(void) doPresentCommentForArticle:(HNArticle *)article;

@end
