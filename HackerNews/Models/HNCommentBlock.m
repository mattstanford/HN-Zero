//
//  HNCommentBlock.m
//  HackerNews
//
//  Created by Matthew Stanford on 9/15/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNCommentBlock.h"

@implementation HNCommentBlock

@synthesize childBlocks, tagName, text;

- (NSString *) getStringRepresentation
{
    NSMutableString *blockString = [[NSMutableString alloc] initWithCapacity:0];
    
    if (self.text) {
        [blockString appendFormat:@"%@", self.text];
    }
    
    for (HNCommentBlock *child in childBlocks)
    {
        [blockString appendFormat:@"\n%@", [child getStringRepresentation]];
    }
    
    return blockString;
}

@end
