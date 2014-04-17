//
//  HNAbout.m
//  HN Zero
//
//  Created by Matt Stanford on 11/23/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNAbout.h"

static const CGFloat kBackButtonHeight = 30;

@interface HNAbout ()

@property (nonatomic, strong) UITextView *aboutMeTextView;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation HNAbout

@synthesize aboutMeTextView;

-(id) init
{
    self = [super init];
    if (self)
    {
        aboutMeTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        aboutMeTextView.editable = NO;
        aboutMeTextView.dataDetectorTypes = UIDataDetectorTypeLink;
        aboutMeTextView.text = @"Hacker News Zero\n\nCreated by Matt Stanford\n\nCheck out the code at https://github.com/mds6058/HackerNews";
        [self.view addSubview:aboutMeTextView];
        
        self.backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.backButton addTarget:self
                   action:@selector(backButtonPushed)
         forControlEvents:UIControlEventTouchUpInside];
        [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
        self.backButton.frame = CGRectZero;
        [self.view addSubview:self.backButton];
        
    }
    
    return self;
}

-(void) backButtonPushed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) viewWillLayoutSubviews
{
    self.aboutMeTextView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self layoutBackButton];
}

-(void) layoutBackButton
{
    CGFloat buttonWidth = self.view.frame.size.width;
    CGFloat buttonHeight = kBackButtonHeight;
    CGFloat xVal = 0;
    CGFloat yVal = self.view.frame.size.height - (self.view.frame.size.height * .25);
    
    self.backButton.frame = CGRectMake(xVal, yVal, buttonWidth, buttonHeight);
}


@end
