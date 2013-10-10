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
    UIBarButtonItem *swapButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                     target:self
                                     action:@selector(swapButtonPressed)];

    self.navigationItem.rightBarButtonItem = swapButton;
    
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
        
        [oldVc willMoveToParentViewController:nil];
        [self addChildViewController:newVc];
        
        [self transitionFromViewController:oldVc
                          toViewController:newVc
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    newVc.view.frame = oldVc.view.bounds;
                                    
                                }
                                completion:^(BOOL finished) {
                                    
                                    [oldVc removeFromParentViewController];
                                    [newVc didMoveToParentViewController:self];
                                    
                                    self.currentVC = newVc;
                                }];
    }
    else
    {
        if (currentVC == oldVc)
        {
            [self removeViewController:oldVc];
        }
        
        if (currentVC != newVc)
        {
            [self addViewController:newVc];
        }

    }
    
}

-(void) addViewController:(UIViewController *)vc
{
    [self addChildViewController:vc];
    vc.view.frame = self.view.bounds;
    [self.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    
    self.currentVC = vc;
    
}

-(void) removeViewController:(UIViewController *)vc
{
    [vc willMoveToParentViewController:nil];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
    
    self.currentVC = nil;
}

-(void) doPresentArticle:(HNArticle *)article
{
    self.currentArticle = article;
    
    [self loadArticle:article];
    
    if (self.currentVC != self.articleVC)
    {
        [self swapViewControllerFrom:self.commentsVC to:self.articleVC withAnimation:NO];
    }

    
}

-(void) doPresentCommentForArticle:(HNArticle *)article
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
