//
//  HNAttributedStyle.m
//  HackerNews
//
//  Created by Matthew Stanford on 10/6/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNAttributedStyle.h"

@implementation HNAttributedStyle

@synthesize styleType, value, range;

-(id) initWithStyleType:(NSString *)theStyleType value:(NSObject *)theValue range:(NSRange)theRange
{
    self = [super init];
    if (self) {
        
        self.styleType = theStyleType;
        self.value = theValue;
        self.range = theRange;
    }
    
    return self;
}

@end
