//
//  HNParser.m
//  HackerNews
//
//  Created by Matthew Stanford on 9/1/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNParser.h"
#import "TFHpple.h"

@implementation HNParser

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
                subtextDataElement = [self getSubtextElement:[htmlRows objectAtIndex:i+1]];
                
                if (titleDataElement && subtextDataElement)
                {
                    //Advance the counter one more since we're already using that row
                    i++;
                    
                    NSLog(@"%@, URL: %@, Domain: %@, User: %@, page id: %@, score:%@", [self getArticleTitle:titleDataElement], [self getArticleURL:titleDataElement], [self getArticleDomain:titleDataElement], [self getUser:subtextDataElement], [self getCommentPageId:subtextDataElement], [self getScore:subtextDataElement]);
                    [self getUser:subtextDataElement];
                    
                    titleDataElement = nil;
                    subtextDataElement = nil;
                }
            }
        }
        
        
    }
    
    return articles;
}

+ (NSArray *) parseComments:(NSData *)htmlData
{
    return nil;
}

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

+ (NSString *) getScore:(TFHppleElement *) subTextElement
{
    return [self getGrandChildofElement:subTextElement firstTag:@"span" secondTag:@"text"];
}

+ (NSString *) getUser:(TFHppleElement *) subTextElement
{
    NSString *userPattern = @"\\buser\\?id=(.*)\\b";

    return [self getSubtextAnchorElement:subTextElement withRegex:userPattern];
    
}

+ (NSString *) getCommentPageId:(TFHppleElement *)subTextElement
{
    NSString *commentPagePattern = @"\\bitem\\?id=(.*)\\b";
    
    return [self getSubtextAnchorElement:subTextElement withRegex:commentPagePattern];
}

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

+ (NSString * ) getSubtextAnchorElement:(TFHppleElement *) subTextElement withRegex:(NSString *)pattern
{
    NSString *result = nil;
    
    NSArray *anchors = [subTextElement childrenWithTagName:@"a"];
    
    for (TFHppleElement *anchorElement in anchors)
    {
        NSString *href = [[anchorElement attributes] objectForKey:@"href"];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:NULL];
        
        NSTextCheckingResult *match = [regex firstMatchInString:href options:0 range:NSMakeRange(0, [href length])];
        
        if ([match numberOfRanges] > 0) {
            result = [href substringWithRange:[match rangeAtIndex:1]];
            break;
        }
        
        
    }
    
    return result;
}

@end
