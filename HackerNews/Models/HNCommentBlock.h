//
//  HNCommentBlock.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/15/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNCommentBlock : NSObject
{
    NSArray *childBlocks;
    NSString *tagName;
    NSString *text;
    NSDictionary *attributes;
}

@property (nonatomic, strong) NSArray *childBlocks;
@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDictionary *attributes;

@end
