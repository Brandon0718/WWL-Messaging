//
//  StreamInfoModel.m
//  8a-ios
//
//  Created by Kristoffer Yap on 5/2/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "StreamInfoModel.h"

@implementation StreamInfoModel

#define KEY_DATA                @"data"
#define KEY_IP_ADDRESS          @"ip_address"
#define KEY_RECORD_URL          @"record_url"
#define KEY_STREAM_NAME         @"streamName"
#define KEY_TOKEN               @"token"

- (id)initWith: (NSDictionary *)dic {
    self = [super init];
    
    if(dic) {
        NSDictionary* data = [dic objectForKey:KEY_DATA];
        
        if(data) {
            if([data objectForKey:KEY_IP_ADDRESS] && [data objectForKey:KEY_IP_ADDRESS] != [NSNull null]) {
                self.ipAddress = [data objectForKey:KEY_IP_ADDRESS];
            }
        }
        
        if([dic objectForKey:KEY_RECORD_URL] && [dic objectForKey:KEY_RECORD_URL] != [NSNull null]) {
            self.recordUrl = [dic objectForKey:KEY_RECORD_URL];
        }
        
        if([dic objectForKey:KEY_STREAM_NAME] && [dic objectForKey:KEY_STREAM_NAME] != [NSNull null]) {
            self.streamName = [dic objectForKey:KEY_STREAM_NAME];
        }
        
        if([dic objectForKey:KEY_TOKEN] && [dic objectForKey:KEY_TOKEN] != [NSNull null]) {
            self.token = [dic objectForKey:KEY_TOKEN];
        }
    }
    
    return self;
}

@end
