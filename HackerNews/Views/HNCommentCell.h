//
//  HNCommentCell.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/15/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNTableViewCell.h"
#import <TTTAttributedLabel.h>

@interface HNCommentCell : UITableViewCell
{
    NSNumber *nestedLevel;    
    UILabel *nameLabel;
    TTTAttributedLabel *contentLabel;
}

@property (nonatomic, strong) NSNumber *nestedLevel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;

+ (CGFloat) getIndentWidth:(NSNumber *)level;
+ (int) getOverflowIndentLevels:(NSNumber *)level;
+ (CGFloat) getCellHeightForText:(NSAttributedString *)text width:(CGFloat)cellWidth nestLevel:(NSNumber *)nestedLevel;

@end
