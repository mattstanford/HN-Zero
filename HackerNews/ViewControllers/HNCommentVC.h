//
//  HNCommentVC.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/10/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNDownloadController.h"
#import <TTTAttributedLabel.h>

@class HNTheme;
@class HNWebBrowserVC;

@interface HNCommentVC : UITableViewController <downloadControllerDelegate, TTTAttributedLabelDelegate>
{
    HNWebBrowserVC *webBrowserVC;
    HNDownloadController *downloadController;
    NSString *currentCommentId;
    NSArray *comments;
    HNTheme *theme;
}

@property (nonatomic, strong) HNWebBrowserVC *webBrowserVC;
@property (nonatomic, strong) HNDownloadController *downloadController;
@property (nonatomic, strong) NSString *currentCommentId;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) HNTheme *theme;

- (id)initWithStyle:(UITableViewStyle)style withTheme:(HNTheme *)appTheme webBrowser:(HNWebBrowserVC *)webBrowser;

@end
