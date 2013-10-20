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
static const CGFloat SEPARATOR_HEIGHT = .5;

static const int INDENT_PER_LEVEL = 20;
static const int MAX_INDENT_WIDTH = 80;

@synthesize nestedLevel, nameLabel, contentLabel, separatorView;

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.nestedLevel = [[NSNumber alloc] initWithInt:0];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];
        
        contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [contentLabel setNumberOfLines:0];
        [contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        contentLabel.userInteractionEnabled = TRUE;
        [self.contentView addSubview:self.contentLabel];
        
        self.separatorView = [[UIView alloc] initWithFrame:CGRectZero];
        self.separatorView.backgroundColor = [UIColor colorWithRed:.6666 green:.6666 blue:.6666 alpha:.5];
        [self addSubview:separatorView];

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
    self.contentLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    self.separatorView.frame = CGRectMake(0, self.frame.size.height - SEPARATOR_HEIGHT, self.frame.size.width, SEPARATOR_HEIGHT);

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

+ (CGFloat) getCellHeightForText:(NSAttributedString *)text width:(CGFloat)cellWidth nestLevel:(NSNumber *)nestedLevel
{
    CGFloat indentWidth = [HNCommentCell getIndentWidth:nestedLevel];
    CGFloat labelWidth = cellWidth - indentWidth - CELL_LEFT_MARGIN - CELL_RIGHT_MARGIN;
    
    //Create temporary label to get accurate label height
    TTTAttributedLabel *tempLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    tempLabel.attributedText = text;
    [tempLabel setNumberOfLines:0];
    CGSize constraint = CGSizeMake(labelWidth, CGFLOAT_MAX);
    CGSize commentSize = [tempLabel sizeThatFits:constraint];

    return commentSize.height + NAME_LABEL_HEIGHT + CELL_BOTTOM_MARGIN + CELL_TOP_MARGIN;
}


@end
