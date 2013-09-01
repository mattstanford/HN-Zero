//
//  HNArticleCell.m
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNArticleCell.h"

@implementation HNArticleCell

@synthesize articleTitleLabel, commentView, articleGR, commentGR;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        articleTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [articleTitleLabel setLineBreakMode:NSLineBreakByWordWrapping];
		[articleTitleLabel setNumberOfLines:0];
        
        commentView = [[UIView alloc] initWithFrame:CGRectZero];
        
        articleGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(articleTapped)];
        [articleTitleLabel addGestureRecognizer:articleGR];
        
        commentGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTapped)];
        [commentView addGestureRecognizer:commentGR];
        
        [self addSubview:articleTitleLabel];
        [self addSubview:commentView];
        
    }
    return self;
}

- (void) articleTapped
{
    NSLog(@"Article tapped!");
}

- (void) commentTapped
{
    NSLog(@"Comment tapped!");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

-(void)layoutSubviews {
	[super layoutSubviews];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    CGFloat commentViewWidth = 100;
    CGFloat articleViewWidth = screenBounds.size.width - commentViewWidth;
    CGFloat cellHeight = 40;
    
    [articleTitleLabel setFrame:CGRectMake(0, 0, articleViewWidth, cellHeight)];
    [commentView setFrame:CGRectMake(articleViewWidth, 0, commentViewWidth, cellHeight)];
    
}

@end
