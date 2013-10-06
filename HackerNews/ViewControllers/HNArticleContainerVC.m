//
//  HNArticleContainerVC.m
//  HackerNews
//
//  Created by Matthew Stanford on 10/5/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNArticleContainerVC.h"
#import "HNArticle.h"
#import "HNWebBrowserVC.h"
#import "HNCommentVC.h"

@implementation HNArticleContainerVC

@synthesize articleVC, commentsVC, currentVC, currentArticle;

-(id) initWithArticleVC:(HNWebBrowserVC *)theArticleVC andCommentsVC:(HNCommentVC *)theCommentsVC
{
    self = [super init];
    if(self)
    {
        self.articleVC = theArticleVC;
        self.commentsVC = theCommentsVC;
        
    
    }
    return self;
    
}


-(void) viewDidLoad
{
    
    [self addChildViewController:self.articleVC];
    [self addChildViewController:self.commentsVC];
    
    [self.articleVC didMoveToParentViewController:self];
    [self.commentsVC didMoveToParentViewController:self];
    
    UIBarButtonItem *swapButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                     target:self
                                     action:@selector(swapButtonPressed)];

    self.navigationItem.rightBarButtonItem = swapButton;

    
    [self showViewController:self.articleVC];
    self.currentVC = self.articleVC;
    
}

-(void)swapButtonPressed
{
    UIViewController *newVC = nil;
    
    if (self.currentVC == self.articleVC)
    {
        newVC = self.commentsVC;
        [self loadComments:self.currentArticle];
    }
    else
    {
        newVC = self.articleVC;
        [self loadArticle:self.currentArticle];
    }
    
    [self swapViewControllerFrom:self.currentVC to:newVC withAnimation:YES];
}

- (void) swapViewControllerFrom:(UIViewController *)oldVc to:(UIViewController *)newVc withAnimation:(BOOL)animated
{

    if (animated) {
        
        newVc.view.frame = oldVc.view.bounds;
        
        [self transitionFromViewController:oldVc
                          toViewController:newVc
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    
                                }
                                completion:^(BOOL finished) {
                                    self.currentVC = newVc;
                                }];
    }
    else
    {
        [oldVc.view removeFromSuperview];
        [self showViewController:newVc];
        
        self.currentVC = newVc;
    }
    
}

-(void) showViewController:(UIViewController *)vc
{
    vc.view.frame = self.view.bounds;
    [self.view addSubview:vc.view];
    
}

-(void) didTapArticle:(HNArticle *)article
{
    self.currentArticle = article;
    
    [self loadArticle:article];
    
    if (self.currentVC != self.articleVC)
    {
        [self swapViewControllerFrom:self.commentsVC to:self.articleVC withAnimation:NO];
    }

    
}

-(void) didTapCommentForArticle:(HNArticle *)article
{
    self.currentArticle = article;
    
    [self loadComments:article];
    
    if (self.currentVC != self.commentsVC)
    {
        [self swapViewControllerFrom:self.articleVC to:self.commentsVC withAnimation:NO];
    }
    
}

-(void) loadArticle:(HNArticle *)article
{
    [self.articleVC setURL:article.url];
}

-(void) loadComments:(HNArticle *)article
{
    NSString *commentId = article.commentLinkId;
    self.commentsVC.currentCommentId = commentId;
    self.commentsVC.title = article.title;
    
}


@end
