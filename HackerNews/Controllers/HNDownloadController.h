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

@property (nonatomic, assign)  id<downloadControllerDelegate> downloadDelegate;

- (void) getFrontPageArticles;

@end
