//
//  HNTouchableView.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/29/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HNTouchableViewDelegate
@required
-(void) viewDidTouchDown;
-(void) viewDidTouchUp;
-(void) viewDidCancelTouches;
@end

@interface HNTouchableView : UIView

@property (nonatomic, assign)  id<HNTouchableViewDelegate> viewDelegate;

@end
