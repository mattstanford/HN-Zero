//
//  HNLoadingCell.m
//  HackerNews
//
//  Created by Matthew Stanford on 10/24/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNLoadingCell.h"

@implementation HNLoadingCell

static const CGFloat ACTIVITY_INDICATOR_WIDTH = 20;
static const CGFloat ACTIVITY_INDICATOR_HEIGHT = 20;
static const CGFloat TOP_MARGIN = 5;
static const CGFloat BOTTOM_MARGIN = 5;

@synthesize activityIndicator;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        
        activityIndicator = [[UIActivityIndicatorView alloc] init];
        [self.contentView addSubview:activityIndicator];
    }
    return self;
}

+ (CGFloat)getHeightForWidth:(CGFloat)width font:(UIFont *)font
{
    CGFloat stringHeight = [HNLoadingCell getLabelHeightForWidth:width font:font];
    
    return TOP_MARGIN + stringHeight + BOTTOM_MARGIN;
}

+ (CGFloat) getLabelHeightForWidth:(CGFloat)width font:(UIFont *)font
{
    CGSize labelConstraint = CGSizeMake(width, CGFLOAT_MAX);
    NSString *tempString = @"Test";
    
    return [tempString sizeWithFont:font constrainedToSize:labelConstraint lineBreakMode:NSLineBreakByWordWrapping].height;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    //Place activity indicator in center of view
    CGFloat activityIndicatorX = (self.frame.size.width / 2) - (ACTIVITY_INDICATOR_WIDTH / 2);
    CGFloat activityInidicatorY = (self.frame.size.height / 2) - (ACTIVITY_INDICATOR_HEIGHT / 2);
    self.activityIndicator.frame = CGRectMake(activityIndicatorX, activityInidicatorY, ACTIVITY_INDICATOR_WIDTH, ACTIVITY_INDICATOR_HEIGHT);
    
    //Label
    CGFloat labelWidth = self.frame.size.width;
    CGFloat labelHeight = [HNLoadingCell getLabelHeightForWidth:labelWidth font:self.textLabel.font];
    self.textLabel.frame = CGRectMake(0, 0, labelWidth, labelHeight);
    
}

@end
