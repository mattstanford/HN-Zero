//
//  HNArticleCell.m
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNArticleCell.h"

@implementation HNArticleCell

@synthesize delegate, articleTitleLabel, commentView, numCommentsLabel, articleGR, commentGR, topMargin, bottomMargin, leftMargin, commentButtonWidth;


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
        [self addSubview:commentView];
        
        //These values should be set by the view controller
        self.topMargin = 0;
        self.bottomMargin = 0;
        self.leftMargin = 0;
        self.commentButtonWidth = 0;
        
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

- (void)layoutSubviews {
	[super layoutSubviews];
    
    CGFloat commentViewWidth = self.commentButtonWidth;
    CGFloat articleLabelWidth = self.frame.size.width - commentViewWidth - self.leftMargin;
    CGFloat labelHeight = self.frame.size.height - self.topMargin - self.bottomMargin;
    
    [articleTitleLabel setFrame:CGRectMake(self.leftMargin, self.topMargin, articleLabelWidth, labelHeight)];
    [commentView setFrame:CGRectMake(articleLabelWidth, self.topMargin, commentViewWidth, labelHeight)];
    
    NSLog(@"layoutSubview: %@", numCommentsLabel.text);
    [numCommentsLabel setFrame:CGRectMake(0, 0, commentView.frame.size.width, commentView.frame.size.height)];
    
}


@end
