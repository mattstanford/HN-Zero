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

@synthesize downloadDelegate, url;

- (id) initWithUrl:(NSString *)initUrl
{
    self = [super init];
    if (self)
    {
        self.url = initUrl;
    }
    
    return self;
}

- (void) beginDownload
{
    
    NSURL *urlObject = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlObject];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [downloadDelegate downloadDidComplete:[HNParser parseArticles:responseObject]];
         
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *erro)
     {
         [downloadDelegate downloadFailed];
     }];
    
    
    [operation start];
}

@end
