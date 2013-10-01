//
//  HNCommentCell.m
//  HackerNews
//
//  Created by Matthew Stanford on 9/15/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNCommentCell.h"

@implementation HNCommentCell

@synthesize nestedLevel, nameLabel, nameLabelHeight, indentPerLevel, maxIndentWidth;


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
    
    CGFloat indentAmount = [HNCommentCell getIndentWidth:self.nestedLevel perLevel:self.indentPerLevel maxWidth:self.maxIndentWidth] + self.leftMargin;
    
    
    CGFloat nameLabelX = indentAmount;
    CGFloat nameLabelY = self.topMargin;
    CGFloat nameLabelWidth = [self getLabelWidth:self.nestedLevel];
    
    CGFloat labelX = indentAmount;
    CGFloat labelY = nameLabelY + self.nameLabelHeight;
    CGFloat labelWidth = [self getLabelWidth:self.nestedLevel];
    CGFloat labelHeight = self.frame.size.height - labelY - self.bottomMargin;
    
    self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelWidth, self.nameLabelHeight);
    self.textLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);

}

+ (CGFloat) getIndentWidth:(NSNumber *)level perLevel:(CGFloat)indentPerLevel maxWidth:(CGFloat)maxWidth
{
    CGFloat indentWidth = indentPerLevel * [level floatValue];
    
    //If over max width, make it the closest indent level to the max
    if (indentWidth > maxWidth)
    {
        int overFlowLevels = [HNCommentCell getOverflowIndentLevels:level perLevel:indentPerLevel maxWidth:maxWidth];
        
        indentWidth = indentWidth - (overFlowLevels * indentPerLevel);
    }
        
    return indentWidth;
}

+ (int) getOverflowIndentLevels:(NSNumber *)level perLevel:(CGFloat)indentPerLevel maxWidth:(CGFloat)maxWidth
{
    CGFloat indentWidth = indentPerLevel * [level floatValue];
    
    CGFloat overflow = indentWidth - maxWidth;
    int overflowLevels = ceilf(overflow / indentPerLevel);
    
    return overflowLevels;
}

- (CGFloat) getLabelWidth:(NSNumber *)indentLevel
{
    CGFloat indentWidth = [HNCommentCell getIndentWidth:self.nestedLevel perLevel:self.indentPerLevel maxWidth:self.maxIndentWidth];
    return self.frame.size.width - indentWidth - self.leftMargin - self.rightMargin;
}


@end
