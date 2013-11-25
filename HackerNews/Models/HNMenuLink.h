//
//  HNMenuLink.h
//  HN Zero
//
//  Created by Matt Stanford on 11/24/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNMenuLink : NSObject
{
    NSString *title;
    NSURL *url;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *url;

@end
