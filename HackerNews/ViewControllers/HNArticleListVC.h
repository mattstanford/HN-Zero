//
//  HNArticleListVC.h
//  HackerNews
//
//  Created by Matthew Stanford on 8/29/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNWebBrowserVC.h"
#import "HNDownloadController.h"
#import "HNArticleCell.h"
#import "HNCommentVC.h"

@interface HNArticleListVC : UITableViewController  <downloadControllerDelegate, HNArticleCellDelegate>
{
    NSArray *articles;
    HNWebBrowserVC *webBrowserVC;
    HNCommentVC *commentVC;
    HNDownloadController *downloadController;
}

- (id)initWithStyle:(UITableViewStyle)style withWebBrowserVC:(HNWebBrowserVC *)webVC andCommentVC:(HNCommentVC *)commVC;
- (void) downloadFrontPageArticles;
- (void) reloadButtonPressed;

@property (strong, nonatomic) NSArray *articles;
@property (strong, nonatomic) HNWebBrowserVC *webBrowserVC;
@property (strong, nonatomic) HNCommentVC *commentVC;
@property (strong, nonatomic) HNDownloadController *downloadController;

@end
