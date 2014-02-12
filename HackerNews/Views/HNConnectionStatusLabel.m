//
//  HNConnectionStatusLabel.m
//  HN Zero
//
//  Created by Matt Stanford on 2/10/14.
//  Copyright (c) 2014 Matthew Stanford. All rights reserved.
//

#import "HNConnectionStatusLabel.h"

@implementation HNConnectionStatusLabel

@synthesize isShowingFinalText, finalStatusTextCounter;

- (id) init
{
    isShowingFinalText = FALSE;
    finalStatusTextCounter = 0;
    
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
    finalStatusTextCounter++;
}

- (void) clearStatusText
{
    finalStatusTextCounter--;
    if (finalStatusTextCounter <= 0 && isShowingFinalText) {
        self.text = @"";
        finalStatusTextCounter = 0;
    }
}

@end
