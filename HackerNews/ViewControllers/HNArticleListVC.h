//
//  HNArticleListVC.h
//  HackerNews
//
//  Created by Matthew Stanford on 8/29/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#include "HNWebBrowserVC.h"

@interface HNArticleListVC : UITableViewController 
{
    NSString *frontPageURL;
    NSArray *articles;
    HNWebBrowserVC *webBrowserVC;
}

- (id)initWithStyle:(UITableViewStyle)style withWebBrowserVC:(HNWebBrowserVC *)webVC;
- (void) downloadFrontPageArticles;
- (void) reloadButtonPressed;

@property (strong, nonatomic) NSString *frontPageURL;
@property (strong, nonatomic) NSArray *articles;
@property (strong, nonatomic) HNWebBrowserVC *webBrowserVC;

@end
