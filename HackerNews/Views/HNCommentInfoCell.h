//
//  HNCommentInfoCell.h
//  HackerNews
//
//  Created by Matthew Stanford on 10/10/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNCommentInfoCell : UITableViewCell
{
    UILabel *articleTitleLabel;
    UILabel *infoLabel;
}

@property (nonatomic, strong) UILabel *articleTitleLabel;
@property (nonatomic, strong) UILabel *infoLabel;

+(CGFloat) getCellHeightForText:(NSString *)titleText forWidth:(CGFloat)cellWidth titleFont:(UIFont *)titleFont infoFont:(UIFont *)infoFont;

@end
