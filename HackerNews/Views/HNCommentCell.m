//
//  HNCommentCell.m
//  HackerNews
//
//  Created by Matthew Stanford on 9/15/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNCommentCell.h"

@implementation HNCommentCell

@synthesize nestedLevel, nameLabel, nameLabelHeight, indentPerLevel;


-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
        
        self.nestedLevel = [[NSNumber alloc] initWithInt:0];
        
        [self.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.textLabel setNumberOfLines:0];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];

    }
    
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat indentAmount = [self getIndentWidth:self.nestedLevel] + self.leftMargin;
    
    
    CGFloat nameLabelX = indentAmount;
    CGFloat nameLabelY = self.topMargin;
    CGFloat nameLabelWidth = [self getLabelWidth:self.nestedLevel];
    
    CGFloat labelX = indentAmount;
    CGFloat labelY = nameLabelY + self.nameLabelHeight;
    CGFloat labelWidth = [self getLabelWidth:self.nestedLevel];
    CGFloat labelHeight = self.frame.size.height - labelY - self.bottomMargin;
    
    self.nameLabel.frame = CGRectMake(nameLabelX, nameLabelY, nameLabelWidth, self.nameLabelHeight);
    self.textLabel.frame = CGRectMake(labelX, labelY, labelWidth, labelHeight);

}

- (CGFloat) getIndentWidth:(NSNumber *)level
{
    return self.indentPerLevel * [level floatValue];
}

- (CGFloat) getLabelWidth:(NSNumber *)indentLevel
{
    return self.frame.size.width - [self getIndentWidth:indentLevel] - self.leftMargin - self.rightMargin;
}


@end
