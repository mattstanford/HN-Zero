//
//  HNArticleCell.m
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNArticleCell.h"

@implementation HNArticleCell

@synthesize delegate, articleTitleLabel, commentView, numCommentsLabel, infoLabel, articleGR, commentGR,commentButtonWidth, articleInfoPadding;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        articleTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [articleTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[articleTitleLabel setNumberOfLines:0];
        articleTitleLabel.backgroundColor = [UIColor clearColor];
        articleTitleLabel.userInteractionEnabled = TRUE;
        
        infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        infoLabel.backgroundColor = [UIColor clearColor];
        infoLabel.textColor = [UIColor lightGrayColor];
        
        commentView = [[UIView alloc] initWithFrame:CGRectZero];
        
        numCommentsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        numCommentsLabel.backgroundColor = [UIColor clearColor];
        [numCommentsLabel setTextAlignment:UITextAlignmentCenter];
        [commentView addSubview:numCommentsLabel];
        
        articleGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
        articleGR.delegate = self;
        [articleTitleLabel addGestureRecognizer:articleGR];
        
        commentGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapped:)];
        commentGR.delegate = self;
        [commentView addGestureRecognizer:commentGR];
        
        
        [self addSubview:articleTitleLabel];
        [self addSubview:infoLabel];
        [self addSubview:commentView];

    }
    return self;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    ///Need to catch the GR before it "receives" the touch so that the touch is received by the table view
    if (gestureRecognizer == self.articleGR)
    {
        [self articleTapped:gestureRecognizer];
        return NO;
    }

    return YES;
}

- (void) articleTapped:(UITapGestureRecognizer *)recognizer
{
    [delegate didTapArticle:self];
}

- (void) commentTapped:(UITapGestureRecognizer *)recognizer
{
    [delegate didTapComment:self];
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
    
    
    //CGFloat labelHeight = self.frame.size.height - self.topMargin - self.bottomMargin;
    
    //Article title label
    CGFloat articleLabelHeight = [HNArticleCell getArticleLabelHeight:self.articleTitleLabel.text withFont:self.articleTitleLabel.font forWidth:labelWidth];
    [articleTitleLabel setFrame:CGRectMake(self.leftMargin, self.topMargin, labelWidth, articleLabelHeight)];
    
    //Info label
    CGFloat infoLabelHeight = [HNArticleCell getInfoLabelHeight:self.infoLabel.text withFont:self.infoLabel.font forWidth:labelWidth];
    CGFloat infoLabelY = articleTitleLabel.frame.origin.y + articleLabelHeight + self.articleInfoPadding;
    [infoLabel setFrame:CGRectMake(self.leftMargin, infoLabelY, labelWidth, infoLabelHeight)];
    
    //Comment View
    CGFloat commentViewHeight = articleLabelHeight + infoLabelHeight + self.topMargin + self.bottomMargin;
        [commentView setFrame:CGRectMake(labelWidth, self.topMargin, self.commentButtonWidth, commentViewHeight)];

    //Num comments view
    [numCommentsLabel setFrame:CGRectMake(0, 0, commentView.frame.size.width, commentView.frame.size.height)];
    
}


@end
