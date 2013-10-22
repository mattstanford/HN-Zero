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

#pragma mark NSCoding delegate

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.domainName = [aDecoder decodeObjectForKey:@"domainName"];
        self.score = [aDecoder decodeObjectForKey:@"score"];
        self.user = [aDecoder decodeObjectForKey:@"user"];
        self.timePosted = [aDecoder decodeObjectForKey:@"timePosted"];
        self.numComments = [aDecoder decodeObjectForKey:@"numComments"];
        self.commentLinkId = [aDecoder decodeObjectForKey:@"commentLinkId"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:self.domainName forKey:@"domainName"];
    [aCoder encodeObject:self.score forKey:@"score"];
    [aCoder encodeObject:self.user forKey:@"user"];
    [aCoder encodeObject:self.timePosted forKey:@"timePosted"];
    [aCoder encodeObject:self.numComments forKey:@"numComments"];
    [aCoder encodeObject:self.commentLinkId forKey:@"commentLinkId"];
}

#pragma mark Helper functions

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

- (NSString *) getCommentInfoText
{
    NSMutableString *infoString = [[NSMutableString alloc] init];
    
    if (self.numComments)
    {
        [infoString appendFormat:@"%@ comments", self.numComments];
    }
    
    if (self.user)
    {
        
        if (infoString.length > 0)
        {
            [infoString appendFormat:@" • "];
        }
        
        [infoString appendString:self.user];
    }
    
    if (self.domainName)
    {
        
        if (infoString.length > 0)
        {
            [infoString appendFormat:@" • "];
        }
        
        [infoString appendFormat:@"%@", self.domainName];
        
    }
    
    
    return infoString;
}


@end
