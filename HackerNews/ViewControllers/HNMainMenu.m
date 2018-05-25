//
//  HNMainMenu.m
//  HackerNews
//
//  Created by Matthew Stanford on 10/15/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNMainMenu.h"
#import "HNArticleListVC.h"
#import "HNMenuLink.h"
#import "HNSettingsVC.h"
#import "HNTheme.h"
#import "HNSettings.h"
#import "HNThemeChanger.h"
#import "HNTheme+Themes.h"

NSString * const kGithubLink = @"https://github.com/mds6058/HackerNews";
NSString * const kTwitterAppLink = @"twitter://user?screen_name=hackernewszero";
NSString * const kTwitterBrowserLink = @"https://twitter.com/hackernewszero";
NSString * const kFacebookAppLink = @"fb://profile/1080017705457038";
NSString * const kFacebookBrowserLink = @"https://www.facebook.com/1080017705457038";


typedef NS_ENUM(NSInteger, HNMainMenuSection)
{
    HNMainMenuPages,
    HNMainMenuSettings,
    HNMainMenuThemes,
    HNMainMenuInfo,
    HNMainMenuNumSections
};

NS_ENUM(NSInteger, HNInfoCellTitles)
{
    //HNInfoCellSettings,
    HNInfoCellTitleTwitter,
    HNInfoCellTitleFacebook,
    HNInfoCellNumRows
};

NS_ENUM(NSInteger, HNMenuSettings)
{
    HNMenuSettingPreLoadComments,
    HNMenuSettingNumRows
};

@interface HNMainMenu ()

@property (nonatomic, strong) NSArray *mainItems;
@property (nonatomic, strong) HNSettings *settings;
@property (nonatomic, strong) HNTheme *theme;
@property (nonatomic, assign) HNMainMenuSection selectedSection;

@end

@implementation HNMainMenu

-(id) initWithStyle:(UITableViewStyle)style
          withTheme:(HNTheme *)theme
      withArticleVC:(HNArticleListVC *)theArticleListVC
      withMenuLinks:(NSArray *)menuLinks
        andSettings:(HNSettings *)settings;
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.title = @"Hacker News Zero";
        self.theme = theme;
        
        self.articleListVC = theArticleListVC;
        
        //Eliminate the the text for the "back" button in iOS7 (style choice)
        long sysVer = [[[UIDevice currentDevice] systemVersion] integerValue];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return HNMainMenuNumSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger numRows = 0;
    
    if (section == HNMainMenuPages)
    {
        numRows = [self.mainItems count];
    }
    else if(section == HNMainMenuSettings)
    {
        numRows = HNMenuSettingNumRows;
    }
    else if(section == HNMainMenuThemes)
    {
        numRows = self.themeChanger.themes.count;
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
            returnString = @"Social Media";
            break;
        case HNMainMenuSettings:
            returnString = @"Settings";
            break;
        case HNMainMenuThemes:
            returnString = @"Themes";
            break;
        case HNMainMenuPages:
        default:
            returnString = @"";
            break;
    }
    
    return returnString;
}

- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]])
    {
        UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
        headerView.textLabel.textColor = self.theme.titleTextColor;
    }
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.backgroundColor = self.theme.cellBackgroundColor;
    cell.textLabel.textColor = self.theme.titleTextColor;
    cell.tintColor = self.theme.titleTextColor;
    
    if (indexPath.section == HNMainMenuPages)
    {
        cell = [self setupPageCell:cell indexPath:indexPath];
    }
    else if (indexPath.section == HNMainMenuSettings)
    {
        cell = [self setupSettingCell:cell indexPath:indexPath];
    }
    else if(indexPath.section == HNMainMenuThemes)
    {
        cell = [self setupThemeCell:cell indexPath:indexPath];
    }
    else
    {
        cell = [self setupInfoCell:cell indexPath:indexPath];
    }
    
    return cell;

}

- (UITableViewCell *)setupPageCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    HNMenuLink *menuItem = [self.mainItems objectAtIndex:[indexPath row]];
    cell.textLabel.text = menuItem.title;
    
    if (indexPath.row == self.selectedSection)
    {
        cell.backgroundColor = self.theme.infoColor;
    }
    else
    {
        cell.backgroundColor = self.theme.cellBackgroundColor;
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
        case HNInfoCellTitleFacebook:
            cell.textLabel.text = @"HNZero on Facebook";
            //cell.imageView.image = [UIImage imageNamed:@"github icon"];
            break;
            
        case HNInfoCellTitleTwitter:
            cell.textLabel.text = @"HNZero on Twitter";
            //cell.imageView.image = [UIImage imageNamed:@"twitter-icon"];
            break;
            
//        case HNInfoCellSettings:
//            cell.textLabel.text = @"Settings";
//            break;
            
        default:
            break;
    }
    
    cell.selected = false;
    
    return cell;
}

- (UITableViewCell *)setupThemeCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    HNTheme *theme = [self.themeChanger.themes objectAtIndex:indexPath.row];
    cell.textLabel.text = theme.name;
    
    if ([theme.name isEqualToString:self.themeChanger.selectedTheme.name])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([indexPath section] == HNMainMenuPages)
    {
        HNMenuLink *menuItem = [self.mainItems objectAtIndex:[indexPath row]];
        
        if (self.selectedSection == indexPath.row)
        {
            [self goToArticleList];
        }
        else
        {
            [self.tableView reloadData];
            [self changeMenuLink:menuItem];
            self.selectedSection = indexPath.row;
            
        }
    }
    else if([indexPath section] == HNMainMenuSettings)
    {
        switch (indexPath.row)
        {
            case HNMenuSettingPreLoadComments:
            {
                _settings.doPreLoadComments = !_settings.doPreLoadComments;
                [_settings saveToCache];
                [self.tableView reloadData];
                break;
            }
        }
      
    }
    else if(indexPath.section == HNMainMenuThemes)
    {
        HNTheme *theme = [self.themeChanger.themes objectAtIndex:indexPath.row];
        [self.themeChanger switchViewsToTheme:theme];
        [self.tableView reloadData];
    }
    else
    {
        switch (indexPath.row) {
            case HNInfoCellTitleFacebook:
                NSLog(@"Goto facebook");
                
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
                    // Safe to launch the facebook app
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kFacebookAppLink]];
                }
                else
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kFacebookBrowserLink]];
                }

                break;
            
            case HNInfoCellTitleTwitter:
                
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
                    // Safe to launch the facebook app
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kTwitterAppLink]];
                }
                else
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kTwitterBrowserLink]];
                }
        
                break;
            

            default:
                break;
        }
        
        [tableView reloadData];
        
        
        
        
        
    }
    
}

- (void) changeMenuLink:(HNMenuLink *)link
{
    [self.articleListVC setUrl:link.url andTitle:link.title];
    
    [self goToArticleList];
}

-(void) goToArticleList
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.articleListVC closeDrawer];
    }
    else
    {
        [self.navigationController pushViewController:self.articleListVC animated:YES];
    }
}

-(void)changeTheme:(HNTheme *)theme
{
    self.theme = theme;
    self.tableView.backgroundColor = self.theme.tableViewBackgroundColor;
    [self.tableView reloadData];
}

@end
