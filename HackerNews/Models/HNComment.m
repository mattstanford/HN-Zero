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
#import "HNAttributedStyle.h"
#import "HNCommentString.h"

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
    
    NSRange userStringRange = NSMakeRange(indentOverflowString.length, user.length);
    NSRange timeStringRange = NSMakeRange(baseString.length - timeString.length - 2 , timeString.length + 2);
    
    headerString = [[NSMutableAttributedString alloc] initWithString:baseString];
    [headerString addAttribute:NSFontAttributeName value:theme.commentBoldFont range:userStringRange];
    [headerString addAttribute:NSFontAttributeName value:theme.commentNormalFont range:timeStringRange];
    [headerString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:timeStringRange];
    
    return headerString;
}

- (NSAttributedString *) convertToAttributedStringWithTheme:(HNTheme *)theme
{
    
    HNCommentString *commentString = [self convertToCommentString:self.commentBlock];
    
    return [commentString getAttributedStringWithTheme:theme];
}

- (HNCommentString *) convertToCommentString
{
    return [self convertToCommentString:self.commentBlock];
}

- (HNCommentString *) convertToCommentString:(HNCommentBlock *)block
{
    HNCommentString *commentString = [[HNCommentString alloc] init];
    int styleStringStart = 0;
    NSString *styleType = nil;
    
    //This is a recursive funciton.  This is our base case.
    if ([block.tagName isEqualToString:@"text"] && block.text) {
        return [[HNCommentString alloc] initWithString:block.text styles:nil];
    }
    
    //We need to add some whitespace when we have a "p" element
    if ([block.tagName isEqualToString:@"p"])
    {
        //[blockString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
        [commentString.text appendString:@"\n\n"];
    }
    
    //We are setting the child elements to have a specific style according to the parent tag here
    if ([block.tagName isEqualToString:@"a"] || [block.tagName isEqualToString:@"i"] || [block.tagName isEqualToString:@"b"] || [block.tagName isEqualToString:@"code"])
    {
        //styleStringStart = [blockString length];
        styleStringStart = commentString.text.length;
        
        styleType = block.tagName;
    }

    
    //Recurse this function until we get to the base case (tag="text")
    for (HNCommentBlock *child in block.childBlocks)
    {
        [commentString appendCommentString:[self convertToCommentString:child]];
    }
    
    //Set any styles on the string
    if (styleType) {
        int styleStringLen = commentString.text.length - styleStringStart;
        NSMutableArray *styles = [self getStylesForType:styleType startPos:styleStringStart length:styleStringLen attributes:block.attributes];
        
        [commentString.styles addObjectsFromArray:styles];
    }
    
    return commentString;
}

- (NSMutableArray *) getStylesForType:(NSString *)styleType startPos:(int)startPos length:(int)styleStringLen attributes:(NSDictionary *)attributes
{
    NSMutableArray *stringStyles = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (styleType)
    {
        NSRange styleRange = NSMakeRange(startPos, styleStringLen);
        
        if ([styleType isEqualToString:@"a"])
        {
            HNAttributedStyle *linkStyle = [[HNAttributedStyle alloc] initWithStyleType:HNSTYLE_LINK range:styleRange attributes:attributes];
            [stringStyles addObject:linkStyle];
        }
        else if([styleType isEqualToString:@"i"])
        {
            HNAttributedStyle *italicStyle = [[HNAttributedStyle alloc] initWithStyleType:HNSTYLE_ITALIC range:styleRange];
            [stringStyles addObject:italicStyle];
        }
        else if([styleType isEqualToString:@"b"])
        {
            HNAttributedStyle *boldStyle = [[HNAttributedStyle alloc] initWithStyleType:HNSTYLE_BOLD range:styleRange];
            [stringStyles addObject:boldStyle];
        }
        else if([styleType isEqualToString:@"code"])
        {
            HNAttributedStyle *codeStyle = [[HNAttributedStyle alloc] initWithStyleType:HNSTYLE_CODE range:styleRange];
            [stringStyles addObject:codeStyle];

        }
    }
    
    return stringStyles;

}


@end
