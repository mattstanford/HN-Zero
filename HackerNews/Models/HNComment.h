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
@class HNCommentString;

@interface HNComment : NSObject

@property (nonatomic, strong) HNCommentBlock *commentBlock;
@property (nonatomic, strong) NSNumber *objectId;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *dateWritten;
@property (nonatomic, strong) NSNumber *nestedLevel;

- (void)setFirebaseData:(NSDictionary *)data nestedLevel:(NSNumber *)nestedLevel;
- (NSAttributedString *) getCommentHeaderWithTheme:(HNTheme *)theme forCellWidth:(CGFloat)cellWidth;
- (NSAttributedString *) convertToAttributedStringWithTheme:(HNTheme *)theme;
- (HNCommentString *) convertToCommentString;


@end
