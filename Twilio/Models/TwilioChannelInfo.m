//
//  TwilioChannelInfo.m
//  WWL
//
//  Created by Kristoffer Yap on 5/21/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "TwilioChannelInfo.h"

@implementation TwilioChannelInfo

-(instancetype) initWithChannel:(TCHChannel*) channel {
    self = [super init];
    
    NSDictionary* channelInfoDic = channel.attributes;
    if ([channelInfoDic objectForKey:@"channel"] && [channelInfoDic objectForKey:@"channel"] != [NSNull null]) {
        NSDictionary* channelDic = [channelInfoDic objectForKey:@"channel"];
        
        if ([channelDic objectForKey:@"name"] && [channelDic objectForKey:@"name"] != [NSNull null]) {
            self.name = [channelDic objectForKey:@"name"];
        }
        
        if ([channelDic objectForKey:@"logo"] && [channelDic objectForKey:@"logo"] != [NSNull null]) {
            NSDictionary* logoDic = [channelDic objectForKey:@"logo"];
            if ([logoDic objectForKey:@"url"] && [channelDic objectForKey:@"url"] != [NSNull null]) {
                self.logoURL = [logoDic objectForKey:@"url"];
            }
        }
    }
    
    return self;
}

@end
