//
//  HNSettings.m
//  HN Zero
//
//  Created by Matt Stanford on 10/19/14.
//  Copyright (c) 2014 Matthew Stanford. All rights reserved.
//

#import "HNSettings.h"

@implementation HNSettings

NSString * const HNSettingsCacheKey = @"HNSettings";
NSString * const HNSettingsDoPreLoadComments = @"doPreloadComments";

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        NSNumber *doPreloadCommentsNumber = [aDecoder decodeObjectForKey:HNSettingsDoPreLoadComments];
        self.doPreLoadComments = [doPreloadCommentsNumber boolValue];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    NSNumber *doPreLoadCommentsObject = [[NSNumber alloc] initWithBool:self.doPreLoadComments];
    [aCoder encodeObject:doPreLoadCommentsObject forKey:HNSettingsDoPreLoadComments];
}

- (void)saveToCache
{
    NSData *settingsArchive = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:settingsArchive forKey:HNSettingsCacheKey];
}

+ (HNSettings *)getCachedSettings
{
    HNSettings *settings = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:HNSettingsCacheKey])
    {
        NSData *settingsArchive = [[NSUserDefaults standardUserDefaults] objectForKey:HNSettingsCacheKey];
        settings  = [NSKeyedUnarchiver unarchiveObjectWithData:settingsArchive];
    }
    
    return settings;
}




@end
