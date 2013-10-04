//
//  HNComment.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/5/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNCommentBlock;
@class HNTheme;

@interface HNComment : NSObject
{
    HNCommentBlock *commentBlock;
    NSString *author;
    NSString *dateWritten;
    NSNumber *nestedLevel;
    
}

@property (nonatomic, strong) HNCommentBlock *commentBlock;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *dateWritten;
@property (nonatomic, strong) NSNumber *nestedLevel;

- (NSAttributedString *) getCommentHeaderWithTheme:(HNTheme *)theme;
- (NSAttributedString *) convertToAttributedStringWithTheme:(HNTheme *)theme;


@end
