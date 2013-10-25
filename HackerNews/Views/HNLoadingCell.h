//
//  HNLoadingCell.h
//  HackerNews
//
//  Created by Matthew Stanford on 10/24/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNLoadingCell : UITableViewCell
{
    UIActivityIndicatorView *activityIndicator;
}

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

+ (CGFloat)getHeightForWidth:(CGFloat)width font:(UIFont *)font;

@end
