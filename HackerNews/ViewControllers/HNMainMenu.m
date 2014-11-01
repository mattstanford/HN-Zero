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
#import "HNSettingsVC.h"
#import "HNUiUtils.h"
#import "HNTheme.h"
#import "HNSettings.h"

NSString * const kGithubLink = @"https://github.com/mds6058/HackerNews";
NSString * const kTwitterLink = @"twitter://post?message=@MattStanford3";

NS_ENUM(NSInteger, HNMainMenuSections)
{
    HNMainMenuPages,
    HNMainMenuSettings,
    HNMainMenuInfo,
    HNMainMenuNumSections
};

NS_ENUM(NSInteger, HNInfoCellTitles)
{
    //HNInfoCellSettings,
    HNInfoCellTitleTwitter,
    HNInfoCellTitleGitHub,
    HNInfoCellNumRows
};

NS_ENUM(NSInteger, HNMenuSettings)
{
    HNMenuSettingPreLoadComments,
    HNMenuSettingNumRows
};

@interface HNMainMenu ()

@property (nonatomic, strong) HNAbout *aboutMeVC;
@property (nonatomic, strong) HNSettingsVC *settingsVC;
@property (nonatomic, strong) UINavigationController *settingsNavController;
@property (nonatomic, strong) NSArray *mainItems;
@property (nonatomic, strong) HNSettings *settings;

@end

@implementation HNMainMenu

-(id) initWithStyle:(UITableViewStyle)style
          withTheme:(HNTheme *)theme
      withArticleVC:(HNArticleListVC *)theArticleListVC
      withMenuLinks:(NSArray *)menuLinks
        andSettings:(HNSettings *)settings
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.title = @"Hacker News Zero";
        
        self.aboutMeVC = [[HNAbout alloc] init];
        self.settingsVC = [[HNSettingsVC alloc] init];
        self.settingsNavController = [[UINavigationController alloc] initWithRootViewController:self.settingsVC];
        [HNUiUtils setTitleBarColors:theme withNavController:self.settingsNavController];
        
        self.articleListVC = theArticleListVC;
        
        //Eliminate the the text for the "back" button in iOS7 (style choice)
        int sysVer = [[[UIDevice currentDevice] systemVersion] integerValue];
        if (sysVer >= 7)
        {
            self.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        }
        
        
        self.mainItems = menuLinks;
        self.settings = settings;
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
    return HNMainMenuNumSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numRows = 0;
    
    if (section == HNMainMenuPages)
    {
        numRows = [self.mainItems count];
    }
    else if(section == HNMainMenuSettings)
    {
        numRows = HNMenuSettingNumRows;
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
        case HNMainMenuSettings:
            returnString = @"Settings";
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
    else if (indexPath.section == HNMainMenuSettings)
    {
        cell = [self setupSettingCell:cell indexPath:indexPath];
    }
    else
    {
        cell = [self setupInfoCell:cell indexPath:indexPath];
    }
    
    return cell;

}

- (UITableViewCell *)setupSettingCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case HNMenuSettingPreLoadComments:
            cell.textLabel.text = @"Pre-load comments";
            
            if (_settings.doPreLoadComments == TRUE)
            {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else
            {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            break;
            
        default:
            break;
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
            break;
            
//        case HNInfoCellSettings:
//            cell.textLabel.text = @"Settings";
//            break;
            
        default:
            break;
    }
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([indexPath section] == HNMainMenuPages)
    {
        HNMenuLink *menuItem = [self.mainItems objectAtIndex:[indexPath row]];
        [self goToMenuLink:menuItem];
    }
    else if([indexPath section] == HNMainMenuSettings)
    {
        _settings.doPreLoadComments = !_settings.doPreLoadComments;
        [_settings saveToCache];
        [self.tableView reloadData];
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
                break;
            
//            case HNInfoCellSettings:
//                NSLog(@"Tapped settings");
//                [self presentViewController:self.settingsNavController animated:YES completion:nil];
//                break;
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
