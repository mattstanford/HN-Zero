//
//  HNDownloadController.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/4/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol downloadControllerDelegate
@required
-(void) downloadDidComplete:(id)data;
-(void) downloadFailed;
@end

@interface HNDownloadController : NSObject
{
    BOOL isDownloading;
}

@property (nonatomic, assign)  id<downloadControllerDelegate> downloadDelegate;
@property (nonatomic, assign) BOOL isDownloading;

- (void) beginDownload:(NSURL *)url;

@end
