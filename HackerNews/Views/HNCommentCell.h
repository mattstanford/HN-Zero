//
//  HNCommentCell.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/15/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNTableViewCell.h"

@interface HNCommentCell : UITableViewCell
{
    NSNumber *nestedLevel;    
    UILabel *nameLabel;
}

@property (nonatomic, strong) NSNumber *nestedLevel;
@property (nonatomic, strong) UILabel *nameLabel;

+ (CGFloat) getIndentWidth:(NSNumber *)level;
+ (int) getOverflowIndentLevels:(NSNumber *)level;
+ (CGFloat) getCellHeightForText:(NSString *)text width:(CGFloat)cellWidth nestLevel:(NSNumber *)nestedLevel withFont:(UIFont *)cellFont;

@end
