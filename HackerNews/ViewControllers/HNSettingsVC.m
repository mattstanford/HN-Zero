//
//  HNSettingsVC.m
//  HN Zero
//
//  Created by Matt Stanford on 9/15/14.
//  Copyright (c) 2014 Matthew Stanford. All rights reserved.
//

#import "HNSettingsVC.h"

NS_ENUM(NSInteger, HNSettingsSections)
{
    HNSettingsSectionsThemes,
    HNSettingsNumSections
};

@interface HNSettingsVC ()

@property (nonatomic, strong) NSArray *themesArray;
@property (nonatomic, assign) NSInteger selectedThemeIndex;

@end

@implementation HNSettingsVC

-(id)init
{
    self = [super init];
    if(self)
    {
        self.title = @"Settings";
        self.themesArray = [[NSArray alloc] initWithObjects:@"Light", @"Dark", nil];
        self.selectedThemeIndex = 0;
    }
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

#pragma mark UITableView delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == HNSettingsSectionsThemes)
    {
        self.selectedThemeIndex = indexPath.row;
        [self.tableView reloadData];
    }
    
}

#pragma mark UITableViewDataSource delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(indexPath.section == HNSettingsSectionsThemes)
    {
        NSString *themeName = [self.themesArray objectAtIndex:indexPath.row];
        
        if(self.selectedThemeIndex == indexPath.row)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.textLabel.text = themeName;
        
    }
    
    return cell;

}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    
    switch (section) {
        case HNSettingsSectionsThemes:
            title = @"Theme";
            break;
            
        default:
            break;
    }
    
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = 0;
    
    if(section == HNSettingsSectionsThemes)
    {
        numRows = self.themesArray.count;
    }
    
    return numRows;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return HNSettingsNumSections;
}


@end
