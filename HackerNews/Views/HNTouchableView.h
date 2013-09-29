//
//  HNTouchableView.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/29/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HNTouchableView;

@protocol HNTouchableViewDelegate
@required
-(void) viewDidTouchDown:(HNTouchableView *)viewTouched;
-(void) viewDidTouchUp:(HNTouchableView *)viewTouched;
-(void) viewDidCancelTouches:(HNTouchableView *)viewTouched;
@end

@interface HNTouchableView : UIView

@property (nonatomic, assign)  id<HNTouchableViewDelegate> viewDelegate;

@end
