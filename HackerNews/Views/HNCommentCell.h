//
//  HNCommentCell.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/15/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNTableViewCell.h"

@interface HNCommentCell : HNTableViewCell
{
    NSNumber *nestedLevel;
    CGFloat nameLabelHeight;
    CGFloat indentPerLevel;
    CGFloat maxIndentWidth;
    
    UILabel *nameLabel;
    
}

@property (nonatomic, strong) NSNumber *nestedLevel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, assign) CGFloat nameLabelHeight;
@property (nonatomic, assign) CGFloat indentPerLevel;
@property (nonatomic, assign) CGFloat maxIndentWidth;

+ (CGFloat) getIndentWidth:(NSNumber *)level perLevel:(CGFloat)indentPerLevel maxWidth:(CGFloat)minWidth;
+ (int) getOverflowIndentLevels:(NSNumber *)level perLevel:(CGFloat)indentPerLevel maxWidth:(CGFloat)maxWidth;

@end
