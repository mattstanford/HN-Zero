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

@synthesize text, styles;

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
        
        HNAttributedStyle *newStyle = [[HNAttributedStyle alloc] initWithStyleType:style.styleType value:style.value range:newRange];
        
        [stylesToAdd addObject:newStyle];
        
    }
    [self.styles addObjectsFromArray:stylesToAdd];
    [self.text appendString:commentString.text];
}

-(NSAttributedString *) getAttributedStringWithTheme:(HNTheme *)theme
{
    NSDictionary *defaultFont = [NSDictionary dictionaryWithObjectsAndKeys:theme.commentNormalFont, NSFontAttributeName, nil];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.text attributes:defaultFont];
    
    for (HNAttributedStyle *style in self.styles)
    {
        if (style.range.location + style.range.length <= string.length) {
            [string addAttribute:style.styleType value:style.value range:style.range];
        }
        else
        {
            NSLog(@"style error!");
        }
    }
    
    return string;
}

@end
