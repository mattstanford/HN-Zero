//
//  HNCommentString.h
//  HackerNews
//
//  Created by Matthew Stanford on 10/6/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNTheme;

@interface HNCommentString : NSObject

@property (nonatomic, strong) NSMutableString *text;
@property (nonatomic, strong) NSMutableArray *styles;

-(id) initWithString:(NSString *)theString styles:(NSArray *)theStyles;
-(void) appendCommentString:(HNCommentString *)commentString;
-(NSAttributedString *) getAttributedStringWithTheme:(HNTheme *)theme;
-(NSArray *) getLinks;

@end
