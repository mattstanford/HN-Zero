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
@class HNArticle;

@interface HNCommentVC : UITableViewController <commentViewerDelegate, TTTAttributedLabelDelegate>


- (id)initWithStyle:(UITableViewStyle)style
          withTheme:(HNTheme *)appTheme
         webBrowser:(HNWebBrowserVC *)webBrowser
withDownloadController:(HNDownloadController *)downloadController;;

-(void) setArticle:(HNArticle *)article forceUpdate:(BOOL)doForceUpdate;

@end
