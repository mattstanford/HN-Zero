//
//  HNCommentParser.m
//  HackerNews
//
//  Created by Matthew Stanford on 9/11/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNCommentParser.h"
#import "HNParser.h"
#import "TFHpple.h"
#import "HNComment.h"
#import "HNCommentBlock.h"

@implementation HNCommentParser

+ (NSArray *)parseComments:(NSData *)htmlData
{
    NSArray *commentRows = [self getCommentRows:htmlData];    
    NSMutableArray *parsedComments = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (TFHppleElement *commentRow in commentRows)
    {
        HNComment *commentObject = [self parseCommentObjectFromRow:commentRow];
        
        [parsedComments addObject:commentObject];
    }
    
    
    return parsedComments;
}

+ (NSArray *)getCommentRows:(NSData *)htmlData
{
    NSArray *commentRows = nil;
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSString *xpathQueryString = @"//table";
    NSArray *mainCommentPageElements = [parser searchWithXPathQuery:xpathQueryString];
    
    if (mainCommentPageElements) {
        
        TFHppleElement *mainCommentPageTable = [mainCommentPageElements objectAtIndex:0];
        NSArray *mainCommentPageTableRows = [mainCommentPageTable children];
    
        
        if (mainCommentPageTableRows && mainCommentPageTableRows.count >= 3) {
            
            /*
             The main comment section with the 'submit box' and the comments are index 2 in the table.
             Index 0 is the header, index 1 is the space between the header and the comments.
             
             This element has a single 'td' element in it that contains two more tables
             */
            TFHppleElement *tdWithCommentsAndSubmitBox = [[mainCommentPageTableRows objectAtIndex:2] firstChildWithTagName:@"td"];
            
            if (tdWithCommentsAndSubmitBox && tdWithCommentsAndSubmitBox.children.count > 4)
            {
                /*
                 The TD with the comments and submit box has these elements as children:
                 
                  - Table (The submit box)
                  - br
                  - br
                  - Table (The comments)
                 
                 Using this layout, we will get index 3 of the children of this element
                 */
                
                TFHppleElement *commentsTable = [[tdWithCommentsAndSubmitBox children] objectAtIndex:3];
                
                commentRows = [commentsTable children];
            }
        }
    }
    
    return commentRows;
    
}

+ (HNComment *) parseCommentObjectFromRow:(TFHppleElement *)commentRow
{
    HNComment *commentObject = [[HNComment alloc] init];
    
    TFHppleElement *commentInteriorRow = [self getInteriorTdFromRow:commentRow];
    
    
    if (commentInteriorRow) {

        /*
         The interior comment row has several TDs.  We want the TD with class="default"
         The "default" TD will have several children.
         */
        TFHppleElement *defaultElement = [commentInteriorRow firstChildWithClassName:@"default"];

        
        if (defaultElement) {
            TFHppleElement *comheadElement = [self getComheadElementFromDefaulTdRow:defaultElement];
            TFHppleElement *commentElement = [defaultElement firstChildWithClassName:@"comment"];
            
            if (comheadElement && commentElement) {
                
                commentObject.author = [self getUserFromComheadElement:comheadElement];
                commentObject.dateWritten = [self getTimeStringFromComHeadElement:comheadElement];
                commentObject.commentBlock = [self getCommentBlockFromCommentElement:commentElement];
                commentObject.nestedLevel = [self getNestedLevelFromCommentInterior:commentInteriorRow];
                
            }
            
            
        }
    }
    
    return commentObject;
    
}
/*
 
 The "comment interior" element has these three TDs:
 
 1. An "img" tag that acts as a spacer for the indent of the comment
 2. A bock for the upvote arrow
 3. The "default" block, where the comment content lives.
 
 */
+ (TFHppleElement *) getInteriorTdFromRow:(TFHppleElement *)commentRow
{
     TFHppleElement *commentInteriorRow = nil;
    
    /*
     The comment row contains a single TD, with a single table inside that has a single row
     */
    TFHppleElement *commentTdElement = [commentRow firstChildWithTagName:@"td"];
    
    if (commentTdElement)
    {
        TFHppleElement *commentTableElement = [commentTdElement firstChildWithTagName:@"table"];
        
        if (commentTableElement) {
            
            commentInteriorRow = [commentTableElement firstChildWithTagName:@"tr"];
            
        }
    }
    
    return commentInteriorRow;
}

