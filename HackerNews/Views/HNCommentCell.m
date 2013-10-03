//
//  HNCommentCell.m
//  HackerNews
//
//  Created by Matthew Stanford on 9/15/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNCommentCell.h"

@implementation HNCommentCell

static const CGFloat CELL_LEFT_MARGIN = 10;
static const CGFloat CELL_RIGHT_MARGIN = 30;
static const CGFloat CELL_TOP_MARGIN = 10;
static const CGFloat CELL_BOTTOM_MARGIN = 10;
static const CGFloat NAME_LABEL_HEIGHT = 20;

static const int INDENT_PER_LEVEL = 20;
static const int MAX_INDENT_WIDTH = 80;

@synthesize nestedLevel, nameLabel;


-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.nestedLevel = [[NSNumber alloc] initWithInt:0];
        
        [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.textLabel setNumberOfLines:0];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];

    }
    
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat indentAmount = [HNCommentCell getIndentWidth:self.nestedLevel] + CELL_LEFT_MARGIN;
    
    
    CGFloat nameLabelX = indentAmount;
    CGFloat nameLabelY = CELL_TOP_MARGIN;
    CGFloat nameLabelWidth = [self getLabelWidth:self.nestedLevel];
    
    CGFloat labelX = indentAmount;
    CGFloat labelY = nameLabelY + NAME_LABEL_HEIGHT;
    CGFloat labelWidth = [self getLabelWidth:self.nestedLevel];
    CGFloat labelHeight = self.frame.size.height - labelY - CELL_BOTTOM_MARGIN;
    
    self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelWidth, NAME_LABEL_HEIGHT);
    self.textLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);

}

+ (CGFloat) getIndentWidth:(NSNumber *)level
{
    CGFloat indentWidth = INDENT_PER_LEVEL * [level floatValue];
    
    //If over max width, make it the closest indent level to the max
    if (indentWidth > MAX_INDENT_WIDTH)
    {
        int overFlowLevels = [HNCommentCell getOverflowIndentLevels:level];
        
        indentWidth = indentWidth - (overFlowLevels * INDENT_PER_LEVEL);
    }
        
    return indentWidth;
}

+ (int) getOverflowIndentLevels:(NSNumber *)level
{
    CGFloat indentWidth = INDENT_PER_LEVEL * [level floatValue];
    
    CGFloat overflow = indentWidth - MAX_INDENT_WIDTH;
    int overflowLevels = ceilf(overflow / INDENT_PER_LEVEL);
    
    return overflowLevels;
}

- (CGFloat) getLabelWidth:(NSNumber *)indentLevel
{
    CGFloat indentWidth = [HNCommentCell getIndentWidth:self.nestedLevel];
    
    return self.frame.size.width - indentWidth - CELL_LEFT_MARGIN - CELL_RIGHT_MARGIN;
}

+ (CGFloat) getCellHeightForText:(NSString *)text width:(CGFloat)cellWidth nestLevel:(NSNumber *)nestedLevel withFont:(UIFont *)cellFont
{
    CGFloat indentWidth = [HNCommentCell getIndentWidth:nestedLevel];
    CGFloat labelWidth = cellWidth - indentWidth - CELL_LEFT_MARGIN - CELL_RIGHT_MARGIN;
    
    CGSize constraint = CGSizeMake(labelWidth, CGFLOAT_MAX);
    
    CGSize commentSize = [text sizeWithFont:cellFont constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    return commentSize.height + NAME_LABEL_HEIGHT + CELL_BOTTOM_MARGIN + CELL_TOP_MARGIN;
}


@end
