//
//  HNMainMenu.m
//  HackerNews
//
//  Created by Matthew Stanford on 10/15/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNMainMenu.h"
#import "HNArticleListVC.h"
#import "HNAbout.h"

@implementation HNMainMenu

@synthesize aboutMeVC, articleListVC, mainItems;

-(id) initWithStyle:(UITableViewStyle)style withArticleVC:(HNArticleListVC *)theArticleListVC
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.title = @"Hacker News Zero";
        
        self.aboutMeVC = [[HNAbout alloc] init];
        
        self.articleListVC = theArticleListVC;
        
        NSDictionary *frontPage = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSURL URLWithString:@"https://news.ycombinator.com"], @"url",
                                   @"Front Page", @"title"
                                   , nil];
        NSDictionary *askHN = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSURL URLWithString:@"https://news.ycombinator.com/ask"], @"url",
                               @"Ask HN", @"title"
                               , nil];
        NSDictionary *newHN = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSURL URLWithString:@"https://news.ycombinator.com/newest"], @"url",
                               @"New", @"title"
                               , nil];
        
        
        //Eliminate the the text for the "back" button in iOS7 (style choice)
        int sysVer = [[[UIDevice currentDevice] systemVersion] integerValue];
        if (sysVer >= 7)
        {
            self.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        }
        
        
        self.mainItems = [[NSArray alloc] initWithObjects:frontPage, askHN, newHN, nil];
    }
    
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numRows = 0;
    
    if (section == 0)
    {
        numRows = [mainItems count];
    }
    else
    {
        numRows = 1;
    }

    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    if (indexPath.section == 0)
    {
    
        NSDictionary *menuItem = [self.mainItems objectAtIndex:[indexPath row]];
    
        if ([menuItem objectForKey:@"title"])
        {
            cell.textLabel.text = (NSString *)[menuItem objectForKey:@"title"];
        }
    }
    else
    {
        cell.textLabel.text = @"About";
    }
    
    return cell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([indexPath section] == 0)
    {
        NSDictionary *menuItem = [self.mainItems objectAtIndex:[indexPath row]];
    
        if ([menuItem objectForKey:@"url"] && [menuItem objectForKey:@"title"])
        {
            NSURL *url = [menuItem objectForKey:@"url"];
            NSString *title = [menuItem objectForKey:@"title"];
        
            [self.articleListVC setUrl:url andTitle:title];
        
            [self.navigationController pushViewController:self.articleListVC animated:YES];
        
        }
    }
    else
    {
        [self.navigationController pushViewController:self.aboutMeVC animated:YES];
    }
    
}
@end
