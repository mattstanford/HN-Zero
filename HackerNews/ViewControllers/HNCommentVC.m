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
#import "HNCommentString.h"
#import "HNAttributedStyle.h"
#import "HNWebBrowserVC.h"
#import "HNCommentInfoCell.h"
#import "HNArticle.h"
#import "HNUtils.h"
#import "HNParser.h"
#import "GAI.h"
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@interface HNCommentVC ()

@property (nonatomic, strong) HNWebBrowserVC *webBrowserVC;
@property (nonatomic, strong) HNDownloadController *downloadController;
@property (nonatomic, strong) HNArticle *currentArticle;
@property (nonatomic, strong) HNComment *postComment;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) HNTheme *theme;

@end

@implementation HNCommentVC

- (id)initWithStyle:(UITableViewStyle)style withTheme:(HNTheme *)appTheme webBrowser:(HNWebBrowserVC *)webBrowser
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        self.webBrowserVC = webBrowser;
        
        self.downloadController = [[HNDownloadController alloc] init];
        self.downloadController.downloadDelegate = self;
        
        self.comments = [[NSArray alloc] init];
        self.postComment = nil;
        
        self.theme = appTheme;
        
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Google analytics tracking
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Article List"];
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void) viewDidLoad
{
    [self.tableView registerClass:[HNCommentInfoCell class] forCellReuseIdentifier:@"Info"];
    [self.tableView registerClass:[HNCommentCell class] forCellReuseIdentifier:@"Comment"];
    
    //Setup the pull-to-refresh control
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Updating..."];
    [refresh addTarget:self action:@selector(updateComments) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

#pragma mark HNDownloadController delgate

- (void) downloadDidComplete:(id)data
{
    NSArray *parsedComments = [HNCommentParser parseComments:data];

    if([HNParser isSelfPost:self.currentArticle.url])
    {
        self.postComment = [HNCommentParser getPostFromCommentPage:data];
    }
    else
    {
        self.postComment = nil;
    }
    
    self.comments = [self buildTableWithData:parsedComments];
    [self.tableView reloadData];
    
    self.refreshControl.attributedTitle = [HNUtils getTimeUpdatedString];
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

    return [self.comments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell = nil;
    
    if ([indexPath row] == 0)
    {
        returnCell = [self getInfoCellForIndexPath:indexPath];
        
    }
    else
    {        
        returnCell = [self getCommentCellForIndexPath:indexPath];
    }
    
    return returnCell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        NSAttributedString *commentString = [self.postComment convertToAttributedStringWithTheme:self.theme];
        
        return [HNCommentInfoCell getCellHeightForText:self.currentArticle.title
                                              postText:commentString
                                              forWidth:self.view.frame.size.width
                                             titleFont:self.theme.commentTitleFont
                                              infoText:[self.currentArticle getInfoText]
                                              infoFont:self.theme.commentInfoFont
                                              postFont:self.theme.commentPostFont];
    }
    else
    {
        HNComment *comment = [self.comments objectAtIndex:[indexPath row]];
        
        NSAttributedString *commentBlock = [comment convertToAttributedStringWithTheme:self.theme];
        
        return [HNCommentCell getCellHeightForText:commentBlock
                                             width:self.view.frame.size.width
                                         nestLevel:comment.nestedLevel];
    }
}

#pragma mark TTTAttributedLabel functions

-(void) attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSLog(@"tapped link at %@", [url absoluteString]);
    [self.webBrowserVC setURL:[url absoluteString] forceUpdate:NO onClearBlock:nil];
    [self.navigationController pushViewController:self.webBrowserVC animated:YES];
}

#pragma mark Helper functions

-(void) setArticle:(HNArticle *)article forceUpdate:(BOOL)doForceUpdate
{
    if (doForceUpdate || ![article.commentLinkId isEqualToString:self.currentArticle.commentLinkId])
    {
        self.currentArticle = article;
        self.title = article.title;
        self.postComment = nil;
        
        [self updateComments];
    }

}

-(void) updateComments
{
    //blank out the comments
    self.comments = [self buildTableWithData:nil];
    [self.tableView reloadData];
    
    //Download new comments
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://news.ycombinator.com/item?id=%@", self.currentArticle.commentLinkId]];
    //[self.downloadController beginDownload:url];
    
    
    //Update refresh control
    //if ([self.refreshControl isRefreshing]) [self.refreshControl endRefreshing];
    
    self.comments = [self buildTableWithData:self.currentArticle.comments];
    [self.tableView reloadData];
    
}

-(NSArray *) buildTableWithData:(NSArray *)data
{
    NSMutableArray *returnData = [[NSMutableArray alloc] init];
    
    //The first element is the article info
    [returnData addObject:@"test"];
    
    //Then add the comment data
    [returnData addObjectsFromArray:data];
    
    return returnData;
    
}

- (void) addLinksToLabel:(TTTAttributedLabel *)label withCommentString:(HNCommentString *)commentString
{
    NSArray *links = [commentString getLinks];
    
    for (HNAttributedStyle *link in links)
    {
        if (link.attributes && [link.attributes objectForKey:@"href"])
        {
            NSString *urlString = [link.attributes objectForKey:@"href"];
            [label addLinkToURL:[NSURL URLWithString:urlString] withRange:link.range];
        }
    }
}

-(UITableViewCell *) getCommentCellForIndexPath:(NSIndexPath *)indexPath
{
    HNCommentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Comment" forIndexPath:indexPath];
    
    HNComment *comment = [self.comments objectAtIndex:[indexPath row]];
    HNCommentString *commentString = [comment convertToCommentString];
    
    cell.nameLabel.attributedText = [comment getCommentHeaderWithTheme:self.theme forCellWidth:self.view.frame.size.width];
    cell.contentLabel.text = [comment convertToAttributedStringWithTheme:self.theme];
    
    cell.nestedLevel = comment.nestedLevel;
    
    [self addLinksToLabel:cell.contentLabel withCommentString:commentString];
    cell.contentLabel.delegate = self;
    
    return cell;

}

-(UITableViewCell *) getInfoCellForIndexPath:(NSIndexPath *)indexPath
{
    HNCommentInfoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Info" forIndexPath:indexPath];
    
    cell.articleTitleLabel.text = self.currentArticle.title;
    cell.articleTitleLabel.font = self.theme.commentTitleFont;
    
    cell.infoLabel.text = [self.currentArticle getCommentInfoText];
    cell.infoLabel.font = self.theme.commentInfoFont;
    cell.infoLabel.textColor = [UIColor lightGrayColor];
    
    cell.postLabel.delegate = self;
    if(self.postComment)
    {
        HNCommentString *commentString = [self.postComment convertToCommentString];
        cell.postLabel.attributedText =[self.postComment convertToAttributedStringWithTheme:self.theme];
        [self addLinksToLabel:cell.postLabel withCommentString:commentString];
    }
    else
    {
        cell.postLabel.attributedText = nil;
    }
    
    
    //cell.postLabel.font = self.theme.commentPostFont;
    cell.separatorView.backgroundColor = self.theme.titleBarColor;
    
    return cell;
    
}


@end
