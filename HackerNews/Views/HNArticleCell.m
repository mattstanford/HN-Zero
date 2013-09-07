//
//  HNArticleCell.m
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNArticleCell.h"

@implementation HNArticleCell

@synthesize delegate, articleTitleLabel, commentView, articleGR, commentGR;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        articleTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [articleTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[articleTitleLabel setNumberOfLines:0];
        articleTitleLabel.userInteractionEnabled = TRUE;
        
        commentView = [[UIView alloc] initWithFrame:CGRectZero];
        
        articleGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
        articleGR.delegate = self;
        [articleTitleLabel addGestureRecognizer:articleGR];
        
        commentGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapped:)];
        commentGR.delegate = self;
        [commentView addGestureRecognizer:commentGR];
        
        
        [self addSubview:articleTitleLabel];
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
    [delegate didTapArticle];
}

- (void) commentTapped:(UITapGestureRecognizer *)recognizer
{
    [delegate didTapComment];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)layoutSubviews {
	[super layoutSubviews];
    
    CGRect screenBounds = [self getScreenBoundsForOrientation];
    
    CGFloat commentViewWidth = 100;
    CGFloat articleViewWidth = screenBounds.size.width - commentViewWidth;
    CGFloat cellHeight = 40;
    
    [articleTitleLabel setFrame:CGRectMake(0, 0, articleViewWidth, cellHeight)];
    [commentView setFrame:CGRectMake(articleViewWidth, 0, commentViewWidth, cellHeight)];
    
}

- (CGRect)getScreenBoundsForOrientation
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat width = 0;
    CGFloat height = 0;
    CGRect realScreenBounds = [[UIScreen mainScreen] bounds];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)
    {
        width = realScreenBounds.size.height;
        height = realScreenBounds.size.width;
    }
    else
    {
        width = realScreenBounds.size.width;
        height = realScreenBounds.size.height;
    }
    
    return CGRectMake(0, 0, width, height);
    
}

@end
