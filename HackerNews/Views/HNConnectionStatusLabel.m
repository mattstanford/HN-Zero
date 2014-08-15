//
//  HNConnectionStatusLabel.m
//  HN Zero
//
//  Created by Matt Stanford on 2/10/14.
//  Copyright (c) 2014 Matthew Stanford. All rights reserved.
//

#import "HNConnectionStatusLabel.h"

@implementation HNConnectionStatusLabel

- (id) init
{
    self.isShowingFinalText = FALSE;
    self.finalStatusTextCounter = 0;
    
    return [super init];
}

- (void) setStatusText:(NSString *)text
{
    self.text = text;
    self.isShowingFinalText = FALSE;
}

- (void) setFinalStatusText:(NSString *)text duration:(CGFloat)delaySeconds
{
    self.text = text;
    self.isShowingFinalText = TRUE;
    self.finalStatusTextCounter++;
    
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
    self.finalStatusTextCounter--;
    if (self.finalStatusTextCounter <= 0 && self.isShowingFinalText) {
        self.text = @"";
        self.finalStatusTextCounter = 0;
    }
}

@end
