//
//  HNConnectionStatusLabel.m
//  HN Zero
//
//  Created by Matt Stanford on 2/10/14.
//  Copyright (c) 2014 Matthew Stanford. All rights reserved.
//

#import "HNConnectionStatusLabel.h"

@implementation HNConnectionStatusLabel

@synthesize isShowingFinalText;

- (id) init
{
    isShowingFinalText = FALSE;
    
    return [super init];
}

- (void) setStatusText:(NSString *)text
{
    self.text = text;
    isShowingFinalText = FALSE;
}

- (void) setFinalStatusText:(NSString *)text
{
    self.text = text;
    isShowingFinalText = TRUE;
}

- (void) clearStatusText
{
    if (isShowingFinalText) {
        self.text = @"";
    }
}

@end
