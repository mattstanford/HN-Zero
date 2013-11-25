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
#import "HNMenuLink.h"

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

        HNMenuLink *frontPage = [[HNMenuLink alloc] init];
        frontPage.title = @"Front Page";
        frontPage.url = [NSURL URLWithString:@"https://news.ycombinator.com"];
        
        HNMenuLink *askHN = [[HNMenuLink alloc] init];
        askHN.title = @"Ask HN";
        askHN.url = [NSURL URLWithString:@"https://news.ycombinator.com/ask"];
        
        HNMenuLink *newHN = [[HNMenuLink alloc] init];
        newHN.title = @"New";
        newHN.url = [NSURL URLWithString:@"https://news.ycombinator.com/newest"];
        
        
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
    
        HNMenuLink *menuItem = [self.mainItems objectAtIndex:[indexPath row]];
    
        cell.textLabel.text = menuItem.title;
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
        HNMenuLink *menuItem = [self.mainItems objectAtIndex:[indexPath row]];
        [self goToMenuLink:menuItem];
    }
    else
    {
        [self.navigationController pushViewController:self.aboutMeVC animated:YES];
    }
    
}

- (void) goToMenuLink:(HNMenuLink *)link
{
    [self.articleListVC setUrl:link.url andTitle:link.title];
    [self.navigationController pushViewController:self.articleListVC animated:YES];
}

@end