+ (TFHppleElement *)getComheadElementFromDefaulTdRow:(TFHppleElement *)defaultTdRow
{
    TFHppleElement *comheadElement = nil;
    
    /*
     The "comhead" element is located in the first child of the "default td row" which
     should have been passed in.
     
     It is located in the first "div" element from the "default td row".
     */
    TFHppleElement *firstDivElement = [defaultTdRow firstChildWithTagName:@"div"];
    
    if (firstDivElement) {
        comheadElement = [firstDivElement firstChildWithClassName:@"comhead"];
    }
    
    return comheadElement;
}

+ (NSString *) getUserFromComheadElement:(TFHppleElement *)comheadElement
{
    NSString *userName = nil;
    TFHppleElement *anchorElement = [comheadElement firstChildWithTagName:@"a"];
    
    if (anchorElement) {
        userName = [[anchorElement firstTextChild] content];
        
        //Case where user name is "green" indicating a low - score comment
        if (userName == nil && [anchorElement firstChildWithTagName:@"font"]) {
            userName = [[[anchorElement firstChildWithTagName:@"font"] firstTextChild] content];
        }
    }
    
    return userName;
}

+ (NSString *) getTimeStringFromComHeadElement:(TFHppleElement *)comheadElement
{
    NSString *timeString = nil;
    TFHppleElement *timeElement = [comheadElement firstTextChild];
    
    if (timeElement)
    {
        /*
        Format of the time string should be the number of days, hours, etc, followed by
        the first letter of the unit.  So "8 minutes" would be "8m"
        */
        NSString *matchedString = [HNParser getMatch:[timeElement content] fromRegex:@"(\\d+ \\w)"];
        timeString = [matchedString stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    return timeString;
}

+ (HNCommentBlock *) getCommentBlockFromCommentElement:(TFHppleElement *)commentElement
{
    HNCommentBlock *commentBlock = nil;
    
    // The font element contains all the text blocks we want
    TFHppleElement *fontElement = [commentElement firstChildWithTagName:@"font"];
    
    if (fontElement)
    {
        
        commentBlock = [self getCommentBlockFromElement:fontElement];
        
    }
    
    return commentBlock;
}

+ (HNCommentBlock *) getCommentBlockFromElement:(TFHppleElement *)commentElement
{
    HNCommentBlock *commentBlock = [[HNCommentBlock alloc] init];
    NSMutableArray *childBlocks = nil;
 
    if ([commentElement hasChildren]) {
        
        NSArray *blockChildren = [commentElement children];
        childBlocks = [[NSMutableArray alloc] initWithCapacity:[blockChildren count]];
        
        for (TFHppleElement *child in blockChildren)
        {
            [childBlocks addObject:[self getCommentBlockFromElement:child]];
        }
        
        commentBlock.childBlocks = childBlocks;
    }
    
    if ([commentElement content]) {
        commentBlock.text = [commentElement content];
    }
    
    commentBlock.tagName = commentElement.tagName;
    commentBlock.attributes = commentElement.attributes;
    
    return commentBlock;
}

+ (NSNumber *) getNestedLevelFromCommentInterior:(TFHppleElement *)commentInterior
{
    /*
        The amount the comment is indented (the "nested" level) is in the first TD
        as an "img" tag which is being used as a spacer.
     */
    NSNumber *nestedLevel = nil;
    TFHppleElement *nestedLevelElement = [commentInterior firstChildWithTagName:@"td"];
    
    if (nestedLevelElement) {
        TFHppleElement *imgElement = [nestedLevelElement firstChildWithTagName:@"img"];
        
        if (imgElement)
        {
            NSDictionary *imgAttrs = [imgElement attributes];
            
            if ([imgAttrs objectForKey:@"width"]) {
                
                //Currently the nested level is in multiples of 40 on the page
                int level = [(NSNumber *)[imgAttrs objectForKey:@"width"] intValue] / 40;
                nestedLevel = [[NSNumber alloc] initWithInt:level];
            }
        }
    }
    
    return nestedLevel;
    
}

@end
