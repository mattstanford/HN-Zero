//
//  HNSettings.h
//  HN Zero
//
//  Created by Matt Stanford on 10/19/14.
//  Copyright (c) 2014 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNSettings : NSObject <NSCoding>

@property (nonatomic, assign) BOOL doPreLoadComments;

- (void)saveToCache;
+ (HNSettings *)getCachedSettings;

@end
