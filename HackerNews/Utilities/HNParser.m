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
    
    for (TFHppleElement *row in htmlRows) {
        
        TFHppleElement *titleDataElement = [self getTitleElement:row];
        if (titleDataElement)
        {
            NSLog(@"%@, URL: %@, Domain: %@", [self getArticleTitle:titleDataElement], [self getArticleURL:titleDataElement], [self getArticleDomain:titleDataElement]);
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

+ (NSString *) getArticleTitle:(TFHppleElement *)titleElement
{
    NSString *returnTitle = nil;
    TFHppleElement *titleAnchor = [titleElement firstChildWithTagName:@"a"];
    
    if (titleAnchor)
    {
        //The first child in an anchor tag should be the text, which is our title
        TFHppleElement *titleElement = [titleAnchor firstChildWithTagName:@"text"];
        
        if (titleElement) {
            returnTitle = [titleElement content];
        }
    }
    
    return returnTitle;
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
    NSString *returnDomain = nil;
    TFHppleElement *titleSpan = [titleElement firstChildWithTagName:@"span"];
    
    if(titleSpan)
    {
        //The first child in an anchor tag should be the text, which is our title
        TFHppleElement *titleElement = [titleSpan firstChildWithTagName:@"text"];
        
        if (titleElement) {
            returnDomain = [titleElement content];
        }
    }
    
    return returnDomain;
}

/*
 * Element with class="title" contains data for Article name, URL, and the domain name to display
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



@end
