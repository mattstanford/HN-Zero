//
//  HNDownloadController.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/4/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNArticle;
@class HNSettings;

@protocol articleDownloadDelegate
@required
-(void) didGetArticleIds;
-(void) didGetArticle:(HNArticle *)article;
-(void) didGetArticleWithComments:(HNArticle *)article;
@end


@protocol commentViewerDelegate
@required
-(void) didGetArticleWithComments:(HNArticle *)article;
@end;

@interface HNDownloadController : NSObject
{
    BOOL isDownloading;
}

@property (nonatomic, assign)  id<articleDownloadDelegate> articleDownloadDelegate;
@property (nonatomic, assign)  id<commentViewerDelegate> commentViewerDelegate;
@property (nonatomic, assign) BOOL isDownloading;
@property (nonatomic, assign) NSNumber *currentArticleBeingViewed;
@property (nonatomic, strong) HNSettings* settings;

- (void) beginArticleDownload:(NSURL *)url;
- (void) startDownloadingCommentsForArticle:(HNArticle *)article;

@end
