//
//  HNArticleListVC.h
//  HackerNews
//
//  Created by Matthew Stanford on 8/29/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface HNArticleListVC : UITableViewController 
{
    NSString *frontPageURL;
    NSArray *articles;
}

- (void) downloadFrontPageArticles;

@property (strong, nonatomic) NSString *frontPageURL;
@property (strong, nonatomic) NSArray *articles;

@end
