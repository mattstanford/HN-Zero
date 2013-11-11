//
//  HNTheme.h
//  HackerNews
//
//  Created by Matthew Stanford on 10/3/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNTheme : NSObject
{
    UIColor *titleBarColor;
    UIColor *titleBarTextColor;
    
    UIFont *articleTitleFont;
    UIFont *articleInfoFont;
    UIFont *articleNumCommentsFont;
    
    UIFont *commentNormalFont;
    UIFont *commentBoldFont;
    UIFont *commentItalicFont;
    UIFont *commentCodeFont;
    UIFont *commentTitleFont;
    UIFont *commentPostFont;
    UIFont *commentInfoFont;
    
    CGFloat commentFontSize;
}

@property (nonatomic, strong) UIColor *titleBarColor;
@property (nonatomic, strong) UIColor *titleBarTextColor;
@property (nonatomic, strong) UIFont *articleTitleFont;
@property (nonatomic, strong) UIFont *articleInfoFont;
@property (nonatomic, strong) UIFont *articleNumCommentsFont;
@property (nonatomic, strong) UIFont *commentNormalFont;
@property (nonatomic, strong) UIFont *commentBoldFont;
@property (nonatomic, strong) UIFont *commentItalicFont;
@property (nonatomic, strong) UIFont *commentCodeFont;
@property (nonatomic, assign) CGFloat commentFontSize;
@property (nonatomic, strong) UIFont *commentTitleFont;
@property (nonatomic, strong) UIFont *commentPostFont;
@property (nonatomic, strong) UIFont *commentInfoFont;


@end
