//
//  OwnStreamModel.m
//  WWL
//
//  Created by Kristoffer Yap on 5/11/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "OwnStreamModel.h"
#import "ChannelModel.h"

@implementation OwnStreamModel

#define KEY_DATA              @"data"
#define KEY_STATUS              @"status"
#define KEY_THUMB               @"thumbnail"
#define KEY_THUMB_URL           @"url"
#define KEY_LONGITUDE           @"longitude"
#define KEY_LATITUDE            @"latitude"
#define KEY_STREAM_ID           @"id"
#define KEY_STREAM_TYPE         @"stream_type"
#define KEY_STREAM_TYPE_ID      @"stream_type_id"
#define KEY_USER_ID             @"user_id"
#define KEY_STREAM_NAME         @"stream_name"
#define KEY_LOCATION_STR        @"location_address"
#define KEY_CHANNELS            @"channels"
#define KEY_CREATED_TIME        @"created_at"
#define KEY_DURATION            @"duration"


- (id)initWith: (NSDictionary *)data {
    self = [super init];
    
    if(data) {
        if([data objectForKey:KEY_STATUS] && [data objectForKey:KEY_STATUS] != [NSNull null]) {
            self.status = [data objectForKey:KEY_STATUS];
        }
        
        if([data objectForKey:KEY_CREATED_TIME] && [data objectForKey:KEY_CREATED_TIME] != [NSNull null]) {
            self.createdTime = [data objectForKey:KEY_CREATED_TIME];
        }
        
        if([data objectForKey:KEY_THUMB] && [data objectForKey:KEY_THUMB] != [NSNull null]) {
            NSDictionary* thumbData = [data objectForKey:KEY_THUMB];
            if([thumbData objectForKey:KEY_THUMB_URL] && [thumbData objectForKey:KEY_THUMB_URL] != [NSNull null]) {
                self.thumbUrl = [thumbData objectForKey:KEY_THUMB_URL];
            }
        }
        
        if([data objectForKey:KEY_LATITUDE] && [data objectForKey:KEY_LATITUDE] != [NSNull null]) {
            self.latitude = [[data objectForKey:KEY_LATITUDE] doubleValue];
        }
        
        if([data objectForKey:KEY_LONGITUDE] && [data objectForKey:KEY_LONGITUDE] != [NSNull null]) {
            self.longitude = [[data objectForKey:KEY_LONGITUDE] doubleValue];
        }
        
        if([data objectForKey:KEY_STREAM_ID] && [data objectForKey:KEY_STREAM_ID] != [NSNull null]) {
            self.stream_id = [[data objectForKey:KEY_STREAM_ID] longValue];
        }
        
        if([data objectForKey:KEY_STREAM_TYPE] && [data objectForKey:KEY_STREAM_TYPE] != [NSNull null]) {
            NSDictionary* streamData = [data objectForKey:KEY_STREAM_TYPE];
            if([streamData objectForKey:KEY_DATA] && [streamData objectForKey:KEY_DATA] != [NSNull null]) {
                self.streamType = [[StreamTypeModel alloc] initWith:[streamData objectForKey:KEY_DATA]];
            }
        }
        
        if([data objectForKey:KEY_STREAM_NAME] && [data objectForKey:KEY_STREAM_NAME] != [NSNull null]) {
            self.streamName = [data objectForKey:KEY_STREAM_NAME];
        }
        
        if([data objectForKey:KEY_LOCATION_STR] && [data objectForKey:KEY_LOCATION_STR] != [NSNull null]) {
            self.locationAddr = [data objectForKey:KEY_LOCATION_STR];
        }
        
        if([data objectForKey:KEY_DURATION] && [data objectForKey:KEY_DURATION] != [NSNull null]) {
            self.duration = [data objectForKey:KEY_DURATION];
        }
        
        if([data objectForKey:KEY_CHANNELS] && [data objectForKey:KEY_CHANNELS] != [NSNull null]) {
            NSArray* channels = [data objectForKey:KEY_CHANNELS];
            NSMutableArray* channelDatas = [[NSMutableArray alloc] init];
            for(NSDictionary* item in channels) {
                ChannelModel* channelData = [[ChannelModel alloc] initWith:item];
                [channelDatas addObject:channelData];
            }
            self.channels = channelDatas;
        }
    }
    
    return self;
}

@end
