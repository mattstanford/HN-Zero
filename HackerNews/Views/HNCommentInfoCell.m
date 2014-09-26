//
//  HNCommentInfoCell.m
//  HackerNews
//
//  Created by Matthew Stanford on 10/10/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNCommentInfoCell.h"

@interface HNCommentInfoCell ()

@end

@implementation HNCommentInfoCell

static const int LEFT_MARGIN = 10;
static const int RIGHT_MARGIN = 10;
static const int TOP_MARGIN = 20;
static const int BOTTOM_MARGIN = 20;

static const int TITLE_INFO_PADDING = 10;
static const int INFO_POST_PADDING = 10;
static const int SEPARATOR_HEIGHT = 3;

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.articleTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.articleTitleLabel.text = @"Title";
        [self.articleTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[self.articleTitleLabel setNumberOfLines:0];
        self.articleTitleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.articleTitleLabel];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.infoLabel.text = @"info";
        [self.contentView addSubview:self.infoLabel];
        
        self.postLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [self.postLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[self.postLabel setNumberOfLines:0];
        self.postLabel.backgroundColor = [UIColor clearColor];
        self.postLabel.userInteractionEnabled = TRUE;
        [self.contentView addSubview:self.postLabel];
        
        self.separatorView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.separatorView];
    }
    
    return self;
}

+(CGFloat) getCellHeightForText:(NSString *)titleText postText:(NSAttributedString *)postText forWidth:(CGFloat)cellWidth titleFont:(UIFont *)titleFont infoText:(NSString *)infoText infoFont:(UIFont *)infoFont postFont:(UIFont *)postFont
{
    CGFloat width = [HNCommentInfoCell getLabelWidth:cellWidth];
    CGFloat titleHeight = [HNCommentInfoCell getHeightForText:titleText forWidth:width titleFont:titleFont];
    
    //If there is not "post" text, we don't want the extra label to take up space, along with the extra
    //padding
    CGFloat postHeight_plus_padding = 0;
    if (postText)
    {
        postHeight_plus_padding = [HNCommentInfoCell getHeightForAttributedString:postText forWidth:width font:postFont];
        postHeight_plus_padding += INFO_POST_PADDING;
    }

    //Sample string for info label.  The info label will always be one line
    //Unless the line is zero length, then we will hide the space
    CGFloat infoHeight = 0;
    if(infoText != nil && infoText.length > 0)
    {
        NSString *tempString = @"test string";
        infoHeight = [HNCommentInfoCell getInfoHeightForText:tempString forWidth:width infoFont:infoFont];
    }
    
    CGFloat height = TOP_MARGIN + titleHeight + TITLE_INFO_PADDING + infoHeight + postHeight_plus_padding + BOTTOM_MARGIN;
    
    //Cell height cannot be a fraction
    return ceil(height);
}

+(CGFloat) getHeightForAttributedString:(NSAttributedString *)text forWidth:(CGFloat)labelWidth font:(UIFont *)font
{
    //Create temporary label to get accurate label height
    TTTAttributedLabel *tempLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    tempLabel.attributedText = text;
    [tempLabel setNumberOfLines:0];
    CGSize constraint = CGSizeMake(labelWidth, CGFLOAT_MAX);
    
    //Cell height cannot be a fraction
    CGFloat labelHeight = ceil([tempLabel sizeThatFits:constraint].height);

    return labelHeight;
}

+(CGFloat) getHeightForText:(NSString *)titleText forWidth:(CGFloat)width titleFont:(UIFont *)font
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
    CGFloat titleHeight = [HNCommentInfoCell getHeightForText:self.articleTitleLabel.text forWidth:labelWidth titleFont:self.articleTitleLabel.font];
    
    CGFloat infoLabelX = LEFT_MARGIN;
    CGFloat infoLabelY = TOP_MARGIN + titleHeight + TITLE_INFO_PADDING;
    CGFloat infoHeight = 0;
    if(self.infoLabel.text.length > 0)
    {
        infoHeight = [HNCommentInfoCell getInfoHeightForText:self.infoLabel.text forWidth:labelWidth infoFont:self.infoLabel.font];
    }
    
    CGFloat postLabelX = LEFT_MARGIN;
    CGFloat postLabelY = TOP_MARGIN + titleHeight + TITLE_INFO_PADDING + infoHeight + INFO_POST_PADDING;
    CGFloat postHeight = 0;
    
    if (self.postLabel.attributedText != nil)
    {
        postHeight = [HNCommentInfoCell getHeightForAttributedString:self.postLabel.attributedText forWidth:labelWidth font:self.postLabel.font];
    }
    
    CGFloat separatorY = self.frame.size.height - SEPARATOR_HEIGHT;
    
    self.articleTitleLabel.frame = CGRectMake(titleX, titleY, labelWidth, titleHeight);
    self.infoLabel.frame = CGRectMake(infoLabelX, infoLabelY, labelWidth, infoHeight);
    self.postLabel.frame = CGRectMake(postLabelX, postLabelY, labelWidth, postHeight);
    self.separatorView.frame = CGRectMake(0, separatorY, self.frame.size.width, SEPARATOR_HEIGHT);
    
}

@end
