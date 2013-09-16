//
//  HNComment.m
//  HackerNews
//
//  Created by Matthew Stanford on 9/5/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNComment.h"
#import "HNCommentBlock.h"

@implementation HNComment

@synthesize commentBlock, author, dateWritten, nestedLevel;

- (NSString *) getStringRepresentationOfBlocks
{
    return [self.commentBlock getStringRepresentation];
}

@end
