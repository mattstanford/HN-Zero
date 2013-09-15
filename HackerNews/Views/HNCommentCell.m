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

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        
        self.nestedLevel = [[NSNumber alloc] initWithInt:0];
        
        self.textLabel.font = [UIFont systemFontOfSize:12];
        [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.textLabel setNumberOfLines:0];

    }
    
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat indentUnit = 20;
    CGFloat margin = 10;
    CGFloat indentAmount = margin + ([self.nestedLevel floatValue] * indentUnit);
    
    CGFloat cellWidth = self.frame.size.width - indentAmount;
    CGFloat cellHeight = self.frame.size.height;
    
    self.textLabel.frame = CGRectMake(indentAmount, 0, cellWidth, cellHeight);
    
}

@end
