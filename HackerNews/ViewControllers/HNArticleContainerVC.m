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
        
        [self addChildViewController:self.articleVC];
        [self addChildViewController:self.commentsVC];
    
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
        
        [self transitionFromViewController:oldVc
                          toViewController:newVc
                                  duration:0.5
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:nil
                                completion:^(BOOL finished) {
                                    self.currentVC = newVc;
                                }];
    }
    else
    {
        [oldVc.view removeFromSuperview];
        newVc.view.frame = self.view.frame;
        [self.view addSubview:newVc.view];
        
        self.currentVC = newVc;
    }
    
}

-(void) showViewController:(UIViewController *)vc
{
    vc.view.frame = self.view.frame;
    [self.view addSubview:vc.view];
    
    [vc didMoveToParentViewController:self];
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
