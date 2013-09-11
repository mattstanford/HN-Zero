//
//  HNParser.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/1/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNParser : NSObject

+ (NSArray *) parseArticles:(NSData *)htmlData;

@end
