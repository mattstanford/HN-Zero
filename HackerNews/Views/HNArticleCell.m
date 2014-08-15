//
//  HNArticleCell.m
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNArticleCell.h"

@implementation HNArticleCell

static const CGFloat CELL_TOP_MARGIN = 5;
static const CGFloat CELL_BOTTOM_MARGIN = 5;
static const CGFloat CELL_LEFT_MARGIN = 10;
static const CGFloat COMMENT_BUTTON_WIDTH = 50;
static const CGFloat ARTICLE_INFO_PADDING = 5;
static const CGFloat COMMENT_BUBBLE_SIZE = 15;
static const CGFloat ICON_WIDTH = 16;
static const CGFloat ICON_RIGHT_PADDING = 10;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.articleView = [[HNTouchableView alloc] initWithFrame:CGRectZero];
        self.articleView.viewDelegate = self;
        
        self.articleTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.articleTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[self.articleTitleLabel setNumberOfLines:0];
        self.articleTitleLabel.backgroundColor = [UIColor clearColor];
        self.articleTitleLabel.userInteractionEnabled = TRUE;
        [self.articleView addSubview:self.articleTitleLabel];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.infoLabel.backgroundColor = [UIColor clearColor];
        self.infoLabel.textColor = [UIColor lightGrayColor];
        [self.articleView addSubview:self.infoLabel];
        
        self.commentView = [[HNTouchableView alloc] initWithFrame:CGRectZero];
        self.commentView.viewDelegate = self;
        
        self.commentBubbleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat.png"]];
        self.commentBubbleIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self.commentView addSubview:self.commentBubbleIcon];
        
        self.numCommentsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.numCommentsLabel.backgroundColor = [UIColor clearColor];
        [self.numCommentsLabel setTextAlignment:NSTextAlignmentCenter];
        [self.commentView addSubview:self.numCommentsLabel];
        
        self.domainIconImageView = [[UIImageView alloc] init];
        [self addSubview:self.domainIconImageView];
        
        [self addSubview:self.articleView];
        [self addSubview:self.commentView];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

+ (CGFloat) getCellHeightForWidth:(CGFloat)cellWidth withArticleTitle:(NSString *)title withInfoText:(NSString *)infoText withTitleFont:(UIFont *)titleFont withInfoFont:(UIFont *)infoFont
{
    CGFloat articleWidth = [HNArticleCell getLabelWidth:cellWidth];
    
    CGFloat articleTextHeight = [HNArticleCell getArticleLabelHeight:title withFont:titleFont forWidth:articleWidth];
    CGFloat infoTextHeight = [HNArticleCell getInfoLabelHeight:infoText withFont:infoFont forWidth:articleWidth];
    
    return articleTextHeight + infoTextHeight + CELL_TOP_MARGIN + CELL_BOTTOM_MARGIN + ARTICLE_INFO_PADDING;
}

+ (CGFloat) getArticleLabelHeight:(NSString *)text withFont:(UIFont *)font forWidth:(CGFloat)width
{
    CGSize labelConstraint = CGSizeMake(width, CGFLOAT_MAX);
    CGFloat labelHeight = [text sizeWithFont:font constrainedToSize:labelConstraint lineBreakMode:NSLineBreakByWordWrapping].height;
    
    //Cell height cannot be a fraction
    return ceil(labelHeight);
}

+ (CGFloat) getInfoLabelHeight:(NSString *)text withFont:(UIFont *)font forWidth:(CGFloat)width
{
    CGFloat labelHeight = [text sizeWithFont:font forWidth:width lineBreakMode:NSLineBreakByCharWrapping].height;
    
    //Cell height cannot be a fraction
    return ceil(labelHeight);
}

+ (CGFloat) getLabelWidth:(CGFloat)frameWidth
{
    return frameWidth - COMMENT_BUTTON_WIDTH - CELL_LEFT_MARGIN - [HNArticleCell getWidthForIconView];
}

