//
//  HNLinkGetter.m
//  HN Zero
//
//  Created by Matt Stanford on 12/18/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNLinkGetter.h"
#import "HNParser.h"

@implementation HNLinkGetter

@synthesize baseUrlString, currentPage, currentLinkUrl, linkGetterDelegate, goalPage, downloadController;

-(id) init
{
    self = [super init];
    if (self)
    {
        baseUrlString = @"https://news.ycombinator.com";
        
        currentPage = 0;
        goalPage = 0;
        
        downloadController = [[HNDownloadController alloc] init];
        //downloadController.downloadDelegate = self;
    }
    
    return self;
}

//-(void) getCurrentMoreArticlesUrlForPage:(int)page
//{
//    currentPage = 0;
//    self.goalPage = page;
//    
//    [downloadController beginDownload:[NSURL URLWithString:baseUrlString]];
//    
//}

-(BOOL) isGettingNewLink
{
    return [downloadController isDownloading] && currentPage != goalPage;
}

#pragma mark download controller delegate

-(void) downloadDidComplete:(id)data
{
    NSString *retrievedUrlString = [HNParser getMoreArticlesLink:data];
    
    if (retrievedUrlString)
    {
        NSString *urlString = [NSString stringWithFormat:@"%@%@", baseUrlString, retrievedUrlString];
        NSURL *url = [NSURL URLWithString:urlString];
        
        if (currentPage == goalPage)
        {
            [linkGetterDelegate didGetLink:url];
        }
        else
        {
            //Get link on next page
            currentPage++;
            //[downloadController beginDownload:url];
        }
    }
    else
    {
        NSLog(@"Couldn't parse more articles link!");
        [linkGetterDelegate didFailToGetLink];
    }
}

-(void) downloadFailed
{
    NSLog(@"Download failed when trying to get more articles link!");
    [linkGetterDelegate didFailToGetLink];
}

@end
