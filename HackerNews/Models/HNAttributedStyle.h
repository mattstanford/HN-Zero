//
//  HNAttributedStyle.h
//  HackerNews
//
//  Created by Matthew Stanford on 10/6/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNAttributedStyle : NSObject
{
    NSString *styleType;
    NSObject *value;
}

@property (nonatomic, strong) NSString *styleType;
@property (nonatomic, strong) NSObject *value;
@property (nonatomic, assign) NSRange range;

-(id) initWithStyleType:(NSString *)theStyleType value:(NSObject *)theValue range:(NSRange)theRange;

@end
