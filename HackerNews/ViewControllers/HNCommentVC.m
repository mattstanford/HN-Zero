//
//  HNCommentVC.m
//  HackerNews
//
//  Created by Matthew Stanford on 9/10/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNCommentVC.h"
#import "HNCommentParser.h"
#import "HNComment.h"
#import "HNCommentBlock.h"
#import "HNCommentCell.h"
#import "HNTheme.h"

@implementation HNCommentVC

@synthesize downloadController, currentCommentId, comments, theme;

- (id)initWithStyle:(UITableViewStyle)style withTheme:(HNTheme *)appTheme
{
    self = [super initWithStyle:style];
    if (self) {
        downloadController = [[HNDownloadController alloc] init];
        downloadController.downloadDelegate = self;
        
        currentCommentId = @"0";
        
        self.comments = [[NSArray alloc] init];
        
        self.theme = appTheme;
        
    }
    return self;
}

- (void) viewDidLoad
{
    [self.tableView registerClass:[HNCommentCell class] forCellReuseIdentifier:@"Cell"];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.comments = nil;
    [self.tableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    downloadController.url = [NSString stringWithFormat:@"https://news.ycombinator.com/item?id=%@", currentCommentId];
    [downloadController beginDownload];
}

#pragma mark HNDownloadController delgate

- (void) downloadDidComplete:(id)data
{
    NSArray *parsedComments = [HNCommentParser parseComments:data];
    
    self.comments = parsedComments;
    [self.tableView reloadData];
}

- (void) downloadFailed
{
    NSLog(@"comment download failed!");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    HNCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    HNComment *comment = [comments objectAtIndex:[indexPath row]];
    
    cell.contentLabel.font = self.theme.commentNormalFont;
    cell.contentLabel.font = self.theme.commentBoldFont;

    cell.nameLabel.attributedText = [comment getCommentHeaderWithTheme:self.theme];
    cell.contentLabel.text = [comment convertToAttributedStringWithTheme:self.theme];
    cell.nestedLevel = comment.nestedLevel;
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNComment *comment = [comments objectAtIndex:[indexPath row]];
    
    NSAttributedString *commentBlock = [comment convertToAttributedStringWithTheme:self.theme];
    
    return [HNCommentCell getCellHeightForText:commentBlock width:self.view.frame.size.width nestLevel:comment.nestedLevel];
}

#pragma mark Helper functions


@end
