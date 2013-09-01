//
//  HNArticleCell.h
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNArticleCell : UITableViewCell
{
    
    UILabel *articleTitleLabel;
    UIView *commentView;
    
    UITapGestureRecognizer *articleGR;
    UITapGestureRecognizer *commentGR;
    
}

- (void) articleTapped;
- (void) commentTapped;

@property (strong, nonatomic) UILabel *articleTitleLabel;
@property (strong, nonatomic) UIView *commentView;
@property (strong, nonatomic) UITapGestureRecognizer *articleGR;
@property (strong, nonatomic) UITapGestureRecognizer *commentGR;

@end
