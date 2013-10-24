//
//  HNUtils.m
//  HackerNews
//
//  Created by Matthew Stanford on 10/23/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNUtils.h"

@implementation HNUtils

+(NSAttributedString *)getTimeUpdatedString
{
    NSAttributedString *returnString = nil;
    
    NSDate *currentDateTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"h:mm a MM/dd/yy"];
    
    NSString *dateString = [[NSString alloc] initWithFormat:@"Updated at %@",[dateFormatter stringFromDate:currentDateTime]];
    
    returnString = [[NSAttributedString alloc] initWithString:dateString];
    
    
    return returnString;
}

@end
