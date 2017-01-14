//
//  HNCommentString.m
//  HackerNews
//
//  Created by Matthew Stanford on 10/6/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNCommentString.h"
#import "HNTheme.h"
#import "HNAttributedStyle.h"

@implementation HNCommentString

-(id) init
{
    self = [super init];
    if (self)
    {
        self.text = [[NSMutableString alloc] initWithCapacity:0];
        self.styles = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

-(id) initWithString:(NSString *)theString styles:(NSArray *)theStyles
{
    self = [super init];
    if (self)
    {
        if (theString) {
            self.text = [[NSMutableString alloc] initWithString:theString];
        }
        else
        {
            self.text = [[NSMutableString alloc] init];
        }
        
        if (theStyles) {
            self.styles = [[NSMutableArray alloc] initWithArray:theStyles];
        }
        else
        {
            self.styles = [[NSMutableArray alloc] init];
        }
        
    }
    
    return self;
}

-(void) appendCommentString:(HNCommentString *)commentString
{
    NSMutableArray *stylesToAdd = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (HNAttributedStyle *style in commentString.styles)
    {
        int newStartPos = self.text.length + style.range.location;
        NSRange newRange = NSMakeRange(newStartPos, style.range.length);
        
        HNAttributedStyle *newStyle = [[HNAttributedStyle alloc] initWithStyleType:style.styleType range:newRange attributes:style.attributes];
        
        [stylesToAdd addObject:newStyle];
        
    }
    [self.styles addObjectsFromArray:stylesToAdd];
    [self.text appendString:commentString.text];
}

-(void) trimWhiteSpaceFromTop
{
    NSInteger oldLength = self.text.length;
    
    NSRange range = [self.text rangeOfString:@"^\\s*" options:NSRegularExpressionSearch];
    self.text = (NSMutableString *)[self.text stringByReplacingCharactersInRange:range withString:@""];
   
    NSInteger charDifference = oldLength - self.text.length;
    
    for (HNAttributedStyle *style in self.styles)
    {
        NSRange newRange = NSMakeRange(style.range.location - charDifference, style.range.length);
        style.range = newRange;
    }
}

-(NSAttributedString *) getAttributedStringWithTheme:(HNTheme *)theme
{
    //NSString *trimmedString = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self trimWhiteSpaceFromTop];
    
    NSDictionary *attributes = @{NSFontAttributeName: theme.commentNormalFont, NSForegroundColorAttributeName: theme.normalTextColor};
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.text attributes:attributes];
    
    for (HNAttributedStyle *style in self.styles)
    {
        if (style.range.location + style.range.length <= string.length)
        {
            [self applyStyle:style toAttributedString:string withTheme:theme];
        }
        else
        {
            NSLog(@"style error!");
        }
    }
    
    return string;
}

-(void) applyStyle:(HNAttributedStyle *)style toAttributedString:(NSMutableAttributedString *)string withTheme:(HNTheme *)theme
{
    
    switch (style.styleType) {
        case HNSTYLE_BOLD:
            [string addAttribute:NSFontAttributeName value:theme.commentBoldFont range:style.range];
            break;
            
        case HNSTYLE_ITALIC:
            [string addAttribute:NSFontAttributeName value:theme.commentItalicFont range:style.range];
            break;
            
        case HNSTYLE_CODE:
            [string addAttribute:NSFontAttributeName value:theme.commentCodeFont range:style.range];
            break;
            
        case HNSTYLE_LINK:
           // [string addAttribute:NSForegroundColorAttributeName value:theme.commentLinkColor range:style.range];
           // [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:style.range];
            break;
            
    }
    
}

-(NSArray *) getLinks
{
    NSMutableArray *links = [[NSMutableArray alloc] init];
    
    for (HNAttributedStyle *style in self.styles)
    {
        if (style.styleType == HNSTYLE_LINK)
        {
            [links addObject:style];
        }
        
    }
    
    return links;
}

@end
