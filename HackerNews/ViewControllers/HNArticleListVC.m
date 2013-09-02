//
//  HNArticleListVC.m
//  HackerNews
//
//  Created by Matthew Stanford on 8/29/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNArticleListVC.h"
#import "HNArticleCell.h"
#import "AFHTTPRequestOperation.h"
#import "HNParser.h"

@interface HNArticleListVC ()

@end

@implementation HNArticleListVC

@synthesize frontPageURL, articles, webBrowserVC;

- (id)initWithStyle:(UITableViewStyle)style withWebBrowserVC:(HNWebBrowserVC *)webVC
{
    self = [super initWithStyle:style];
    if (self) {
        
        webBrowserVC = webVC;
        //frontPageURL = @"http://api.ihackernews.com/page";
        frontPageURL = @"http://news.ycombinator.com";
        articles = [[NSArray alloc] init];
        

        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                     target:self
                                     action:@selector(reloadButtonPressed)];
    //[[self.navigationController navigationItem] setRightBarButtonItem:reloadButton];
    self.navigationItem.rightBarButtonItem = reloadButton;
    
    [self.tableView registerClass:[HNArticleCell class] forCellReuseIdentifier:@"Cell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self downloadFrontPageArticles];
    
}

- (void)reloadButtonPressed
{
    [self downloadFrontPageArticles];
}


- (void) downloadFrontPageArticles
{
    NSURL *url = [NSURL URLWithString:self.frontPageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:
    ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         [HNParser parseArticles:responseObject];
         
         //NSLog(@"URL request success: %@", responseString );
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *erro)
     {
         NSLog(@"URL request failed!");
     }];

    
    [operation start];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
       return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count: %d", [articles count]);
    return [articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    HNArticleCell *cell = (HNArticleCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[HNArticleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSString *articleText = [[self.articles objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.articleTitleLabel.text = articleText;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedUrl = [[self.articles objectAtIndex:indexPath.row] objectForKey:@"url"];
    
    [webBrowserVC setURL:selectedUrl];
    [self.navigationController pushViewController:webBrowserVC animated:YES];

}

@end
