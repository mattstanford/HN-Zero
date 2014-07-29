//
//  HNIconDownloadController.h
//  HN Zero
//
//  Created by Matt Stanford on 7/8/14.
//  Copyright (c) 2014 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNIconDownloadController : NSObject

- (void) getGoogleIcon:(NSString *)domain success:(void (^)(UIImage *))completionBlock;
- (void) downloadIcon:(NSString *)domain success:(void (^)(NSData *))successBlock;

@end
