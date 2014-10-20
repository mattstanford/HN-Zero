//
//  HNArticle.m
//  HackerNews
//
//  Created by Matthew Stanford on 9/4/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNArticle.h"
#import "HNUtils.h"
#import "HNComment.h"

@implementation HNArticle

#pragma mark NSCoding delegate

-(id) initWithFirebaseData:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.objectId = [data objectForKey:@"id"];
        self.title = [data objectForKey:@"title"];
        self.url = [data objectForKey:@"url"];
        
        self.score = [data objectForKey:@"score"];
        self.user = [data objectForKey:@"by"];
        self.timePosted = [HNUtils getStringFromTimeStamp:[data objectForKey:@"time"]];
        self.numComments = nil; //Have to get this asynchronously!!!
        self.commentLinkId = [[NSString alloc] initWithFormat:@"%@", [data objectForKey:@"id"]];
        self.comments = [[NSMutableArray alloc] init];
        self.type = [data objectForKey:@"type"];
        self.domainName = [self getDomainFromUrl:self.url];
        self.image = nil;
        self.childComments = [data objectForKey:@"kids"];
        
        if ([data objectForKey:@"text"])
        {
            self.postComment = [[HNComment alloc] init];
            [self.postComment setWithPostText:[data objectForKey:@"text"]];
        }
        else
        {
            self.postComment = nil;
        }
       
    }
    
    return self;
}

-(NSString *)getDomainFromUrl:(NSString *)url
{
    NSURL *tempUrl = [NSURL URLWithString:self.url];
    NSString *hostString = [tempUrl host];
    
    //Remove 'www' from the domain name string if it's there
    NSString *wwwPrefix = @"www.";
    if ([hostString hasPrefix:wwwPrefix])
    {
        hostString = [hostString substringFromIndex:[wwwPrefix length]];
    }
    
    return hostString;
}

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

- (void)writeNumComments
{
    NSInteger numComments = _comments.count;
    NSString *numCommentString = [[NSString alloc] initWithFormat:@"%li", numComments];
    
    _numComments = numCommentString;
}

#pragma mark Helper functions

- (NSString *) getInfoText
{
    NSMutableString *infoString = [[NSMutableString alloc] init];
   
    [self addInfo:self.score withFormat:@"%@ points" toInfoString:infoString];
    [self addInfo:self.timePosted toInfoString:infoString];
    [self addInfo:self.domainName toInfoString:infoString];
    [self addInfo:self.user toInfoString:infoString];
    
    return infoString;
}

- (NSString *) getCommentInfoText
{
    NSMutableString *infoString = [[NSMutableString alloc] init];
    
    [self addInfo:self.numComments withFormat:@"%@ comments" toInfoString:infoString];
    [self addInfo:self.user toInfoString:infoString];
    [self addInfo:self.domainName toInfoString:infoString];
    [self addInfo:self.timePosted toInfoString:infoString];

    return infoString;
}

- (void) addInfo:(NSString *)info withFormat:(NSString *)stringFormat toInfoString:(NSMutableString *)mainInfoString
{
    if(info)
    {
        if (mainInfoString.length > 0)
        {
            [mainInfoString appendFormat:@"  • "];
        }
        
        NSString *finalInfoString;
        if (stringFormat)
        {
            finalInfoString = [NSString stringWithFormat:stringFormat, info];
        }
        else
        {
            finalInfoString = info;
        }
        
        [mainInfoString appendFormat:@"%@", finalInfoString];
    }
}

-(void) addInfo:(NSString *)info toInfoString:(NSMutableString *)mainInfoString
{
    [self addInfo:info withFormat:nil toInfoString:mainInfoString];
}

-(BOOL) isSelfPost
{
    if ([self.url isEqualToString:@""] || self.url == nil)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}


@end
