//
//  HNCommentParser.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/11/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNComment;

@interface HNCommentParser : NSObject

+ (NSArray *)parseComments:(NSData *)htmlData;
+ (HNComment *)getPostFromCommentPage:(NSData *)htmlData;

@end
