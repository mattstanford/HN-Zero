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

static const NSInteger HNMaxCommentDownloads = 1000;

@interface HNDownloadController ()

@property (nonatomic, strong) NSMutableArray *articlesToDownloadQueue;
@property (nonatomic, strong) NSMutableArray *commentsToDownloadQueue;
@property (nonatomic, assign) NSInteger numCommentsDownloading;
@property (nonatomic, strong) NSMutableDictionary *commentsToDownload;

@end

@implementation HNDownloadController

@synthesize downloadDelegate, isDownloading;

- (id) init
{
    self = [super init];
    if (self)
    {
        _articlesToDownloadQueue = [[NSMutableArray alloc] init];
        _commentsToDownload = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void) beginArticleDownload:(NSURL *)url
{
    //NSLog(@"downloading: %@", [url absoluteString]);
    
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
        if([data objectForKey:@"kids"])
        {
            NSArray *childComments = [data objectForKey:@"kids"];
            [_commentsToDownload setObject:[NSNumber numberWithInt:0] forKey:objectId];
            [self downloadCommentsForArticle:article withChildren:childComments parentComment:nil nestedLevel:0];
        }
        else
        {
            if ([[data objectForKey:@"type"] isEqualToString:@"story"])
            {
                [article writeNumComments];
                [downloadDelegate didGetArticleWithComments:article];
            }
        }
        
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
    //NSLog(@"Current total: %li", [[_commentsToDownload objectForKey:article.objectId] integerValue]);
    [self incrementCommentsToDownloadForArticle:article.objectId byAmount:childComments.count];
    
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
            
            [self incrementCommentsToDownloadForArticle:article.objectId byAmount:-1];
            //NSLog(@"Removed 1, total: %li", [[_commentsToDownload objectForKey:article.objectId] integerValue]);
            
            //Set the data for the download comment
            [targetComment setFirebaseData:commentData nestedLevel:nestedLevel];
            targetComment.nestedLevel = nestedLevel;
            
            //Check and see if we're done
            if ([[_commentsToDownload objectForKey:article.objectId] integerValue] <= 0)
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
    //First save off a copy of the comment ID and its success block for later
    NSMutableDictionary *commentDownloadData = [[NSMutableDictionary alloc] init];
    [commentDownloadData setObject:success forKey:@"successBlock"];
    [commentDownloadData setObject:objectId forKey:@"objectId"];

    
    if (_numCommentsDownloading < HNMaxCommentDownloads)
    {
        Firebase *firebase = [self getFirebaseDownloaderForObject:objectId];
        
        _numCommentsDownloading++;
        [firebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
         {
             NSDictionary *data = snapshot.value;
             success(data);
             _numCommentsDownloading--;
             
             //Download the next element in the queue if one exists
             if (_commentsToDownloadQueue.count > 0)
             {
                 //Pop the first element
                 NSDictionary *nextDownloadObject = [_commentsToDownloadQueue firstObject];
                 [_commentsToDownloadQueue removeObjectAtIndex:0];
                 
                 if (nextDownloadObject != nil)
                 {
                     void (^nextSuccessBlock)(NSDictionary *) = [nextDownloadObject objectForKey:@"successBlock"];
                     NSNumber *nextObjectId = [nextDownloadObject objectForKey:@"objectId"];
                     [self downloadCommentWithId:nextObjectId successBlock:nextSuccessBlock];
                 }
             }
             
             
         } withCancelBlock:^(NSError *error) {
             //Nothing yet
         }];
    }
    else
    {
        //Too many elements downloading right now, add it to the queue
        [_commentsToDownloadQueue addObject:commentDownloadData];
    }

}

-(Firebase *)getFirebaseDownloaderForObject:(NSNumber *)objectId
{
    NSString *objectDownloadString =
    [NSString stringWithFormat:@"%@/%@/%li", HNApiBaseUrl, HNApiItem, [objectId integerValue]];
    
    //NSLog(@"Getting item url: %@", objectDownloadString);
    
    Firebase *firebase = [[Firebase alloc] initWithUrl:objectDownloadString];
    
    return firebase;
}

-(void)incrementCommentsToDownloadForArticle:(NSNumber *)objectId byAmount:(NSInteger)incrementCount
{
    NSInteger currentCount = [[self.commentsToDownload objectForKey:objectId] integerValue];
    NSNumber *newCount = [[NSNumber alloc] initWithInteger:currentCount + incrementCount];
    
    [_commentsToDownload setObject:newCount forKey:objectId];

    //NSLog(@"Added %li, total: %li", incrementCount, [[_commentsToDownload objectForKey:objectId] integerValue]);
    
}

@end
