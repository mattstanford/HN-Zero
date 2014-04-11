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
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation HNMainMenu

@synthesize aboutMeVC, articleListVC, mainItems;

-(id) initWithStyle:(UITableViewStyle)style withArticleVC:(HNArticleListVC *)theArticleListVC withMenuLinks:(NSArray *)menuLinks
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.title = @"Hacker News Zero";
        
        self.aboutMeVC = [[HNAbout alloc] init];
        self.articleListVC = theArticleListVC;
        
        //Eliminate the the text for the "back" button in iOS7 (style choice)
        int sysVer = [[[UIDevice currentDevice] systemVersion] integerValue];
        if (sysVer >= 7)
        {
            self.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        }
        
        
        self.mainItems = menuLinks;
    }
    
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Google analytics tracking
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Article List"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
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
        //TODO: change this to a modal dialog for iPad
        [self.navigationController pushViewController:self.aboutMeVC animated:YES];
    }
    
}

- (void) goToMenuLink:(HNMenuLink *)link
{
    [self.articleListVC setUrl:link.url andTitle:link.title];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.articleListVC closeDrawer];
    }
    else
    {
        [self.navigationController pushViewController:self.articleListVC animated:YES];
    }
}

@end
