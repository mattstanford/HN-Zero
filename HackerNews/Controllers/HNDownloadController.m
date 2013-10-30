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

@implementation HNDownloadController

@synthesize downloadDelegate, isDownloading;

- (void) beginDownload:(NSURL *)url
{
    NSLog(@"downloading: %@", [url absoluteString]);
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [downloadDelegate downloadDidComplete:responseObject];
         isDownloading = NO;
         
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *erro)
     {
         [downloadDelegate downloadFailed];
         isDownloading = NO;
     }];
    
    isDownloading = YES;
    [operation start];
}

@end
