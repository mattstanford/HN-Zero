//
//  HNArticle.m
//  HackerNews
//
//  Created by Matthew Stanford on 9/4/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNArticle.h"

@implementation HNArticle

@synthesize title, url, domainName, score, user, timePosted, numComments, commentLinkId;

- (NSString *) getInfoText
{
    NSMutableString *infoString = [[NSMutableString alloc] init];
    
    if (self.score)
    {
        [infoString appendFormat:@"%@ points", self.score];
    }
    
    if (self.timePosted)
    {
        
        if (infoString.length > 0)
        {
            [infoString appendFormat:@" • "];
        }
        
        [infoString appendString:self.timePosted];
    }
    
    if (self.domainName)
    {
        
        if (infoString.length > 0)
        {
            [infoString appendFormat:@" • "];
        }
        
        [infoString appendFormat:@"%@", self.domainName];
        
    }
    
    if (self.user)
    {
        
        if (infoString.length > 0)
        {
            [infoString appendFormat:@" • "];
        }
        
        [infoString appendFormat:@"%@", self.user];
    }
    
    return infoString;
}


@end
