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

@synthesize articleVC, commentsVC, currentVC, currentArticle, rightButtonTitle, splitVC;

-(id) initWithArticleVC:(HNWebBrowserVC *)theArticleVC andCommentsVC:(HNCommentVC *)theCommentsVC
{
    self = [super init];
    if(self)
    {
        self.articleVC = theArticleVC;
        self.commentsVC = theCommentsVC;
        
        //Need to set this in iOS 7 to prevent container view from underlapping content with nav bar
        int sysVer = [[[UIDevice currentDevice] systemVersion] integerValue];
        if (sysVer >= 7)
        {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
        
    }
    return self;
    
}


-(void) viewDidLoad
{

    UIBarButtonItem *swapButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@""
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(swapButtonPressed)];

    self.navigationItem.rightBarButtonItem = swapButton;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIBarButtonItem *splitButton = [[UIBarButtonItem alloc]
                                        initWithTitle:@"Full Screen"
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(splitButtonPressed)];
        
        self.navigationItem.leftBarButtonItem = splitButton;
    }
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [self setRightButtonTitle];
}

-(void) splitButtonPressed
{
    if (self.splitVC)
    {
        [self.splitVC toggleMasterView:nil];
    }
}

-(void)swapButtonPressed
{
    UIViewController *newVC = nil;
    
    if (self.currentVC == self.articleVC)
    {
        newVC = self.commentsVC;
        [self loadComments:self.currentArticle forceUpdate:NO];
    }
    else if(self.currentVC == self.commentsVC)
    {
        newVC = self.articleVC;
        [self loadArticle:self.currentArticle forceUpdate:NO onClearBlock:nil];
    }
    
    [self setRightButtonTitle];
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
                                    CGRect newRect = CGRectMake(0, 0, oldVc.view.bounds.size.width, oldVc.view.bounds.size.height);
                                    newVc.view.frame = newRect;
                                    
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

-(void) doPresentArticle:(HNArticle *)article onClearBlock:(void (^)())clearBlock
{
    self.currentArticle = article;
    
    [self loadArticle:article forceUpdate:YES onClearBlock:clearBlock];
    
    if (self.currentVC != self.articleVC)
    {
        [self swapViewControllerFrom:self.commentsVC to:self.articleVC withAnimation:NO];
    }

    
}

-(void) doPresentCommentForArticle:(HNArticle *)article
{
    self.currentArticle = article;
    
    [self loadComments:article forceUpdate:YES];
    
    if (self.currentVC != self.commentsVC)
    {
        [self swapViewControllerFrom:self.articleVC to:self.commentsVC withAnimation:NO];
    }
    
}

-(void) loadArticle:(HNArticle *)article forceUpdate:(BOOL)doForceUpdate onClearBlock:(void (^)())clearBlock
{
    [self.articleVC setURL:article.url forceUpdate:doForceUpdate onClearBlock:clearBlock];
    
    self.rightButtonTitle = @"Go to comments";
}

-(void) loadComments:(HNArticle *)article forceUpdate:(BOOL)doForceUpdate
{
    [self.commentsVC setArticle:article forceUpdate:doForceUpdate];
    
   self.rightButtonTitle = @"Go to article";
    
}

-(void) setRightButtonTitle
{
    UIBarButtonItem *rightButton = self.navigationItem.rightBarButtonItem;    
    rightButton.title = self.rightButtonTitle;
}


@end
