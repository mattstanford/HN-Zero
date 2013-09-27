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
    NSArray *comments;
    
    UIFont *normalFont;
    UIFont *italicFont;
    UIFont *boldFont;
    CGFloat fontSize;
    
}

@property (nonatomic, strong) HNDownloadController *downloadController;
@property (nonatomic, strong) NSString *currentCommentId;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) UIFont *normalFont;
@property (nonatomic, strong) UIFont *italicFont;
@property (nonatomic, strong) UIFont *boldFont;
@property (nonatomic, assign) CGFloat fontSize;

@end
