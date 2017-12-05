//
//  NSString+Date.m
//  WWL
//
//  Created by Kristoffer Yap on 5/14/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

-(NSString*) getLocalTimeString {
    NSString* utcStr = [NSString stringWithFormat:@"%@ UTC", self];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSDate* date = [df dateFromString:utcStr];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    NSString* returnStr = [df stringFromDate:date];
    return returnStr;
}

-(NSString*) getDaysAgoString {
    NSString* utcStr = [NSString stringWithFormat:@"%@ UTC", self];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSDate* date = [df dateFromString:utcStr];
    
    NSDate* curDate = [NSDate date];
    
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:date
                                                          toDate:curDate
                                                         options:0];
    
    if([components day] == 0) {
        return @"Today";
    } else if([components day] == 1) {
        return [NSString stringWithFormat:@"%ld day ago", (long)[components day]];
    } else {
        return [NSString stringWithFormat:@"%ld days ago", (long)[components day]];
    }
}

+(NSString*) getLocalVideoNameString {
    NSDate* date = [NSDate date];
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    NSString* dateStr = [df stringFromDate:date];
    return [NSString stringWithFormat:@"WWL_STREM_%@.mov", dateStr];
}

@end
