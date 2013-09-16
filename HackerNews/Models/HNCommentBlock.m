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
    
    if ([self.tagName isEqualToString:@"text"] && self.text) {
        return self.text;
    }
    
    if ([self.tagName isEqualToString:@"p"])
    {
        [blockString appendFormat:@"\n\n"];
    }
    
    for (HNCommentBlock *child in childBlocks)
    {
        [blockString appendFormat:@"%@", [child getStringRepresentation]];
        
    }
    
    return blockString;
}

@end
