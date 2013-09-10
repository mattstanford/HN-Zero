//
//  HNArticleListVC.m
//  HackerNews
//
//  Created by Matthew Stanford on 8/29/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNArticleListVC.h"
#import "AFHTTPRequestOperation.h"
#import "HNParser.h"
#import "HNArticle.h"

@interface HNArticleListVC ()

@end

@implementation HNArticleListVC

@synthesize articles, webBrowserVC, downloadController;

- (id)initWithStyle:(UITableViewStyle)style withWebBrowserVC:(HNWebBrowserVC *)webVC
{
    self = [super initWithStyle:style];
    if (self) {
        
        webBrowserVC = webVC;
        articles = [[NSArray alloc] init];
        
        downloadController = [[HNDownloadController alloc] init];
        downloadController.downloadDelegate = self;
        
        
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

- (BOOL) shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)reloadButtonPressed
{
    [self downloadFrontPageArticles];
}


- (void) downloadFrontPageArticles
{
    [downloadController getFrontPageArticles];
    
}

#pragma mark HNDownloadControllerDelegate

-(void) downloadDidComplete:(NSArray *)data
{
    self.articles = data;
    [self.tableView reloadData];
}

-(void) downloadFailed
{
    NSLog(@"Download failed!");
}

#pragma mark HNArticleCellDelegate

-(void) didTapArticle:(HNArticleCell *)cellTapped
{
    NSLog(@"article tapped!");
}

-(void) didTapComment:(HNArticleCell *)cellTapped
{
    NSLog(@"comment tapped!");
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
    
    NSString *articleText = [[self.articles objectAtIndex:indexPath.row] title];
    cell.articleTitleLabel.text = articleText;
    cell.delegate = self;
    cell.tag = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNArticle *article = [self.articles objectAtIndex:indexPath.row];
    NSString *selectedUrl = article.url;
    
    [webBrowserVC setURL:selectedUrl];
    [self.navigationController pushViewController:webBrowserVC animated:YES];
    
}

@end
