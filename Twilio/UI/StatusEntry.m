//
//  StatusEntry.m
//  WWL
//
//  Created by Kristoffer Yap on 5/16/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "StatusEntry.h"

@implementation StatusEntry

+ (instancetype)statusEntryWithMember:(TCHMember *)member status:(TWCMemberStatus)status {
    return [[StatusEntry alloc] initWithMember:member status:status];
}

- (instancetype)initWithMember:(TCHMember *)member status:(TWCMemberStatus)status {
    self = [self init];
    if (self)
    {
        self.member = member;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
        dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        self.timestamp = [dateFormatter stringFromDate:[NSDate date]];
        self.status = status;
    }
    return self;
}

@end
