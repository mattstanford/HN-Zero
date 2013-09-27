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

@implementation HNCommentVC

static const int FONT_SIZE = 12;
static const CGFloat CELL_LEFT_MARGIN = 10;
static const CGFloat CELL_RIGHT_MARGIN = 30;
static const CGFloat CELL_TOP_MARGIN = 10;
static const CGFloat CELL_BOTTOM_MARGIN = 10;
static const CGFloat NAME_LABEL_HEIGHT = 20;

static const int INDENT_PER_LEVEL = 20;

@synthesize downloadController, currentCommentId, comments, normalFont, italicFont, boldFont, fontSize;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        downloadController = [[HNDownloadController alloc] init];
        downloadController.downloadDelegate = self;
        
        currentCommentId = @"0";
        
        self.comments = [[NSArray alloc] init];
        
        self.fontSize = 12.0;
        self.normalFont = [UIFont fontWithName:@"Helvetica" size:self.fontSize];
        self.boldFont = [UIFont fontWithName:@"Helvetica-Bold" size:self.fontSize];
        self.italicFont = [UIFont fontWithName:@"Helvetica-Oblique" size:self.fontSize];
        
    }
    return self;
}

- (void) viewDidLoad
{
    [self.tableView registerClass:[HNCommentCell class] forCellReuseIdentifier:@"Cell"];
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
    
    cell.textLabel.font = self.normalFont;
    cell.nameLabel.font = self.boldFont;
    
    cell.nameLabel.text = comment.author;
    cell.textLabel.attributedText = [self convertToAttributedString:comment.commentBlock];
    cell.nestedLevel = comment.nestedLevel;
    
    cell.topMargin = CELL_TOP_MARGIN;
    cell.bottomMargin = CELL_BOTTOM_MARGIN;
    cell.leftMargin = CELL_LEFT_MARGIN;
    cell.rightMargin = CELL_RIGHT_MARGIN;
    cell.nameLabelHeight = NAME_LABEL_HEIGHT;
    cell.indentPerLevel = INDENT_PER_LEVEL;
    
    return cell;
}

- (CGFloat) getIndentWidth:(NSNumber *)level
{
    return INDENT_PER_LEVEL * [level floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HNComment *comment = [comments objectAtIndex:[indexPath row]];
    
    NSString *commentBlock = [[self convertToAttributedString:comment.commentBlock] string];
    
    //CGFloat labelWidth = [self getLabelWidth:indentLevel];
    CGFloat labelWidth = self.view.frame.size.width - [self getIndentWidth:comment.nestedLevel] - CELL_LEFT_MARGIN - CELL_RIGHT_MARGIN;
    
    CGSize constraint = CGSizeMake(labelWidth, CGFLOAT_MAX);
    
    CGSize commentSize = [commentBlock sizeWithFont:[UIFont systemFontOfSize:self.fontSize] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    return commentSize.height + NAME_LABEL_HEIGHT + CELL_BOTTOM_MARGIN + CELL_TOP_MARGIN;
}

#pragma mark Helper functions

- (NSAttributedString *) convertToAttributedString:(HNCommentBlock *)block
{
    NSMutableAttributedString *blockString = [[NSMutableAttributedString alloc] init];
    int styleStringStart = 0;
    NSString *styleType = nil;
    
    //This is a recursive funciton.  This is our base case.
    if ([block.tagName isEqualToString:@"text"] && block.text) {
        return [[NSAttributedString alloc] initWithString:block.text];
    }
    
    //We need to add some whitespace when we have a "p" element
    if ([block.tagName isEqualToString:@"p"])
    {
        [blockString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    }
    
    //We are setting the child elements to have a specific style according to the parent tag here
    if ([block.tagName isEqualToString:@"a"] || [block.tagName isEqualToString:@"i"])
    {
        styleStringStart = [blockString length];
        styleType = block.tagName;
    }
    
    //Recurse this function until we get to the base case (tag="text")
    for (HNCommentBlock *child in block.childBlocks)
    {
        [blockString appendAttributedString:[self convertToAttributedString:child]];
        
    }
    
    //Set any styles on the string
    if (styleType) {
        [self setStringStyle:blockString withStyle:styleType startPos:styleStringStart];
    }
    
    return blockString;
}

- (void) setStringStyle:(NSMutableAttributedString *)blockString withStyle:(NSString *)styleType startPos:(int)startPos
{
    
    if (styleType)
    {
        int styleStringLen = [blockString length] - startPos;
        NSRange styleRange = NSMakeRange(startPos, styleStringLen);
        
        if ([styleType isEqualToString:@"a"])
        {
            //Add blue color to link
            [blockString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:styleRange];
            //Underline too
            [blockString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:styleRange];
        }
        else if([styleType isEqualToString:@"i"])
        {
            [blockString addAttribute:NSFontAttributeName value:self.italicFont range:styleRange];
        }
        else if([styleType isEqualToString:@"b"])
        {
            [blockString addAttribute:NSFontAttributeName value:self.boldFont range:styleRange];
        }
    }

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
