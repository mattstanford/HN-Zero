//
//  HNTouchableView.m
//  HackerNews
//
//  Created by Matthew Stanford on 9/29/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNTouchableView.h"

@implementation HNTouchableView

@synthesize viewDelegate;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [viewDelegate viewDidTouchDown:self];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [viewDelegate viewDidCancelTouches:self];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [viewDelegate viewDidTouchUp:self];
}

@end
