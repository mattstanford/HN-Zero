//
//  HNArticleCell.m
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNArticleCell.h"

@implementation HNArticleCell

@synthesize delegate, articleView, articleTitleLabel, commentView, numCommentsLabel, infoLabel,commentButtonWidth, articleInfoPadding;


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

+ (CGFloat) getArticleLabelHeight:(NSString *)text withFont:(UIFont *)font forWidth:(CGFloat)width
{
    CGSize labelConstraint = CGSizeMake(width, CGFLOAT_MAX);
    
    return [text sizeWithFont:font constrainedToSize:labelConstraint lineBreakMode:NSLineBreakByWordWrapping].height;
}

+ (CGFloat) getInfoLabelHeight:(NSString *)text withFont:(UIFont *)font forWidth:(CGFloat)width
{
    return [text sizeWithFont:font forWidth:width lineBreakMode:NSLineBreakByCharWrapping].height;
}

- (void)layoutSubviews {
	[super layoutSubviews];
    
    CGFloat labelWidth = self.frame.size.width - self.commentButtonWidth - self.leftMargin;
    
    //Article view (contains article title and info view)
    [articleView setFrame:CGRectMake(0, 0, labelWidth, self.frame.size.height)];
    
    //Article title label
    CGFloat articleLabelHeight = [HNArticleCell getArticleLabelHeight:self.articleTitleLabel.text withFont:self.articleTitleLabel.font forWidth:labelWidth];
    [articleTitleLabel setFrame:CGRectMake(self.leftMargin, self.topMargin, labelWidth, articleLabelHeight)];
    
    //Info label
    CGFloat infoLabelHeight = [HNArticleCell getInfoLabelHeight:self.infoLabel.text withFont:self.infoLabel.font forWidth:labelWidth];
    CGFloat infoLabelY = articleTitleLabel.frame.origin.y + articleLabelHeight + self.articleInfoPadding;
    [infoLabel setFrame:CGRectMake(self.leftMargin, infoLabelY, labelWidth, infoLabelHeight)];
    

    
    //Comment View
    [commentView setFrame:CGRectMake(labelWidth, 0, self.commentButtonWidth, self.frame.size.height)];

    //Num comments view
    [numCommentsLabel setFrame:CGRectMake(0, 0, commentView.frame.size.width, commentView.frame.size.height)];
    
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
