//
//  HNArticle.m
//  HackerNews
//
//  Created by Matthew Stanford on 9/4/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNArticle.h"

@implementation HNArticle

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
    
    [self addInfo:self.score toInfoString:infoString];
    [self addInfo:self.timePosted toInfoString:infoString];
    [self addInfo:self.domainName toInfoString:infoString];
    [self addInfo:self.user toInfoString:infoString];
    
    return infoString;
}

- (NSString *) getCommentInfoText
{
    NSMutableString *infoString = [[NSMutableString alloc] init];
    
    [self addInfo:self.numComments toInfoString:infoString];
    [self addInfo:self.user toInfoString:infoString];
    [self addInfo:self.domainName toInfoString:infoString];
    [self addInfo:self.timePosted toInfoString:infoString];

    return infoString;
}

- (void) addInfo:(NSString *)info toInfoString:(NSMutableString *)mainInfoString
{
    if(info)
    {
        if (mainInfoString.length > 0)
        {
            [mainInfoString appendFormat:@"  • "];
        }
        
        [mainInfoString appendFormat:@"%@", info];
    }
}


@end
