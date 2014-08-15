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

NSString * const kGithubLink = @"https://github.com/mds6058/HackerNews";
NSString * const kTwitterLink = @"twitter://post?message=@MattStanford3";

NS_ENUM(NSInteger, HNMainMenuSections)
{
    HNMainMenuPages,
    HNMainMenuInfo
};

NS_ENUM(NSInteger, HNInfoCellTitles)
{
    HNInfoCellTitleTwitter,
    HNInfoCellTitleGitHub,
    HNInfoCellNumRows
};

@interface HNMainMenu ()

@property (nonatomic, strong) HNAbout *aboutMeVC;
@property (nonatomic, strong) NSArray *mainItems;

@end

@implementation HNMainMenu

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
    
    if (section == HNMainMenuPages)
    {
        numRows = [self.mainItems count];
    }
    else
    {
        numRows = HNInfoCellNumRows;
    }

    return numRows;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *returnString;
    
    switch (section) {
        case HNMainMenuInfo:
            returnString = @"Contact/Info";
            break;
        case HNMainMenuPages:
        default:
            returnString = @"";
            break;
    }
    
    return returnString;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    if (indexPath.section == HNMainMenuPages)
    {
    
        HNMenuLink *menuItem = [self.mainItems objectAtIndex:[indexPath row]];
        cell.textLabel.text = menuItem.title;
    }
    else
    {
        cell = [self setupInfoCell:cell indexPath:indexPath];
    }
    
    return cell;

}

- (UITableViewCell *)setupInfoCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case HNInfoCellTitleGitHub:
            cell.textLabel.text = @"Source Code";
            //cell.imageView.image = [UIImage imageNamed:@"github icon"];
            break;
            
        case HNInfoCellTitleTwitter:
            cell.textLabel.text = @"Contact via Twitter";
            //cell.imageView.image = [UIImage imageNamed:@"twitter-icon"];
            
        default:
            break;
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
        switch (indexPath.row) {
            case HNInfoCellTitleGitHub:
                NSLog(@"Goto github");
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kGithubLink]];

                break;
            
            case HNInfoCellTitleTwitter:
                NSLog(@"Goto twitter: %@", kTwitterLink);
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kTwitterLink]];
                
            default:
                break;
        }
        
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
