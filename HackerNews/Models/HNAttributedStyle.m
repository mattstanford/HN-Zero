//
//  HNAttributedStyle.m
//  HackerNews
//
//  Created by Matthew Stanford on 10/6/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNAttributedStyle.h"

@implementation HNAttributedStyle

-(id) initWithStyleType:(HNSTYLETYPE)theStyleType range:(NSRange)theRange
{
    return [self initWithStyleType:theStyleType range:theRange attributes:nil];
}

-(id) initWithStyleType:(HNSTYLETYPE)theStyleType range:(NSRange)theRange attributes:(NSDictionary *)theAttributes;
{
    self = [super init];
    if (self)
    {
        self.styleType = theStyleType;
        self.range = theRange;
        self.attributes = theAttributes;
    }
    
    return self;
    
}

@end
