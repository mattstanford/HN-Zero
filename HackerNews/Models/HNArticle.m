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

NSString * const HNArticleId = @"id";
NSString * const HNArticleTitle = @"title";
NSString * const HNArticleUrl = @"url";
NSString * const HNArticleScore = @"score";
NSString * const HNArticleUser = @"by";
NSString * const HNArticleTimePosted = @"time";
NSString * const HNArticleType = @"type";
NSString * const HNArticleComments = @"kids";
NSString * const HNArticlePostComment = @"text";
NSString * const HNArticleNumComments = @"descendants";

NSString * const HNArticleDomainName = @"domainName";
//NSString * const HNArticleUser = @"user";
//NSString * const HNArticleTimePosted = @"timePosted";
//NSString * const HNArticleNumComments = @"numComments";
NSString * const HNArticleCommentLinkId = @"commentLinkId";


-(id) initWithFirebaseData:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {

        if([data objectForKey:HNArticleId]) self.objectId = [data objectForKey:HNArticleId];
        if([data objectForKey:HNArticleTitle]) self.title = [data objectForKey:HNArticleTitle];
        if([data objectForKey:HNArticleUrl]) self.url = [data objectForKey:HNArticleUrl];
        if([data objectForKey:HNArticleScore]) self.score = [data objectForKey:HNArticleScore];
        if([data objectForKey:HNArticleUser]) self.user = [data objectForKey:HNArticleUser];
        
        if([data objectForKey:HNArticleNumComments])
        {
            NSNumber *numCommentsNumber = [data objectForKey:HNArticleNumComments];
            self.numComments = [[NSString alloc] initWithFormat:@"%li", (long)[numCommentsNumber integerValue]];
        }
        
        if([data objectForKey:HNArticleTimePosted]) self.timePosted = [HNUtils getStringFromTimeStamp:[data objectForKey:HNArticleTimePosted]];
        

        //self.numComments = nil; //Have to get this asynchronously!!!
        
        if([data objectForKey:HNArticleId]) self.commentLinkId = [[NSString alloc] initWithFormat:@"%@", [data objectForKey:HNArticleId]];
        
        self.comments = [[NSMutableArray alloc] init];
        
        if([data objectForKey:HNArticleType]) self.type = [data objectForKey:HNArticleType];
        self.domainName = [self getDomainFromUrl:self.url];
        self.image = nil;
        
        if([data objectForKey:HNArticleComments]) self.childComments = [data objectForKey:HNArticleComments];
        
        if ([data objectForKey:HNArticlePostComment])
        {
            self.postComment = [[HNComment alloc] init];
            [self.postComment setWithPostText:[data objectForKey:HNArticlePostComment]];
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
        self.title = [aDecoder decodeObjectForKey:HNArticleTitle];
        self.url = [aDecoder decodeObjectForKey:HNArticleUrl];
        self.domainName = [aDecoder decodeObjectForKey:HNArticleDomainName];
        self.score = [aDecoder decodeObjectForKey:HNArticleScore];
        self.user = [aDecoder decodeObjectForKey:HNArticleUser];
        self.timePosted = [aDecoder decodeObjectForKey:HNArticleTimePosted];
        self.numComments = [aDecoder decodeObjectForKey:HNArticleNumComments];
        self.commentLinkId = [aDecoder decodeObjectForKey:HNArticleCommentLinkId];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:HNArticleTitle];
    [aCoder encodeObject:self.url forKey:HNArticleUrl];
    [aCoder encodeObject:self.domainName forKey:HNArticleDomainName];
    [aCoder encodeObject:self.score forKey:HNArticleScore];
    [aCoder encodeObject:self.user forKey:HNArticleUser];
    [aCoder encodeObject:self.timePosted forKey:HNArticleTimePosted];
    [aCoder encodeObject:self.numComments forKey:HNArticleNumComments];
    [aCoder encodeObject:self.commentLinkId forKey:HNArticleCommentLinkId];
}

- (void)writeNumComments
{
    NSInteger numComments = _comments.count;
    NSString *numCommentString = [[NSString alloc] initWithFormat:@"%li", (long)numComments];
    
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
