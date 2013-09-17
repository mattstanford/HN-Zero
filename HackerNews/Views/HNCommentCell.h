//
//  HNCommentCell.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/15/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNCommentCell : UITableViewCell
{
    NSNumber *nestedLevel;
    
}

@property (nonatomic, strong) NSNumber *nestedLevel;

+ (CGFloat) calculateHeightWithString:(NSString *)cellText withIndentLevel:(NSNumber *)indentLevel;
+ (UIFont *) getFont;
+ (UIFont *) getFontItalic;
+ (UIFont *) getFontBold;

@end
