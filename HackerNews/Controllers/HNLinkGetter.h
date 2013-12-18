//
//  HNLinkGetter.h
//  HN Zero
//
//  Created by Matt Stanford on 12/18/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HNDownloadController.h"

@class HNParser;

@protocol HNLinkGetterDelegate
@required
-(void) didGetLink:(NSURL *)linkUrl;
-(void) didFailToGetLink;
@end

@interface HNLinkGetter : NSObject <downloadControllerDelegate>
{
    NSString *baseUrlString;
    int currentPage;
    NSURL *currentLinkUrl;
    int goalPage;
    
    HNDownloadController *downloadController;
}

@property (nonatomic, assign) id<HNLinkGetterDelegate> linkGetterDelegate;
@property (nonatomic, strong) NSString *baseUrlString;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSURL *currentLinkUrl;
@property (nonatomic, assign) int goalPage;
@property (nonatomic, strong) HNDownloadController *downloadController;

-(void) getCurrentMoreArticlesUrlForPage:(int)page;

@end
