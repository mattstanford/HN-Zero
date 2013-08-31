//
//  HNArticleListVC.m
//  HackerNews
//
//  Created by Matthew Stanford on 8/29/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNArticleListVC.h"

@interface HNArticleListVC ()

@end

@implementation HNArticleListVC

@synthesize frontPageURL, articles, webBrowserVC;

- (id)initWithStyle:(UITableViewStyle)style withWebBrowserVC:(HNWebBrowserVC *)webVC
{
    self = [super initWithStyle:style];
    if (self) {
        
        webBrowserVC = webVC;
        frontPageURL = @"http://api.ihackernews.com/page";
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
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
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
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^
     (NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
     {
         NSLog(@"JSON Retrieved");
         self.articles = [(NSDictionary *)JSON objectForKey:@"items"];
         [self.tableView reloadData];
     }
                                                    failure:^
     (NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
     {
         NSLog(@"Error retrieving JSON!");
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

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    cell.textLabel.text = [[self.articles objectAtIndex:indexPath.row] objectForKey:@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedUrl = [[self.articles objectAtIndex:indexPath.row] objectForKey:@"url"];
    
    [webBrowserVC setURL:selectedUrl];
    [self.navigationController pushViewController:webBrowserVC animated:YES];

}

@end
