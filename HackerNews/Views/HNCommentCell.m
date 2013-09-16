//
//  HNCommentCell.m
//  HackerNews
//
//  Created by Matthew Stanford on 9/15/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNCommentCell.h"

@implementation HNCommentCell

@synthesize nestedLevel;

static const int FONT_SIZE = 12;
static const CGFloat LEFT_MARGIN = 10;
static const CGFloat RIGHT_MARGIN = 30;
static const CGFloat TOP_MARGIN = 10;
static const CGFloat BOTTOM_MARGIN = 10;

static const int INDENT_PER_LEVEL = 20;

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        
        self.nestedLevel = [[NSNumber alloc] initWithInt:0];
        
        self.textLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.textLabel setNumberOfLines:0];

    }
    
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat nestMargin = 10;

    CGFloat indentAmount = nestMargin + [HNCommentCell getIndentWidth:[self nestedLevel]];
    
    CGFloat labelX = indentAmount + LEFT_MARGIN;
    CGFloat labelY = TOP_MARGIN;
    CGFloat labelWidth = self.frame.size.width - labelX - RIGHT_MARGIN;
    CGFloat labelHeight = self.frame.size.height - labelY - BOTTOM_MARGIN;
    
    self.textLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);
    
}

+ (CGFloat) getIndentWidth:(NSNumber *)level
{
    return INDENT_PER_LEVEL * [level floatValue];
}

+ (CGFloat) calculateHeightWithString:(NSString *)cellText withIndentLevel:(NSNumber *)indentLevel
{
    CGRect screenBounds = [self getScreenBoundsForOrientation];
    CGFloat labelWidth = screenBounds.size.width - [self getIndentWidth:indentLevel] - LEFT_MARGIN - RIGHT_MARGIN;
    CGSize constraint = CGSizeMake(labelWidth, 10000);

    CGSize commentSize = [cellText sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    /*CGSize commentSize = [cellText sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] forWidth:labelWidth lineBreakMode:NSLineBreakByWordWrapping];*/

    return commentSize.height + BOTTOM_MARGIN + TOP_MARGIN;
    
}

+ (CGRect)getScreenBoundsForOrientation
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
