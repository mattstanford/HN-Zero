//
//  HNDownloadController.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/4/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HNArticle;

@protocol downloadControllerDelegate
@required
-(void) didGetArticle:(HNArticle *)article;
-(void) didGetArticleWithComments:(HNArticle *)article;
@end

@interface HNDownloadController : NSObject
{
    BOOL isDownloading;
}

@property (nonatomic, assign)  id<downloadControllerDelegate> downloadDelegate;
@property (nonatomic, assign) BOOL isDownloading;

- (void) beginArticleDownload:(NSURL *)url;
- (void) startCommentDownloadForArticleId:(NSInteger)articleId;

@end
