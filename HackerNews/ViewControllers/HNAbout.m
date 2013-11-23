//
//  HNAbout.m
//  HN Zero
//
//  Created by Matt Stanford on 11/23/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNAbout.h"

@interface HNAbout ()

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
        
    }
    
    return self;
}


-(void) viewWillLayoutSubviews
{
    self.aboutMeTextView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


@end
