//
//  HNComment.m
//  HackerNews
//
//  Created by Matthew Stanford on 9/5/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNComment.h"
#import "HNCommentBlock.h"
#import "HNCommentCell.h"
#import "HNTheme.h"

@implementation HNComment

@synthesize commentBlock, author, dateWritten, nestedLevel;

- (NSString *) getOverflowIndentString
{
    NSMutableString *overflowString = [[NSMutableString alloc] initWithCapacity:0];
    int overflowLevels = [HNCommentCell getOverflowIndentLevels:self.nestedLevel];
    
    for (int i=0; i < overflowLevels; i++)
    {
        [overflowString appendString:@"• "];
    }
    
    return overflowString;
    
}

- (NSAttributedString *) getCommentHeaderWithTheme:(HNTheme *)theme
{
    NSMutableAttributedString *headerString = nil;
    
    NSString *user = self.author;
    NSString *timeString = self.dateWritten;
    
    NSString *indentOverflowString = [self getOverflowIndentString];
    NSString *baseString = [NSString stringWithFormat:@"%@%@ • %@", indentOverflowString, user, timeString];
    
    NSRange userStringRange = NSMakeRange(indentOverflowString.length +1, user.length);
    NSRange timeStringRange = NSMakeRange(baseString.length - timeString.length - 2, timeString.length + 2);
    
    headerString = [[NSMutableAttributedString alloc] initWithString:baseString];
    [headerString addAttribute:NSFontAttributeName value:theme.commentBoldFont range:userStringRange];
    [headerString addAttribute:NSFontAttributeName value:theme.commentNormalFont range:timeStringRange];
    [headerString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:timeStringRange];
    
    return headerString;
}

- (NSAttributedString *) convertToAttributedString:(HNCommentBlock *)block withTheme:(HNTheme *)theme
{
    NSMutableAttributedString *blockString = [[NSMutableAttributedString alloc] init];
    int styleStringStart = 0;
    NSString *styleType = nil;
    
    //This is a recursive funciton.  This is our base case.
    if ([block.tagName isEqualToString:@"text"] && block.text) {
        return [[NSAttributedString alloc] initWithString:block.text];
    }
    
    //We need to add some whitespace when we have a "p" element
    if ([block.tagName isEqualToString:@"p"])
    {
        [blockString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    }
    
    //We are setting the child elements to have a specific style according to the parent tag here
    if ([block.tagName isEqualToString:@"a"] || [block.tagName isEqualToString:@"i"] || [block.tagName isEqualToString:@"b"] || [block.tagName isEqualToString:@"code"])
    {
        styleStringStart = [blockString length];
        styleType = block.tagName;
    }
    
    //Recurse this function until we get to the base case (tag="text")
    for (HNCommentBlock *child in block.childBlocks)
    {
        [blockString appendAttributedString:[self convertToAttributedString:child withTheme:theme]];
        
    }
    
    //Set any styles on the string
    if (styleType) {
        [self setStringStyle:blockString withStyle:styleType startPos:styleStringStart withTheme:theme];
    }
    
    return blockString;
}

- (void) setStringStyle:(NSMutableAttributedString *)blockString withStyle:(NSString *)styleType startPos:(int)startPos withTheme:(HNTheme *)theme
{
    
    if (styleType)
    {
        int styleStringLen = [blockString length] - startPos;
        NSRange styleRange = NSMakeRange(startPos, styleStringLen);
        
        if ([styleType isEqualToString:@"a"])
        {
            //Add blue color to link
            [blockString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:styleRange];
            //Underline too
            [blockString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:styleRange];
        }
        else if([styleType isEqualToString:@"i"])
        {
            [blockString addAttribute:NSFontAttributeName value:theme.commentItalicFont range:styleRange];
        }
        else if([styleType isEqualToString:@"b"])
        {
            [blockString addAttribute:NSFontAttributeName value:theme.commentBoldFont range:styleRange];
        }
        else if([styleType isEqualToString:@"code"])
        {
            [blockString addAttribute:NSFontAttributeName value:theme.commentCodeFont range:styleRange];
        }
    }
    
}


@end