+ (CGFloat) getWidthForIconView
{
    return ICON_WIDTH + ICON_RIGHT_PADDING;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    
    //Icon image view
    [self.domainIconImageView setFrame:CGRectMake(CELL_LEFT_MARGIN, CELL_TOP_MARGIN, ICON_WIDTH, ICON_WIDTH)];
   
    CGFloat labelWidth = [HNArticleCell getLabelWidth:self.frame.size.width];
    //Article view (contains article title and info view)
    [self.articleView setFrame:CGRectMake([HNArticleCell getWidthForIconView], 0, labelWidth + CELL_LEFT_MARGIN, self.frame.size.height)];
    
    //Article title label
    CGFloat articleLabelHeight = [HNArticleCell getArticleLabelHeight:self.articleTitleLabel.text withFont:self.articleTitleLabel.font forWidth:labelWidth];
    [self.articleTitleLabel setFrame:CGRectMake(CELL_LEFT_MARGIN, CELL_TOP_MARGIN, labelWidth, articleLabelHeight)];
    
    //Info label
    CGFloat infoLabelHeight = [HNArticleCell getInfoLabelHeight:self.infoLabel.text withFont:self.infoLabel.font forWidth:labelWidth];
    CGFloat infoLabelY = self.articleTitleLabel.frame.origin.y + articleLabelHeight + ARTICLE_INFO_PADDING;
    [self.infoLabel setFrame:CGRectMake(CELL_LEFT_MARGIN, infoLabelY, labelWidth, infoLabelHeight)];
    

    
    //Comment View
     [self.commentView setFrame:CGRectMake(
                CELL_LEFT_MARGIN + [HNArticleCell getWidthForIconView] +labelWidth,
                0,
                COMMENT_BUTTON_WIDTH,
                self.frame.size.height)];
    
    CGSize maxNumCommentsSize = CGSizeMake(self.commentView.frame.size.width, CGFLOAT_MAX);
    CGSize numCommentsSize = [self.numCommentsLabel sizeThatFits:maxNumCommentsSize];
    [self.numCommentsLabel setFrame:CGRectMake(0, 0, self.commentView.frame.size.width, numCommentsSize.height)];
    
    CGFloat commentBubbleX = (self.commentView.frame.size.width / 2) - (COMMENT_BUBBLE_SIZE / 2);
    CGFloat commentBubbleY = self.numCommentsLabel.frame.origin.y + self.numCommentsLabel.frame.size.height;
    [self.commentBubbleIcon setFrame:CGRectMake(commentBubbleX, commentBubbleY, COMMENT_BUBBLE_SIZE, COMMENT_BUBBLE_SIZE)];
    
}

#pragma mark HNTouchableView delegate

-(void) viewDidTouchDown:(HNTouchableView *)viewTouched
{
    UIColor *highlightColor = [UIColor colorWithRed:1.0 green:0.647 blue:0 alpha:0.15];
    
    if (viewTouched == self.commentView)
    {
        self.commentView.backgroundColor = highlightColor;
    }
    else if (viewTouched == self.articleView)
    {
        self.articleView.backgroundColor = highlightColor;
    }
}

-(void) viewDidTouchUp:(HNTouchableView *)viewTouched
{
    UIColor *unhighlightColor = [UIColor clearColor];
    
    if (viewTouched == self.commentView)
    {
        [self.delegate didTapComment:self];
        self.commentView.backgroundColor = unhighlightColor;

    }
    else if (viewTouched == self.articleView)
    {
        [self.delegate didTapArticle:self];
        self.articleView.backgroundColor = unhighlightColor;
    }
    
}

-(void) viewDidCancelTouches:(HNTouchableView *)viewTouched
{
    UIColor *unhighlightColor = [UIColor clearColor];
    
    if (viewTouched == self.commentView) {
        self.commentView.backgroundColor = unhighlightColor;
    }
    else if (viewTouched == self.articleView)
    {
        self.articleView.backgroundColor = unhighlightColor;
    }
}


@end
