//
//  HNAttributedStyle.h
//  HackerNews
//
//  Created by Matthew Stanford on 10/6/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    HNSTYLE_LINK,
    HNSTYLE_ITALIC,
    HNSTYLE_BOLD,
    HNSTYLE_CODE
    
} HNSTYLETYPE;

@interface HNAttributedStyle : NSObject

@property (nonatomic, assign) HNSTYLETYPE styleType;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) NSDictionary *attributes;

-(id) initWithStyleType:(HNSTYLETYPE)theStyleType range:(NSRange)theRange;
-(id) initWithStyleType:(HNSTYLETYPE)theStyleType range:(NSRange)theRange attributes:(NSDictionary *)attributes;

@end
