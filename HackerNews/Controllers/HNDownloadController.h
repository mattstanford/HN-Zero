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
-(void) downloadDidComplete:(NSArray *)data;
-(void) downloadFailed;
@end

@interface HNDownloadController : NSObject
{
    NSString *url;
}

@property (nonatomic, assign)  id<downloadControllerDelegate> downloadDelegate;
@property (nonatomic, strong) NSString *url;

- (id) initWithUrl:(NSString *)initUrl;
- (void) beginDownload;

@end
