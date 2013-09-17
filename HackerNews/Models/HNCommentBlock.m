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

- (NSAttributedString *) getStringRepresentation
{
    NSMutableAttributedString *blockString = [[NSMutableAttributedString alloc] init];
    
    if ([self.tagName isEqualToString:@"text"] && self.text) {
        return [[NSAttributedString alloc] initWithString:self.text];
    }
    
    if ([self.tagName isEqualToString:@"p"])
    {
        [blockString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    }
    
    for (HNCommentBlock *child in childBlocks)
    {
        [blockString appendAttributedString:[child getStringRepresentation]];
        
    }
    
    return blockString;
}

@end
