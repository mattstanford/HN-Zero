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

+ (NSString *)getPostFromCommentPage:(NSData *)htmlData
{
    NSMutableString *commentPost = [[NSMutableString alloc] init];
    TFHppleElement *tdWithCommentsAndSubmitBox = [self getElementWithCommentsAndSubmitBox:htmlData];
    
    //The first element has the header info.  Then 2nd and 3rd elements are just line breaks
    TFHppleElement *commentHeaderElement = [tdWithCommentsAndSubmitBox firstChild];
    
    //The comment header has a bunch of rows:
    // 0 - Title
    // 1 - Meta info (score, time posted, etc)
    // 2 - Style tag
    // 3 - Post body
    TFHppleElement *postBodyElement = [[commentHeaderElement children] objectAtIndex:3];
    
    //The post body has the following TDs:
    // 0 - Empty row
    // 1 - Post body TD
    TFHppleElement *postBodyTD = [[postBodyElement children] objectAtIndex:1];
    
    for (int i=0; i < postBodyTD.children.count; i++)
    {
        //First element is raw text, proceeding elements are "p" tags
        NSString *content = nil;
        if (i==0)
        {
            content = [[postBodyTD firstTextChild] content];
        }
        else
        {
            content = [[[[postBodyTD children] objectAtIndex:i] firstTextChild] content];
        }
        
        //Don't add trailing line breaks on last element
        if (i == postBodyTD.children.count - 1)
        {
            if (content.length > 0)
            {
                [commentPost appendFormat:@"%@",content];
            }
        }
        else
        {
            [commentPost appendFormat:@"%@\n\n",content];
        }
        
    }
    
    NSLog(@"post: %@", commentPost);
    
    if (commentPost.length == 0)
    {
        commentPost = nil;
    }
    
    return commentPost;
}

+ (NSArray *) getMainCommentPageElements:(NSData *)htmlData
{
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSString *xpathQueryString = @"//table";
    
    return [parser searchWithXPathQuery:xpathQueryString];
    
}

+ (TFHppleElement *)getElementWithCommentsAndSubmitBox:(NSData *)htmlData
{
    TFHppleElement *elementWithCommentsAndSubmitBox = nil;
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    NSString *xpathQueryString = @"//table";
    
    NSArray *mainCommentPageElements = [parser searchWithXPathQuery:xpathQueryString];
    
    if (mainCommentPageElements && mainCommentPageElements.count > 0)
    {
        TFHppleElement *mainCommentPageTable = [mainCommentPageElements objectAtIndex:0];
        NSArray *mainCommentPageTableRows = [mainCommentPageTable children];
        
        
        if (mainCommentPageTableRows && mainCommentPageTableRows.count >= 3) {
            
            /*
             The main comment section with the 'submit box' and the comments are index 2 in the table.
             Index 0 is the header, index 1 is the space between the header and the comments.
             
             This element has a single 'td' element in it that contains two more tables
             */
            
            
            /*
             Comment page may contain a header that indicates maintenance being done;
             this will cause extra elements in this array; loop through the elements 
             here to account for that
            */
            TFHppleElement *elementWithCommentsParentElement;
            for (int i=2; i<mainCommentPageTableRows.count; i++)
            {
                elementWithCommentsParentElement = [mainCommentPageTableRows objectAtIndex:i];
                
                if ([elementWithCommentsParentElement hasChildren] && [elementWithCommentsParentElement firstChildWithTagName:@"td"])
                {
                    break;
                }
            }
            elementWithCommentsAndSubmitBox = [elementWithCommentsParentElement firstChildWithTagName:@"td"];
        }
    }
    
    return elementWithCommentsAndSubmitBox;
}

+ (NSArray *)getCommentRows:(NSData *)htmlData
{
    NSArray *commentRows = nil;
        
    TFHppleElement *tdWithCommentsAndSubmitBox = [self getElementWithCommentsAndSubmitBox:htmlData];
    
    if (tdWithCommentsAndSubmitBox && tdWithCommentsAndSubmitBox.children.count > 4)
    {
        /*
         The TD with the comments and submit box has these elements as children:

          - Table (The submit box)
          - br
          - br
          - br (iOS 7 only)
          - Table (The comments)

         Using this layout, we will get index 3 of the children of this element for iOS6,
         and index 4 for iOS7
         */

        NSArray *commentsChildren = [tdWithCommentsAndSubmitBox children];
        
        int commentsTableIndex = 3;
        while (![[commentsChildren objectAtIndex:commentsTableIndex] hasChildren] && commentsTableIndex < commentsChildren.count )
        {
            commentsTableIndex++;
        }
        
        if (commentsTableIndex < commentsChildren.count)
        {
            TFHppleElement *commentsTable = [commentsChildren objectAtIndex:commentsTableIndex];
            
            commentRows = [commentsTable children];
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
