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

NSString static *HNGoToArticleButtonText = @"Go To Article";
NSString static *HNGoToCommentsButtonText = @"Go To Comments";
NSString static *HNSplitVCShowFullScreenText = @"Full Screen";
NSString static *HNSplitVCShowArticleList = @"Show Article List";

@interface HNArticleContainerVC ()


@property (nonatomic, weak) UIViewController *currentVC;
@property (nonatomic, strong) HNArticle *currentArticle;
@property (nonatomic, strong) NSString *rightBarButtonTitle;

@end

@implementation HNArticleContainerVC

-(id) initWithArticleVC:(HNWebBrowserVC *)theArticleVC andCommentsVC:(HNCommentVC *)theCommentsVC
{
    self = [super init];
    if(self)
    {
        self.articleVC = theArticleVC;
        self.commentsVC = theCommentsVC;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    return self;
    
}

-(void) loadBarButtons
{
    //We want to hide the "show comments/article" button if its a self or job post
    if (self.currentArticle.isSelfPost || ![self.currentArticle.type isEqualToString:@"story"])
    {
        self.navigationItem.rightBarButtonItems = nil;
    }
    else if (!self.navigationItem.rightBarButtonItem)
    {
        UIBarButtonItem *swapButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@""
                                       style:UIBarButtonItemStylePlain
                                       target:self
                                       action:@selector(swapButtonPressed)];
        
        self.navigationItem.rightBarButtonItem = swapButton;
    }

    //Setup the "full screen/article list" button for iPad
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        
        if (!self.navigationItem.leftBarButtonItem)
        {
            UIBarButtonItem *splitButton = [[UIBarButtonItem alloc]
                                            initWithTitle:HNSplitVCShowFullScreenText
                                            style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(splitButtonPressed)];

            self.navigationItem.leftBarButtonItem = splitButton;
        }
    }
    

}

-(void) viewWillAppear:(BOOL)animated
{
    [self setRightButtonTitle:self.rightBarButtonTitle];
}

-(void) splitButtonPressed
{
    if (self.splitVC)
    {
        [self splitButtonPressed_ios8];
    }
}

-(void) splitButtonPressed_ios8
{

    if (((UISplitViewController *)self.splitVC).displayMode == UISplitViewControllerDisplayModePrimaryHidden)
    {
        self.navigationItem.leftBarButtonItem.title = HNSplitVCShowFullScreenText;
        ((UISplitViewController *)self.splitVC).preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    }
    else
    {
        self.navigationItem.leftBarButtonItem.title = HNSplitVCShowArticleList;
        ((UISplitViewController *)self.splitVC).preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
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
        if (self.currentVC == oldVc)
        {
            [self removeViewController:oldVc];
        }
        
        if (self.currentVC != newVc)
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

-(void) loadNewArticle:(HNArticle *)article
{
    self.currentArticle = article;
    [self loadBarButtons];
}

-(void) doPresentArticle:(HNArticle *)article onClearBlock:(void (^)())clearBlock
{
    [self loadNewArticle:article];
    
    [self loadArticle:article forceUpdate:YES onClearBlock:clearBlock];
    
    if (self.currentVC != self.articleVC)
    {
        [self swapViewControllerFrom:self.commentsVC to:self.articleVC withAnimation:NO];
    }
}

-(void) doPresentCommentForArticle:(HNArticle *)article
{
    [self loadNewArticle:article];
    
    [self loadComments:article forceUpdate:YES];
    
    if (self.currentVC != self.commentsVC)
    {
        [self swapViewControllerFrom:self.articleVC to:self.commentsVC withAnimation:NO];
    }
    
}

-(void) loadArticle:(HNArticle *)article forceUpdate:(BOOL)doForceUpdate onClearBlock:(void (^)())clearBlock
{
    [self.articleVC setURL:article.url forceUpdate:doForceUpdate onClearBlock:clearBlock];
    [self setRightButtonTitle:HNGoToCommentsButtonText];
}

-(void) loadComments:(HNArticle *)article forceUpdate:(BOOL)doForceUpdate
{
    [self.commentsVC setArticle:article forceUpdate:doForceUpdate];
    [self setRightButtonTitle:HNGoToArticleButtonText];
    
}

-(void) setRightButtonTitle:(NSString *)title
{
    self.rightBarButtonTitle = title;
    UIBarButtonItem *rightButton = self.navigationItem.rightBarButtonItem;    
    rightButton.title = title;
}


@end
