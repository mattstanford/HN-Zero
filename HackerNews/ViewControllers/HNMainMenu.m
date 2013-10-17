//
//  HNMainMenu.m
//  HackerNews
//
//  Created by Matthew Stanford on 10/15/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNMainMenu.h"
#import "HNArticleListVC.h"

@implementation HNMainMenu

@synthesize articleListVC, mainItems;

-(id) initWithStyle:(UITableViewStyle)style withArticleVC:(HNArticleListVC *)theArticleListVC
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.title = @"Main Menu";
        
        self.articleListVC = theArticleListVC;
        
        NSDictionary *frontPage = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"https://news.ycombinator.com", @"url",
                                   @"Front Page", @"title"
                                   , nil];
        NSDictionary *askHN = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"https://news.ycombinator.com/ask", @"url",
                               @"Ask HN", @"title"
                               , nil];
        NSDictionary *newHN = [[NSDictionary alloc] initWithObjectsAndKeys:
                               @"https://news.ycombinator.com/newest", @"url",
                               @"New", @"title"
                               , nil];
        
        self.mainItems = [[NSArray alloc] initWithObjects:frontPage, askHN, newHN, nil];
    }
    
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mainItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *menuItem = [self.mainItems objectAtIndex:[indexPath row]];
    
    if ([menuItem objectForKey:@"title"])
    {
        cell.textLabel.text = (NSString *)[menuItem objectForKey:@"title"];
    }
    
    return cell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *menuItem = [self.mainItems objectAtIndex:[indexPath row]];
    
    if ([menuItem objectForKey:@"url"] && [menuItem objectForKey:@"title"])
    {
        NSString *url = [menuItem objectForKey:@"url"];
        NSString *title = [menuItem objectForKey:@"title"];
        
        [self.articleListVC setUrl:url andTitle:title];
        
        [self.navigationController pushViewController:self.articleListVC animated:YES];
        
    }
    
}
@end
