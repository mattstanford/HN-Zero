//
//  HNUtils.m
//  HackerNews
//
//  Created by Matthew Stanford on 10/23/13.
//  Copyright (c) 2013 Matthew Stanford. All rights reserved.
//

#import "HNUtils.h"

@implementation HNUtils

+(NSString *)getTimeUpdatedString
{
    NSAttributedString *returnString = nil;
    
    NSDate *currentDateTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"h:mm a MM/dd/yy"];
    
    NSString *dateString = [[NSString alloc] initWithFormat:@"Updated at %@",[dateFormatter stringFromDate:currentDateTime]];
    
   // returnString = [[NSAttributedString alloc] initWithString:dateString];
    
    
    return dateString;
}

+(NSString *)getStringFromTimeStamp:(NSNumber *)timestamp
{
    NSString *timeTemplate;
    NSDate *currentTime = [NSDate date];
    NSDate *objectTime = [NSDate dateWithTimeIntervalSince1970:[timestamp integerValue]];
    
    NSTimeInterval difference = [currentTime timeIntervalSinceDate:objectTime];
    
    difference = difference / 60;
    
    if (difference > 60)
    {
        difference = difference / 60;
        
        if (difference > 24)
        {
            difference = difference / 24;
            timeTemplate = @"%li day";
        }
        else
        {
            timeTemplate = @"%li hour";
        }
    }
    else
    {
        
        timeTemplate = @"%li minute";
    }
    
    NSMutableString *timeString = [[NSMutableString alloc] initWithFormat:timeTemplate, (NSInteger)difference];
    
    if (((NSInteger) difference) > 1)
    {
        [timeString appendString:@"s"];
    }
    
    return timeString;
}

@end
