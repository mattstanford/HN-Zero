//
//  HNArticleCell.h
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNTableViewCell.h"

@class HNArticleCell;

@protocol HNArticleCellDelegate
@required
-(void) didTapArticle:(HNArticleCell *)cellTapped;
-(void) didTapComment:(HNArticleCell *)cellTapped;
@end

@interface HNArticleCell : HNTableViewCell <UIGestureRecognizerDelegate>
{
    
    UILabel *articleTitleLabel;
    UIView *commentView;
    UILabel *numCommentsLabel;
    UILabel *infoLabel;
    
    UITapGestureRecognizer *articleGR;
    UITapGestureRecognizer *commentGR;
    
    int commentButtonWidth;
    CGFloat articleInfoPadding;
    
}

- (void) articleTapped:(UIGestureRecognizer *)recognizer;
- (void) commentTapped:(UIGestureRecognizer *)recognizer;
+ (CGFloat) getArticleLabelHeight:(NSString *)text withFont:(UIFont *)font forWidth:(CGFloat)width;
+ (CGFloat) getInfoLabelHeight:(NSString *)text withFont:(UIFont *)font forWidth:(CGFloat)width;

@property (nonatomic, assign) id<HNArticleCellDelegate> delegate;
@property (strong, nonatomic) UILabel *articleTitleLabel;
@property (strong, nonatomic) UIView *commentView;
@property (strong, nonatomic) UILabel *numCommentsLabel;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UITapGestureRecognizer *articleGR;
@property (strong, nonatomic) UITapGestureRecognizer *commentGR;

@property (assign, nonatomic) int commentButtonWidth;
@property (assign, nonatomic) CGFloat articleInfoPadding;

@end
