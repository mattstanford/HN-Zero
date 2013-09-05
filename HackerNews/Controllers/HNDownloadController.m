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

- (NSArray *) getFrontPageArticles
{
    NSArray *articles = nil;
    NSString *frontPageURL = @"http://news.ycombinator.com";
    
    NSURL *url = [NSURL URLWithString:frontPageURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setCompletionBlockWithSuccess:
     ^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         [HNParser parseArticles:responseObject];
         
         //NSLog(@"URL request success: %@", responseString );
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *erro)
     {
         NSLog(@"URL request failed!");
     }];
    
    
    [operation start];
    
    return articles;
    
}

@end
