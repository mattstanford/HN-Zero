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
#import "HNThemedViewController.h"

@class HNTheme;
@class HNWebBrowserVC;
@class HNArticle;
@class HNSettings;

@interface HNCommentVC : UITableViewController <commentViewerDelegate, TTTAttributedLabelDelegate, HNThemedViewController>


- (id)initWithStyle:(UITableViewStyle)style
          withTheme:(HNTheme *)appTheme
         webBrowser:(HNWebBrowserVC *)webBrowser
withDownloadController:(HNDownloadController *)downloadController
        andSettings:(HNSettings *)settings;

-(void) setArticle:(HNArticle *)article forceUpdate:(BOOL)doForceUpdate;
-(void)resetDownloadController:(HNDownloadController *)downloadController;

@end
