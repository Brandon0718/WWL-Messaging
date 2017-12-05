//
//  NSString+custom.m
//  WWL
//
//  Created by Kristoffer Yap on 5/21/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "NSString+custom.h"

@implementation NSString (custom)

-(NSURL*) getImageURL {
    NSString* encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL* url = [NSURL URLWithString:encodedString];
    return url;
}

-(NSString*) getFilteredMessage:(NSString*) username {
    if([self isEqualToString:CHAT_VOICE_CALLING]) {
        return [NSString stringWithFormat:@"%@ is voice calling you.", username];
    } else if([self isEqualToString:CHAT_VOICE_END]) {
        return [NSString stringWithFormat:@"%@ ended voice calling.", username];
    } else if([self isEqualToString:CHAT_VOICE_ACCEPT]) {
        return [NSString stringWithFormat:@"Accepted the call with %@", username];
    } else if([self isEqualToString:CHAT_VOICE_DENY]) {
        return [NSString stringWithFormat:@"Rejected the call with %@", username];
    } else if([self isEqualToString:CHAT_VOICE_END_ME]) {
        return [NSString stringWithFormat:@"Ended the call with %@", username];
    } else {
        return self;
    }
}

-(UIImage*) getNewsTypeImage {
    
    if([self isEqualToString:@"Fire"]) {
        return [UIImage imageNamed:@"icon_type_fire"];
    } else if([self isEqualToString:@"Accident"]) {
        return [UIImage imageNamed:@"icon_type_accident"];
    } else if([self isEqualToString:@"Crime"]) {
        return [UIImage imageNamed:@"icon_type_crime"];
    } else if([self isEqualToString:@"War"]) {
        return [UIImage imageNamed:@"icon_type_war"];
    } else if([self isEqualToString:@"Politics"]) {
        return [UIImage imageNamed:@"icon_type_politics"];
    } else if([self isEqualToString:@"Weather"]) {
        return [UIImage imageNamed:@"icon_type_weather"];
    } else if([self isEqualToString:@"Celebrities"]) {
        return [UIImage imageNamed:@"icon_type_celebrities"];
    } else if([self isEqualToString:@"Sports"]) {
        return [UIImage imageNamed:@"icon_type_sports"];
    } else if([self isEqualToString:@"Other"]) {
        return [UIImage imageNamed:@"icon_type_other"];
    } else {
        return nil;
    }
}

@end
