//
//  HNArticleCell.h
//  HackerNews
//
//  Created by Matthew Stanford on 8/31/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNTouchableView.h"

@class HNArticleCell;

@protocol HNArticleCellDelegate
@required
-(void) didTapArticle:(HNArticleCell *)cellTapped;
-(void) didTapComment:(HNArticleCell *)cellTapped;
@end

@interface HNArticleCell : UITableViewCell <HNTouchableViewDelegate>

+ (CGFloat) getArticleLabelHeight:(NSString *)text withFont:(UIFont *)font forWidth:(CGFloat)width;
+ (CGFloat) getInfoLabelHeight:(NSString *)text withFont:(UIFont *)font forWidth:(CGFloat)width;
+ (CGFloat) getCellHeightForWidth:(CGFloat)cellWidth withArticleTitle:(NSString *)title withInfoText:(NSString *)infoText withTitleFont:(UIFont *)cellFont withInfoFont:(UIFont *)infoFont;

@property (nonatomic, assign) id<HNArticleCellDelegate> delegate;
@property (strong, nonatomic) HNTouchableView *articleView;
@property (strong, nonatomic) UILabel *articleTitleLabel;
@property (strong, nonatomic) HNTouchableView *commentView;
@property (strong, nonatomic) UIImageView *commentBubbleIcon;
@property (strong, nonatomic) UILabel *numCommentsLabel;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UIImageView *domainIconImageView;


@end
