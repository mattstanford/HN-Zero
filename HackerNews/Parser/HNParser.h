//
//  HNParser.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/1/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNParser : NSObject

+ (NSString *) getMoreArticlesLink:(NSData *)htmlData;
+ (NSArray *) parseArticles:(NSData *)htmlData;
+ (NSString *) getMatch:(NSString *)stringToMatch fromRegex:(NSString *)pattern;

@end
