//
//  HNConnectionStatusLabel.h
//  HN Zero
//
//  Created by Matt Stanford on 2/10/14.
//  Copyright (c) 2014 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HNConnectionStatusLabel : UILabel
{
    BOOL isShowingFinalText;
    int finalStatusTextCounter;
}

@property (nonatomic, assign) BOOL isShowingFinalText;
@property (nonatomic, assign) int finalStatusTextCounter;

- (void) setStatusText:(NSString *)text;
- (void) setFinalStatusText:(NSString *)text duration:(CGFloat)delaySeconds;
- (void) clearStatusText;

@end
