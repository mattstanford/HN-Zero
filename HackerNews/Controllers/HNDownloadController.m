//
//  HNDownloadController.m
//  HackerNews
//
//  Created by Matthew Stanford on 9/4/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNDownloadController.h"
#import <AFNetworking.h>
#import "HNParser.h"
#import "HNArticle.h"
#import <Firebase/Firebase.h>

static const NSString *HNApiBaseUrl = @"https://hacker-news.firebaseio.com/v0";
static const NSString *HNApiItem = @"item";

@interface HNDownloadController ()

@property (nonatomic, strong) NSMutableArray *articlesToDownloadQueue;
@property (nonatomic, strong) NSMutableArray *commentsToDownloadQueue;

@end

@implementation HNDownloadController

@synthesize downloadDelegate, isDownloading;

- (id) init
{
    self = [super init];
    if (self)
    {
        _articlesToDownloadQueue = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) beginArticleDownload:(NSURL *)url
{
    NSLog(@"downloading: %@", [url absoluteString]);
    
    Firebase* firebase = [[Firebase alloc] initWithUrl:[url absoluteString]];
    
    [firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
    {
        NSArray *articleObjects = (NSArray *)snapshot.value;
        
        [self beginDownloadingArticleObjects:articleObjects];
        isDownloading = NO;
    }
    withCancelBlock:^(NSError *error)
    {
        //[downloadDelegate downloadFailed:self];
        isDownloading = NO;
    }];
    
    isDownloading = YES;
}

- (void) beginDownloadingArticleObjects:(NSArray *)articleObjects
{
    _articlesToDownloadQueue = [[NSMutableArray alloc] initWithArray:articleObjects];
    _commentsToDownloadQueue = [[NSMutableArray alloc] init];
    
    //Kick off the article download
    [self downloadObjectWithId:[_articlesToDownloadQueue firstObject]];
}

-(void) downloadObjectWithId:(NSNumber *)objectId
{
    NSString *objectDownloadString =
        [NSString stringWithFormat:@"%@/%@/%li", HNApiBaseUrl, HNApiItem, [objectId integerValue]];
    
    NSLog(@"Getting item url: %@", objectDownloadString);
    
    Firebase *firebase = [[Firebase alloc] initWithUrl:objectDownloadString];
    
    //Remove article from queue since we are downloading it now
    [_articlesToDownloadQueue removeObject:objectId];
    
    [firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
    {
        NSDictionary *data = snapshot.value;
        NSLog(@"Got here");
        HNArticle *article = [[HNArticle alloc] initWithFirebaseData:data];
        
        [downloadDelegate didGetArticle:article];
        
        if (_articlesToDownloadQueue.count > 0)
        {
            [self downloadObjectWithId:[_articlesToDownloadQueue firstObject]];
        }
        
    } withCancelBlock:^(NSError *error) {
        //Nothing yet
    }];
}

@end
