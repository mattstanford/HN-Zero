//
//  HNArticleCell.h
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNArticleCell;

@protocol HNArticleCellDelegate
@required
-(void) didTapArticle:(HNArticleCell *)cellTapped;
-(void) didTapComment:(HNArticleCell *)cellTapped;
@end

@interface HNArticleCell : UITableViewCell <UIGestureRecognizerDelegate>
{
    
    UILabel *articleTitleLabel;
    UIView *commentView;
    
    UITapGestureRecognizer *articleGR;
    UITapGestureRecognizer *commentGR;
    
}

- (void) articleTapped:(UIGestureRecognizer *)recognizer;
- (void) commentTapped:(UIGestureRecognizer *)recognizer;

@property (nonatomic, assign) id<HNArticleCellDelegate> delegate;
@property (strong, nonatomic) UILabel *articleTitleLabel;
@property (strong, nonatomic) UIView *commentView;
@property (strong, nonatomic) UITapGestureRecognizer *articleGR;
@property (strong, nonatomic) UITapGestureRecognizer *commentGR;

@end
