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

- (void) setFinalStatusText:(NSString *)text duration:(CGFloat)delaySeconds
{
    self.text = text;
    isShowingFinalText = TRUE;
    finalStatusTextCounter++;
    
    /*
     Clear the status text after a delay.  The bottom bar may be visible if there
     is history in the browser
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delaySeconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self clearStatusText];
    });
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
