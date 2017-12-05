//
//  NSDate+UTCString.m
//  WWL
//
//  Created by Kristoffer Yap on 5/14/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "NSDate+UTCString.h"

@implementation NSDate (UTCString)

-(NSString*) getUTCString {
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [df setTimeZone:[NSTimeZone defaultTimeZone]];
    NSString* returnStr = [df stringFromDate:self];
    return returnStr;
}

-(NSString*) getStartDateString:(DayFilterType) filterType {
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [df setTimeZone:[NSTimeZone defaultTimeZone]];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* dateComponents = [[NSDateComponents alloc] init];
    
    switch (filterType) {
        case DayFilterTypeLast7Days:
            [dateComponents setWeekOfMonth:-1];
            break;
        case DayFilterTypeLast2Weeks:
            [dateComponents setWeekOfMonth:-2];
            break;
        case DayFilterTypeLast1Month:
            [dateComponents setMonth:-1];
            break;
        case DayFilterTypeLast3Months:
            [dateComponents setMonth:-3];
            break;
        default:
            break;
    }
    
    NSDate* returnDate = [calendar dateByAddingComponents:dateComponents toDate:self options:0];
    NSString* returnStr = [df stringFromDate:returnDate];
    return returnStr;
}

@end
