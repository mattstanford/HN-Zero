//
//  HNComment.h
//  HackerNews
//
//  Created by Matthew Stanford on 9/5/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNComment : NSObject
{
    NSString *text;
    NSString *author;
    NSString *dateWritten;
    
}

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *dateWritten;

@end
