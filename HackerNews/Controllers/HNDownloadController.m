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
#import "HNComment.h"
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
    [self downloadArticleWithId:[_articlesToDownloadQueue firstObject]];
}

-(void) downloadArticleWithId:(NSNumber *)objectId
{
    Firebase *firebase = [self getFirebaseDownloaderForObject:objectId];
    
    //Remove article from queue since we are downloading it now
    [_articlesToDownloadQueue removeObject:objectId];
    
    [firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
    {
        NSDictionary *data = snapshot.value;
        HNArticle *article = [[HNArticle alloc] initWithFirebaseData:data];
        
        [downloadDelegate didGetArticle:article];
        
        //Start downloading comments
        NSArray *childComments = [data objectForKey:@"kids"];
        [self downloadCommentsForArticle:article withChildren:childComments parentComment:nil nestedLevel:0];
        
        if (_articlesToDownloadQueue.count > 0)
        {
            [self downloadArticleWithId:[_articlesToDownloadQueue firstObject]];
        }
        
    } withCancelBlock:^(NSError *error) {
        //Nothing yet
    }];
}

-(void) downloadCommentsForArticle:(HNArticle *)article
                      withChildren:(NSArray *)childComments
                     parentComment:(HNComment *)parentComment
                       nestedLevel:(NSNumber *)nestedLevel
{
    //Initialze an empty comments array
    NSMutableArray *commentArray = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i < childComments.count; i++)
    {
        HNComment *comment = [[HNComment alloc] init];
        [commentArray addObject:comment];
    }
    
    //Increment the comment counter in the article to keep track of when to fire off the delegate method
    article.commentsToDownload += childComments.count;
    
    //Insert the placeholder array into its proper place
    if (parentComment == nil)
    {
        article.comments = commentArray;
    }
    else
    {
        //Find the proper index to insert our new comments
        NSInteger insertIndex = 0;
        for (NSInteger j=0; j < article.comments.count; j++)
        {
            HNComment *parentCandidate = [article.comments objectAtIndex:j];
            if ([parentCandidate.objectId isEqualToNumber:parentComment.objectId])
            {
                insertIndex = j + 1;
                break;
            }
        }
        
        //Need to append if the parent comment is the last one
        if (insertIndex >= (article.comments.count))
        {
            [article.comments addObjectsFromArray:commentArray];
        }
        else
        {
            // Start adding at index position 28 and current array has 5 items
            NSRange range = NSMakeRange(insertIndex, [commentArray count]);
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            
            [article.comments insertObjects:commentArray atIndexes:indexSet];
        }
    }
    
    
    //Download each of the comments passed in
    for (NSInteger k=0; k < childComments.count; k++)
    {
        NSNumber *commentId = [childComments objectAtIndex:k];
        HNComment *targetComment = [commentArray objectAtIndex:k];
        
        [self downloadCommentWithId:commentId successBlock:^(NSDictionary *commentData) {
            
            article.commentsToDownload -= 1;
            NSLog(@"Comments remaining: %li", article.commentsToDownload);
            
            //Set the data for the download comment
            [targetComment setFirebaseData:commentData nestedLevel:nestedLevel];
            targetComment.nestedLevel = nestedLevel;
            
            //Check and see if we're done
            if (article.commentsToDownload <= 0)
            {
                [article writeNumComments];
                [downloadDelegate didGetArticleWithComments:article];
            }
            else
            {
                //Start downloading any child comments
                NSArray *commentChildren = [commentData objectForKey:@"kids"];
                if(commentChildren && commentChildren.count > 0)
                {
                    article.commentsToDownload += commentChildren.count;
                    NSNumber *incrementedNestedLevel = [[NSNumber alloc] initWithInteger:[nestedLevel integerValue] + 1];
                    [self downloadCommentsForArticle:article
                                        withChildren:commentChildren
                                       parentComment:targetComment
                                         nestedLevel:incrementedNestedLevel];
                }
            }
            
            
            
        }];
    }
}

-(void) downloadCommentWithId:(NSNumber *)objectId successBlock:(void (^)(NSDictionary * commentData))success
{

    Firebase *firebase = [self getFirebaseDownloaderForObject:objectId];
    
    [firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
     {
         NSDictionary *data = snapshot.value;
        
         success(data);
         
         
     } withCancelBlock:^(NSError *error) {
         //Nothing yet
     }];

}

-(Firebase *)getFirebaseDownloaderForObject:(NSNumber *)objectId
{
    NSString *objectDownloadString =
    [NSString stringWithFormat:@"%@/%@/%li", HNApiBaseUrl, HNApiItem, [objectId integerValue]];
    
    //NSLog(@"Getting item url: %@", objectDownloadString);
    
    Firebase *firebase = [[Firebase alloc] initWithUrl:objectDownloadString];
    
    return firebase;
}

@end
