//
//  HNCommentInfoCell.h
//  HackerNews
//
//  Created by Matthew Stanford on 10/10/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNCommentInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *articleTitleLabel;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *postLabel;
@property (nonatomic, strong) UIView *separatorView;

+(CGFloat) getCellHeightForText:(NSString *)titleText postText:(NSString *)postText forWidth:(CGFloat)cellWidth titleFont:(UIFont *)titleFont infoText:(NSString *)infoText infoFont:(UIFont *)infoFont postFont:(UIFont *)postFont;

@end
