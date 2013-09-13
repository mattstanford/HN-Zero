//
//  HNCommentParser.m
//  HackerNews
//
//  Created by Matthew Stanford on 9/11/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNCommentParser.h"
#import "TFHpple.h"
#import "HNComment.h"

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
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSString *xpathQueryString = @"//table";
    NSArray *mainCommentPageElements = [parser searchWithXPathQuery:xpathQueryString];
    
    TFHppleElement *mainCommentPageTable = [mainCommentPageElements objectAtIndex:0];
    NSArray *mainCommentPageTableRows = [mainCommentPageTable children];
    
    /*
     The main comment section with the 'submit box' and the comments are index 2 in the table.  
     Index 0 is the header, index 1 is the space between the header and the comments.
     
     This element has a single 'td' element in it that contains two more tables
     */
    TFHppleElement *tdWithCommentsAndSubmitBox = [[mainCommentPageTableRows objectAtIndex:2] firstChildWithTagName:@"td"];
    
    /*
     The TD with the comments and submit box has these elements as children:
     
      - Table (The submit box)
      - br
      - br
      - Table (The comments)
     
     Using this layout, we will get index 3 of the children of this element
     */
    
    TFHppleElement *commentsTable = [[tdWithCommentsAndSubmitBox children] objectAtIndex:3];
    
    /*
     Now return the comment rows as an array
     */
    
    return [commentsTable children];
    
}

+ (HNComment *) parseCommentObjectFromRow:(TFHppleElement *)commentRow
{
    HNComment *commentObject = [[HNComment alloc] init];
    
    TFHppleElement *defaultElement = [self getDefaultTdFromRow:commentRow];
    
    if (defaultElement) {
        TFHppleElement *comheadElement = [self getComheadElementFromDefaulTdRow:defaultElement];
        TFHppleElement *commentElement = [defaultElement firstChildWithClassName:@"comment"];
        
        if (comheadElement && commentElement) {
            
            commentObject.author = [self getUserFromComheadElement:comheadElement];
            commentObject.dateWritten = [self getTimeStringFromComHeadElement:comheadElement];
            
        }
        
        
    }
       
    return commentObject;
    
}

+ (TFHppleElement *) getDefaultTdFromRow:(TFHppleElement *)commentRow
{
    TFHppleElement *defaultTdElement = nil;
    
    /*
     The comment row contains a single TD, with a single table inside that has a single row
     */
    TFHppleElement *commentTdElement = [commentRow firstChildWithTagName:@"td"];
    
    if (commentTdElement)
    {
        TFHppleElement *commentTableElement = [commentTdElement firstChildWithTagName:@"table"];
        
        if (commentTableElement) {
            TFHppleElement *commentInteriorRow = [commentTableElement firstChildWithTagName:@"tr"];
            
            if (commentInteriorRow) {
                
                /*
                 The interior comment row has several TDs.  We want the TD with class="default"
                 The "default" TD will have several children. 
                 */
                defaultTdElement = [commentInteriorRow firstChildWithClassName:@"default"];
                
            }
        }
    }
    
    return defaultTdElement;
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
    }
    
    return userName;
}

+ (NSString *) getTimeStringFromComHeadElement:(TFHppleElement *)comheadElement
{
    TFHppleElement *timeElement = [comheadElement firstTextChild];
    
    return [timeElement content];
}

@end
