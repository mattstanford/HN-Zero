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
#import "HNCommentParser.h"
#import "TFHpple.h"

@implementation HNComment

-(void)setFirebaseData:(NSDictionary *)data nestedLevel:(NSNumber *)nestedLevel
{
    _objectId = [data objectForKey:@"id"];
    _author = [data objectForKey:@"by"];
    
    NSNumber *dateWrittenValue = (NSNumber *)[data objectForKey:@"time"];
    _dateWritten = [[NSString alloc] initWithFormat:@"%li", [dateWrittenValue integerValue]];
    
    _nestedLevel = nestedLevel;

    _commentBlock = [self getCommentBlockFromStringData:[data objectForKey:@"text"]];
}

-(HNCommentBlock *)getCommentBlockFromStringData:(NSString *)stringData
{
    NSData *commentData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple *commentParser = [TFHpple hppleWithHTMLData:commentData];
    HNCommentBlock *commentBlock = nil;
    
    NSArray *commentElements = [commentParser searchWithXPathQuery:@"//*"];
    
    for (TFHppleElement *element in commentElements)
    {
        if ([[element tagName] isEqualToString:@"body"])
        {
            commentBlock = [HNCommentParser getCommentBlockFromElement:element];
        }
    }
    
    return commentBlock;
}

- (NSString *) getOverflowIndentStringForCellWidth:(CGFloat)cellWidth
{
    NSMutableString *overflowString = [[NSMutableString alloc] initWithCapacity:0];
    int overflowLevels = [HNCommentCell getOverflowIndentLevels:self.nestedLevel forCellWidth:cellWidth];
    
    for (int i=0; i < overflowLevels; i++)
    {
        [overflowString appendString:@"• "];
    }
    
    return overflowString;
    
}

- (NSAttributedString *) getCommentHeaderWithTheme:(HNTheme *)theme forCellWidth:(CGFloat)cellWidth
{
    NSMutableAttributedString *headerString = nil;
    NSString *baseString;
    
    NSString *user = self.author;
    NSString *indentOverflowString = [self getOverflowIndentStringForCellWidth:cellWidth];
    
    if (!user)
    {
        //Comment was deleted by a moderator
        baseString = [NSString stringWithFormat:@"%@[deleted]", indentOverflowString];
        
        NSRange deletedRange = NSMakeRange(0, baseString.length);
        headerString = [[NSMutableAttributedString alloc] initWithString:baseString];
        [headerString addAttribute:NSFontAttributeName value:theme.commentBoldFont range:deletedRange];
    }
    else
    {
        NSString *timeString = self.dateWritten;
        baseString = [NSString stringWithFormat:@"%@%@ • %@", indentOverflowString, user, timeString];
        
        NSRange overflowStringRange = NSMakeRange(0, indentOverflowString.length);
        NSRange userStringRange = NSMakeRange(indentOverflowString.length, user.length);
        NSRange timeStringRange = NSMakeRange(baseString.length - timeString.length - 2 , timeString.length + 2);
        
        headerString = [[NSMutableAttributedString alloc] initWithString:baseString];
        [headerString addAttribute:NSFontAttributeName value:theme.commentNormalFont range:overflowStringRange];
        [headerString addAttribute:NSFontAttributeName value:theme.commentBoldFont range:userStringRange];
        [headerString addAttribute:NSFontAttributeName value:theme.commentNormalFont range:timeStringRange];
        [headerString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:timeStringRange];
    }
    
    return headerString;
}

- (NSAttributedString *) convertToAttributedStringWithTheme:(HNTheme *)theme
{
    
    HNCommentString *commentString = [self convertToCommentString:self.commentBlock];
    
    return [commentString getAttributedStringWithTheme:theme];
}

- (HNCommentString *) convertToCommentString
{
    HNCommentString *commentString = [self convertToCommentString:self.commentBlock];
    [commentString trimWhiteSpaceFromTop];
    
    return commentString;
}

- (HNCommentString *) convertToCommentString:(HNCommentBlock *)block
{
    HNCommentString *commentString = [[HNCommentString alloc] init];
    int styleStringStart = 0;
    NSString *styleType = nil;
    
    //This is a recursive funciton.  This is our base case.
    if ([block.tagName isEqualToString:@"text"] && block.text)
    {
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
        styleStringStart = commentString.text.length;
        styleType = block.tagName;
    }

    
    //Recurse this function until we get to the base case (tag="text")
    for (HNCommentBlock *child in block.childBlocks)
    {
        //"Code" tagged text needs to have white space removed in a special manner
        if ([styleType isEqualToString:@"code"] && child.text)
        {
            NSString *filteredString = [self filterWhiteSpace:child.text];
            child.text = filteredString;
        }
        
        
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

- (NSString *) filterWhiteSpace:(NSString *)rawString
{
    //First trim whitespace from ends of string
    NSMutableString *filteredString = [NSMutableString stringWithString:[rawString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    
    //Remove white space that follows a line break from string
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\n\\s+" options:0 error:nil];
    [regex replaceMatchesInString:filteredString options:0 range:NSMakeRange(0, [filteredString length]) withTemplate:@"\n"];
    
    return filteredString;
}

@end
