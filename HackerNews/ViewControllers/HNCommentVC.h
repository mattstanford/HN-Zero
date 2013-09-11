//
//  HNCommentVC.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/10/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HNDownloadController.h"

@interface HNCommentVC : UITableViewController <downloadControllerDelegate>
{
    HNDownloadController *downloadController;
    NSString *currentCommentId;
}

@property (nonatomic, strong) HNDownloadController *downloadController;
@property (nonatomic, strong) NSString *currentCommentId;

@end
