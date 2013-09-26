//
//  HNParser.m
//  HackerNews
//
//  Created by Matthew Stanford on 9/1/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNParser.h"
#import "HNArticle.h"
#import "TFHpple.h"


@implementation HNParser

#pragma mark Public functions

+ (NSArray *) parseArticles:(NSData *)htmlData
{
    NSMutableArray *articles = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *htmlRows = [self parseHtmlRows:htmlData];
    
    for (int i=0; i < [htmlRows count]; i++) {
        
        TFHppleElement *titleDataElement = [self getTitleElement:[htmlRows objectAtIndex:i]];
        TFHppleElement *subtextDataElement = nil;
        
        if (titleDataElement) {
            
            if ([htmlRows objectAtIndex:i+1])
            {
                /*
                 If we get the "title" row, that means there should be a row below it with
                 class = "subtext".  This row contains other info like the user, number of
                 comments, score, time posted, and the comment link ID
                */
                subtextDataElement = [self getSubtextElement:[htmlRows objectAtIndex:i+1]];
                
                if (titleDataElement && subtextDataElement)
                {
                    HNArticle *article = [[HNArticle alloc] init];
                    //Advance the counter one more since we're already using that row
                    i++;
                    
                    article.title = [self getArticleTitle:titleDataElement];
                    article.url = [self getArticleURL:titleDataElement];
                    article.domainName = [self getArticleDomain:titleDataElement];
                    article.user = [self getUser:subtextDataElement];
                    article.score = [self getScore:subtextDataElement];
                    article.numComments = [self getNumberOfComments:subtextDataElement];
                    article.commentLinkId = [self getCommentPageId:subtextDataElement];
                
                    [articles addObject:article];
                    
                    titleDataElement = nil;
                    subtextDataElement = nil;
                }
            }
        }
        
        
    }
    
    return articles;
}

#pragma mark Main Article element getters


+ (NSArray *) parseHtmlRows:(NSData *)htmlData
{
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    
    NSString *xpathQueryString = @"//table/tr";
    return [parser searchWithXPathQuery:xpathQueryString];
    
}

/*
 Returns an element with class="title" which contains:
 - an anchor with the Article name
 - an anchor with the URL
 - a span with the domain name to display
 */
+ (TFHppleElement *) getTitleElement:(TFHppleElement *)htmlRow
{
    NSArray *elements = [htmlRow children];
    
    for (TFHppleElement *element in elements)
    {
        NSDictionary *attributes = [element attributes];
        
        //Element must have class="title"
        if([attributes objectForKey:@"class"] && [[attributes objectForKey:@"class"] isEqualToString:@"title"])
        {
            
            //There is one tag where the only info is the article rank.  We must throw this away.
            //we can tell if this is a "bad" tag its child is a text tag.  A "good" element has a span
            //and an anchor tag
            if (![element firstChildWithTagName:@"text"]) {
                return element;
            }
            
        }
    }
    
    return nil;
    
}

/*
  Returns the element with class "subtext".  This element has three child nodes we care about:
       - a span, which has the article score
       - an anchor, which has the username of the submitter
       - an anchor, which has the number of comments AND the id of the comment page
 */
+ (TFHppleElement *) getSubtextElement:(TFHppleElement *)htmlRow
{
    NSArray *elements = [htmlRow children];
    
    for (TFHppleElement *element in elements)
    {
        NSDictionary *attributes = [element attributes];
        
        //Element must have class="subtext"
        if([attributes objectForKey:@"class"] && [[attributes objectForKey:@"class"] isEqualToString:@"subtext"])
        {
            return element;
        
        }
        
    }
    
    return nil;
    
}

#pragma mark Article attribute parsers

+ (NSString *) getArticleTitle:(TFHppleElement *)titleElement
{
    return [self getGrandChildofElement:titleElement firstTag:@"a" secondTag:@"text"];
}

+ (NSString *) getArticleURL:(TFHppleElement *)titleElement
{
    NSString *returnUrl = nil;
    TFHppleElement *titleAnchor = [titleElement firstChildWithTagName:@"a"];
    NSDictionary *titleAttributes = [titleAnchor attributes];
    
    if (titleAttributes) {
        returnUrl = [titleAttributes objectForKey:@"href"];
    }
    
    return returnUrl;
}

+ (NSString *) getArticleDomain:(TFHppleElement *)titleElement
{
    return [self getGrandChildofElement:titleElement firstTag:@"span" secondTag:@"text"];
}

+ (NSString *) getScore:(TFHppleElement *) subTextElement
{
    return [self getGrandChildofElement:subTextElement firstTag:@"span" secondTag:@"text"];
}

+ (NSString *) getUser:(TFHppleElement *) subTextElement
{
    NSString *userPattern = @"\\buser\\?id=(.*)\\b";
    NSArray *anchors = [subTextElement childrenWithTagName:@"a"];

    return [self getAttributeFromArray:anchors withRegex:userPattern];
}

+ (NSString *) getCommentPageId:(TFHppleElement *)subTextElement
{
    NSString *commentPagePattern = @"\\bitem\\?id=(.*)\\b";
    NSArray *anchors = [subTextElement childrenWithTagName:@"a"];
    
    return [self getAttributeFromArray:anchors withRegex:commentPagePattern];
    
}

+ (NSString *) getNumberOfComments:(TFHppleElement *)subTextElement
{
    NSString *commentPattern = @"\\b(\\d+) comments\\b";
    NSArray *anchors = [subTextElement childrenWithTagName:@"a"];
    NSString *returnString = nil;
    
    returnString = [self getChildFromArray:anchors withRegex:commentPattern];
    
    if (returnString) {
        return returnString;
    }
    else
    {
        return @"0";
    }
}

#pragma mark Helper functions

+ (NSString *) getGrandChildofElement:(TFHppleElement *)element firstTag:(NSString *)firstTag secondTag:(NSString *)secondTag
{
    NSString *result = nil;
    TFHppleElement *firstTagElement = [element firstChildWithTagName:firstTag];
    
    if (firstTagElement) {
        
        TFHppleElement *secondTagElement = [firstTagElement firstChildWithTagName:secondTag];
        
        if (secondTagElement) {
            result = [secondTagElement content];
        }
    }
    
    return result;
    
}

+ (NSString * ) getAttributeFromArray:(NSArray *) array withRegex:(NSString *)pattern
{
    NSString *result = nil;
    
    for (TFHppleElement *element in array)
    {
        NSString *stringToMatch = [[element attributes] objectForKey:@"href"];
        result = nil;
        
        if (stringToMatch) {
            result = [self getMatch:stringToMatch fromRegex:pattern];
        }
        
        if (result) break;
    }
    
    return result;
}

+ (NSString *) getChildFromArray:(NSArray *) array withRegex:(NSString *)pattern
{
    NSString *result = nil;
    
    for (TFHppleElement *element in array)
    {
        TFHppleElement *textElement = [element firstChildWithTagName:@"text"];
        result = nil;
        
        if (textElement) {
            result = [self getMatch:[textElement content] fromRegex:pattern];
        }
        
        if (result) break;
    }
    
    return result;
}

+ (NSString *) getMatch:(NSString *)stringToMatch fromRegex:(NSString *)pattern
{
    NSString *result = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:NULL];
    
    NSTextCheckingResult *match = [regex firstMatchInString:stringToMatch options:0 range:NSMakeRange(0, [stringToMatch length])];
    
    if ([match numberOfRanges] > 0) {
        result = [stringToMatch substringWithRange:[match rangeAtIndex:1]];
    }
    
    return result;
}



@end
