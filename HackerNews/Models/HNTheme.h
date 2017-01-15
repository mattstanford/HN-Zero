//
//  HNTheme.h
//  HackerNews
//
//  Created by Matthew Stanford on 10/3/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNTheme : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIColor *titleBarColor;
@property (nonatomic, strong) UIColor *titleBarTextColor;
@property (nonatomic, strong) UIColor *titleTextColor;
@property (nonatomic, strong) UIColor *cellBackgroundColor;
@property (nonatomic, strong) UIColor *infoColor;
@property (nonatomic, strong) UIColor *normalTextColor;
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
@property (nonatomic, strong) UIColor *commentLinkColor;
@property (nonatomic, strong) UIColor *tableViewBackgroundColor;


@end
