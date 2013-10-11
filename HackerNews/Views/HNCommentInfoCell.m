//
//  HNCommentInfoCell.m
//  HackerNews
//
//  Created by Matthew Stanford on 10/10/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNCommentInfoCell.h"

@implementation HNCommentInfoCell

@synthesize articleTitleLabel, infoLabel;

static const int LEFT_MARGIN = 10;
static const int RIGHT_MARGIN = 10;
static const int TOP_MARGIN = 20;
static const int BOTTOM_MARGIN = 20;

static const int TITLE_INFO_PADDING = 10;

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.articleTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.articleTitleLabel.text = @"Title";
        [articleTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[articleTitleLabel setNumberOfLines:0];
        articleTitleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:articleTitleLabel];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.infoLabel.text = @"info";
        [self.contentView addSubview:infoLabel];
    }
    
    return self;
}

+(CGFloat) getCellHeightForText:(NSString *)titleText forWidth:(CGFloat)cellWidth titleFont:(UIFont *)titleFont infoFont:(UIFont *)infoFont
{
    CGFloat width = [HNCommentInfoCell getLabelWidth:cellWidth];
    CGFloat titleHeight = [HNCommentInfoCell getTitleHeightForText:titleText forWidth:width titleFont:titleFont];

    //Sample string for info label.  The info label will always be one line
    NSString *tempString = @"test string";
    CGFloat infoHeight = [HNCommentInfoCell getInfoHeightForText:tempString forWidth:width infoFont:infoFont];
    
    return TOP_MARGIN + titleHeight + TITLE_INFO_PADDING + infoHeight + BOTTOM_MARGIN;
}

+(CGFloat) getTitleHeightForText:(NSString *)titleText forWidth:(CGFloat)width titleFont:(UIFont *)font
{
    CGSize labelConstraint = CGSizeMake(width, CGFLOAT_MAX);
    
    return [titleText sizeWithFont:font constrainedToSize:labelConstraint lineBreakMode:NSLineBreakByWordWrapping].height;
}

+(CGFloat) getInfoHeightForText:(NSString *)infoText forWidth:(CGFloat)width infoFont:(UIFont *)font
{
    return [infoText sizeWithFont:font forWidth:width lineBreakMode:NSLineBreakByClipping].height;
}

+(CGFloat) getLabelWidth:(CGFloat)cellWidth
{
    return cellWidth - LEFT_MARGIN - RIGHT_MARGIN;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat labelWidth = [HNCommentInfoCell getLabelWidth:self.frame.size.width];
    
    CGFloat titleX = LEFT_MARGIN;
    CGFloat titleY = TOP_MARGIN;
    CGFloat titleHeight = [HNCommentInfoCell getTitleHeightForText:self.articleTitleLabel.text forWidth:labelWidth titleFont:self.articleTitleLabel.font];
    
    CGFloat infoLabelX = LEFT_MARGIN;
    CGFloat infoLabelY = TOP_MARGIN + titleHeight + TITLE_INFO_PADDING;
    CGFloat infoHeight = [HNCommentInfoCell getInfoHeightForText:self.infoLabel.text forWidth:labelWidth infoFont:self.infoLabel.font];
    
    self.articleTitleLabel.frame = CGRectMake(titleX, titleY, labelWidth, titleHeight);
    self.infoLabel.frame = CGRectMake(infoLabelX, infoLabelY, labelWidth, infoHeight);
}

@end
