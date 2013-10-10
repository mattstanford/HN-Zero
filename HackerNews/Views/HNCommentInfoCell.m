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
    CGFloat titleHeight = [HNCommentInfoCell getTitleHeightForText:titleText forWidth:cellWidth titleFont:titleFont];

    //Sample string for info label.  The info label will always be one line
    NSString *tempString = @"test string";
    CGFloat infoHeight = [HNCommentInfoCell getInfoHeightForText:tempString forWidth:cellWidth infoFont:infoFont];
    
    return titleHeight + TITLE_INFO_PADDING + infoHeight;
}

+(CGFloat) getTitleHeightForText:(NSString *)titleText forWidth:(CGFloat)cellWidth titleFont:(UIFont *)font
{
    CGSize labelConstraint = CGSizeMake(cellWidth, CGFLOAT_MAX);
    
    return [titleText sizeWithFont:font constrainedToSize:labelConstraint lineBreakMode:NSLineBreakByWordWrapping].height;
}

+(CGFloat) getInfoHeightForText:(NSString *)infoText forWidth:(CGFloat)cellWidth infoFont:(UIFont *)font
{
    return [infoText sizeWithFont:font forWidth:cellWidth lineBreakMode:NSLineBreakByClipping].height;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat labelWidth = self.frame.size.width;
    
    CGFloat titleX = 0;
    CGFloat titleY = 0;
    CGFloat titleHeight = [HNCommentInfoCell getTitleHeightForText:self.articleTitleLabel.text forWidth:labelWidth titleFont:self.articleTitleLabel.font];
    
    CGFloat infoLabelX = 0;
    CGFloat infoLabelY = titleHeight + TITLE_INFO_PADDING;
    CGFloat infoHeight = [HNCommentInfoCell getInfoHeightForText:self.infoLabel.text forWidth:self.frame.size.width infoFont:self.infoLabel.font];
    
    self.articleTitleLabel.frame = CGRectMake(titleX, titleY, labelWidth, titleHeight);
    self.infoLabel.frame = CGRectMake(infoLabelX, infoLabelY, labelWidth, infoHeight);
}

@end
