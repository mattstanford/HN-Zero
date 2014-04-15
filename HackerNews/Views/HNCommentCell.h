//
//  HNCommentCell.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/15/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TTTAttributedLabel.h>

@interface HNCommentCell : UITableViewCell
{
    NSNumber *nestedLevel;    
    UILabel *nameLabel;
    TTTAttributedLabel *contentLabel;
    UIView *separatorView;
}

@property (nonatomic, strong) NSNumber *nestedLevel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) TTTAttributedLabel *contentLabel;
@property (nonatomic, strong) UIView *separatorView;

//+ (CGFloat) getIndentWidth:(NSNumber *)level;
+ (int) getOverflowIndentLevels:(NSNumber *)level forCellWidth:(CGFloat)cellWidth;
+ (CGFloat) getCellHeightForText:(NSAttributedString *)text width:(CGFloat)cellWidth nestLevel:(NSNumber *)nestedLevel;

@end
