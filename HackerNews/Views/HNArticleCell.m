//
//  HNArticleCell.m
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNArticleCell.h"

@implementation HNArticleCell

@synthesize delegate, articleView, articleTitleLabel, commentView, numCommentsLabel, commentBubbleIcon, infoLabel;

static const CGFloat CELL_TOP_MARGIN = 5;
static const CGFloat CELL_BOTTOM_MARGIN = 5;
static const CGFloat CELL_LEFT_MARGIN = 10;
static const CGFloat COMMENT_BUTTON_WIDTH = 50;
static const CGFloat ARTICLE_INFO_PADDING = 5;
static const CGFloat COMMENT_BUBBLE_SIZE = 15;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        articleView = [[HNTouchableView alloc] initWithFrame:CGRectZero];
        articleView.viewDelegate = self;
        
        articleTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [articleTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[articleTitleLabel setNumberOfLines:0];
        articleTitleLabel.backgroundColor = [UIColor clearColor];
        articleTitleLabel.userInteractionEnabled = TRUE;
        [articleView addSubview:articleTitleLabel];
        
        infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.textColor = [UIColor lightGrayColor];
        [articleView addSubview:infoLabel];
        
        commentView = [[HNTouchableView alloc] initWithFrame:CGRectZero];
        commentView.viewDelegate = self;
        
        commentBubbleIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat.png"]];
        commentBubbleIcon.contentMode = UIViewContentModeScaleAspectFit;
        [commentView addSubview:commentBubbleIcon];
        
        numCommentsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        numCommentsLabel.backgroundColor = [UIColor clearColor];
        [numCommentsLabel setTextAlignment:NSTextAlignmentCenter];
        [commentView addSubview:numCommentsLabel];
        
        [self addSubview:articleView];
        [self addSubview:commentView];

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
    
    return [text sizeWithFont:font constrainedToSize:labelConstraint lineBreakMode:NSLineBreakByWordWrapping].height;
}

+ (CGFloat) getInfoLabelHeight:(NSString *)text withFont:(UIFont *)font forWidth:(CGFloat)width
{
    return [text sizeWithFont:font forWidth:width lineBreakMode:NSLineBreakByCharWrapping].height;
}

+ (CGFloat) getLabelWidth:(CGFloat)frameWidth
{
    return frameWidth - COMMENT_BUTTON_WIDTH - CELL_LEFT_MARGIN;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    
    CGFloat labelWidth = [HNArticleCell getLabelWidth:self.frame.size.width];
    //Article view (contains article title and info view)
    [articleView setFrame:CGRectMake(0, 0, labelWidth + CELL_LEFT_MARGIN, self.frame.size.height)];
    
    //Article title label
    CGFloat articleLabelHeight = [HNArticleCell getArticleLabelHeight:self.articleTitleLabel.text withFont:self.articleTitleLabel.font forWidth:labelWidth];
    [articleTitleLabel setFrame:CGRectMake(CELL_LEFT_MARGIN, CELL_TOP_MARGIN, labelWidth, articleLabelHeight)];
    
    //Info label
    CGFloat infoLabelHeight = [HNArticleCell getInfoLabelHeight:self.infoLabel.text withFont:self.infoLabel.font forWidth:labelWidth];
    CGFloat infoLabelY = articleTitleLabel.frame.origin.y + articleLabelHeight + ARTICLE_INFO_PADDING;
    [infoLabel setFrame:CGRectMake(CELL_LEFT_MARGIN, infoLabelY, labelWidth, infoLabelHeight)];
    

    
    //Comment View
     [commentView setFrame:CGRectMake(CELL_LEFT_MARGIN + labelWidth, 0, COMMENT_BUTTON_WIDTH, self.frame.size.height)];
    
    CGSize maxNumCommentsSize = CGSizeMake(commentView.frame.size.width, CGFLOAT_MAX);
    CGSize numCommentsSize = [numCommentsLabel sizeThatFits:maxNumCommentsSize];
    [numCommentsLabel setFrame:CGRectMake(0, 0, commentView.frame.size.width, numCommentsSize.height)];
    
    CGFloat commentBubbleX = (commentView.frame.size.width / 2) - (COMMENT_BUBBLE_SIZE / 2);
    CGFloat commentBubbleY = numCommentsLabel.frame.origin.y + numCommentsLabel.frame.size.height;
    [commentBubbleIcon setFrame:CGRectMake(commentBubbleX, commentBubbleY, COMMENT_BUBBLE_SIZE, COMMENT_BUBBLE_SIZE)];

    
}

#pragma mark HNTouchableView delegate

-(void) viewDidTouchDown:(HNTouchableView *)viewTouched
{
    UIColor *highlightColor = [UIColor colorWithRed:1.0 green:0.647 blue:0 alpha:0.15];
    
    if (viewTouched == self.commentView)
    {
        commentView.backgroundColor = highlightColor;
    }
    else if (viewTouched == self.articleView)
    {
        articleView.backgroundColor = highlightColor;
    }
}

-(void) viewDidTouchUp:(HNTouchableView *)viewTouched
{
    UIColor *unhighlightColor = [UIColor clearColor];
    
    if (viewTouched == self.commentView)
    {
        [delegate didTapComment:self];
        commentView.backgroundColor = unhighlightColor;

    }
    else if (viewTouched == self.articleView)
    {
        [delegate didTapArticle:self];
        articleView.backgroundColor = unhighlightColor;
    }
    
}

-(void) viewDidCancelTouches:(HNTouchableView *)viewTouched
{
    UIColor *unhighlightColor = [UIColor clearColor];
    
    if (viewTouched == self.commentView) {
        commentView.backgroundColor = unhighlightColor;
    }
    else if (viewTouched == self.articleView)
    {
        articleView.backgroundColor = unhighlightColor;
    }
}


@end
