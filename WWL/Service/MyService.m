//
//  MyService.m
//  8a-ios
//
//  Created by Mobile on 21/04/2017.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "MyService.h"

#import "StreamTypeModel.h"
#import "NSDate+UTCString.h"

@implementation MyService

+ (MyService *)shared
{
    static MyService *singleton;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[MyService alloc] init];
    });
    
    return singleton;
    
}

-(void)requestConfirmationCodeWithPhoneNum:(NSString *)phoneNum withCompletion:(void(^)(BOOL success,id res))block{
    
    [self requestPostWithURL: [AppDelegate shared].apiBaseUrl atPath:API_CONFIRM_CODE withParams: @{@"phoneNumber": phoneNum } withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void)loginWithPhoneNum:(NSString *)phoneNum confirmationCode: (NSString *)code withCompletion:(void(^)(BOOL success,id res))block{
    
    [self requestPostWithURL: [AppDelegate shared].apiBaseUrl atPath:API_LOGIN withParams: @{@"phoneNumber": phoneNum, @"confirmationCode": code} withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            
            // save token here for further api requests.
            NSLog(@"Token: %@", dict[@"token"]);
            self.token = [dict objectForKey:@"token"];
            
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void)loginWithEmail:(NSString *)email password: (NSString *)password withCompletion:(void(^)(BOOL success,id res))block {
    
    [self requestPostWithURL: [AppDelegate shared].apiBaseUrl atPath:API_LOGIN withParams: @{@"email": email, @"password": password} withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void)checkUserProfile:(void(^)(BOOL success))block {
    [self requestGetWithURL:[AppDelegate shared].apiBaseUrl atPath:API_PROFILE_CHECK withParams: nil withResponse:^(BOOL success, id res) {
        BOOL isOK = NO;
        
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            if([dict[@"status"] isEqualToString:@"ok"]) {
                isOK = [[dict objectForKey:@"isProfileFilled"] boolValue];
            }
        }
        
        block (isOK);
    }];
}

-(void)getUserProfileFields:(void(^)(BOOL success,id res))block {
    
    [self requestGetWithURL:[AppDelegate shared].apiBaseUrl atPath:API_PROFILE_FIELDS withParams: nil withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void)updateUserProfileField:(ProfileModel*) dataModel completedBlock:(void(^)(BOOL success, id res)) block {
    NSData* postData;
    NSString* key;
    BOOL isFile = NO;
    
    if(!dataModel) {
        block(NO, nil);
        return;
    }
    
    key = [NSString stringWithFormat:@"field_%ld", dataModel.identifier];
    NSDictionary* param = nil;
    
    switch (dataModel.type) {
        case ProfileFieldTypeImage:
            isFile = YES;
            postData = (NSData*)dataModel.value;
            break;
        default:
        {
            isFile = NO;
            NSString* dataString = (NSString*)dataModel.value;
            param = [[NSDictionary alloc] initWithObjectsAndKeys:dataString, key, nil];
            break;
        }
    }
    
    [self requestPostWithMultiPartData:[AppDelegate shared].apiBaseUrl atPath:API_PROFILE_FIELDS data:postData key:key isFile:isFile param:param withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void) getChannels:(void(^)(BOOL success, id res)) block {
    NSDictionary* paramDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"stream", @"action", nil];
    [self requestGetWithURL:[AppDelegate shared].apiBaseUrl atPath:API_CHANNELS withParams:paramDic withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void) getFavoriteChannelIds:(void(^)(BOOL success, id res)) block {
    [self requestGetWithURL:[AppDelegate shared].apiBaseUrl atPath:API_FAV_CHANNEL_IDS withParams:nil withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void) getFavoriteChannelObjects:(void(^)(BOOL success, id res)) block {
    [self requestGetWithURL:[AppDelegate shared].apiBaseUrl atPath:API_FAV_CHANNEL_OBJECTS withParams:nil withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void) getNearbyChannels:(CLLocationCoordinate2D) userLocation callback:(void(^)(BOOL success, id res)) block {
    NSString* requestStr = [NSString stringWithFormat:@"%@&search[coordinates]=%f,%f", API_NEAR_CHANNELS, userLocation.latitude, userLocation.longitude];
    
    [self requestGetWithURL:[AppDelegate shared].apiBaseUrl atPath:requestStr withParams:nil withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void) getRecentChannels:(void(^)(BOOL success, id res)) block {
    [self requestGetWithURL:[AppDelegate shared].apiBaseUrl atPath:API_RECENT_CHANNELS withParams:nil withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}


-(void) insertFavoriteChannels:(NSArray*) channels block:(void(^)(BOOL success, id res)) block {
    NSMutableArray* keys = [[NSMutableArray alloc] init];
    NSMutableArray* channelIds = [[NSMutableArray alloc] init];
    for(ChannelModel* item in channels) {
        NSLog(@"%@", item);
        [keys addObject:@"channelIds[]"];
        [channelIds addObject:[NSString stringWithFormat:@"%ld", item.identifier]];
    }
    
    [self requestPostWithMultiPart:[AppDelegate shared].apiBaseUrl atPath:API_FAV_CHANNEL_IDS arrayValue:channelIds key:keys parameters:nil withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void) deleteFavoriteChannel:(ChannelModel*) channel block:(void(^)(BOOL success, id res)) block {
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithLong:channel.identifier], @"channelIds[]", nil];
    [self requestDeleteWithURL:[AppDelegate shared].apiBaseUrl atPath:API_FAV_CHANNEL_IDS withParams:param withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void) getChannelConnections:(void(^)(BOOL success, id res)) block {
    [self requestGetWithURL:[AppDelegate shared].apiBaseUrl atPath:API_CHANNEL_CONNECTIONS_OBJ withParams:nil withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void) insertChannelConnections:(NSArray*) channels block:(void(^)(BOOL success, id res)) block {
    NSMutableArray* keys = [[NSMutableArray alloc] init];
    NSMutableArray* channelIds = [[NSMutableArray alloc] init];
    for(ChannelModel* item in channels) {
        NSLog(@"%@", item);
        [keys addObject:@"channelIds[]"];
        [channelIds addObject:[NSString stringWithFormat:@"%ld", item.identifier]];
    }
    
    [self requestPostWithMultiPart:[AppDelegate shared].apiBaseUrl atPath:API_CHANNEL_CONNECTIONS arrayValue:channelIds key:keys parameters:nil withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void) deleteChannelConnections:(ChannelModel*) channel block:(void(^)(BOOL success, id res)) block {
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithLong:channel.identifier], @"channelIds[]", nil];
    [self requestDeleteWithURL:[AppDelegate shared].apiBaseUrl atPath:API_CHANNEL_CONNECTIONS withParams:param withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void) getVODStreams:(int) page
                param:(WatchNewsFilterModel*) filterParam
                block:(void (^)(BOOL, id))block {
    
    [self requestGetWithURL:[AppDelegate shared].apiBaseUrl atPath:[NSString stringWithFormat:API_STREAM_VOD, page] withParams:nil withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void) getOwnStreams:(void(^)(BOOL success,id res))block {
    [self requestGetWithURL:[AppDelegate shared].apiBaseUrl atPath:API_STREAM_ME withParams:nil withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void) getOwnStreamsForPage:(int) page
                  channelIds:(NSArray*) channels
               streamTypeIds:(NSArray*) streamTypes
                     dayType:(DayFilterType) dayType
                       block:(void(^)(BOOL success,id res))block {
    
    NSString* channelRequest = [[NSString alloc] init];
    for(ChannelModel* item in channels) {
        channelRequest = [channelRequest stringByAppendingFormat:@"channelIds[]=%ld&", item.identifier];
    }
    
    if([channelRequest length]) {
        channelRequest = [channelRequest substringToIndex:channelRequest.length - 1];
    }
    
    NSString* streamTypeRequest = [[NSString alloc] init];
    for(StreamTypeModel* item in streamTypes) {
        streamTypeRequest = [streamTypeRequest stringByAppendingFormat:@"streamTypeIds[]=%ld&", item.identifier];
    }
    
    if([streamTypeRequest length]) {
        streamTypeRequest = [streamTypeRequest substringToIndex:streamTypeRequest.length - 1];
    }
    
    NSString* startDateRequest;
    NSString* endDateRequest = [[NSDate date] getUTCString];
    if(dayType != DayFilterTypeNone) {
        startDateRequest = [[NSDate date] getStartDateString:dayType];
    }
    
    NSString* pageReq = [NSString stringWithFormat: API_STREAM_ME_PAGE, page];
    if(channelRequest.length) {
        pageReq = [pageReq stringByAppendingFormat:@"&%@", channelRequest];
    }
    
    if(streamTypeRequest.length) {
        pageReq = [pageReq stringByAppendingFormat:@"&%@", streamTypeRequest];
    }
    
    if(startDateRequest.length && endDateRequest.length) {
        pageReq = [pageReq stringByAppendingFormat:@"&dateStart=%@&dateEnd=%@", startDateRequest, endDateRequest];
    }
    
    pageReq = [pageReq stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self requestGetWithURL:[AppDelegate shared].apiBaseUrl atPath:pageReq withParams:nil withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void) getStreamTypes:(void(^)(BOOL success, id res)) block {
    [self requestGetWithURL:[AppDelegate shared].apiBaseUrl atPath:API_STREAM_TYPES withParams:nil withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void) generateStreamToken:(int) streamType
                   channels:(NSArray*) channels
                isEmergency:(BOOL) isEmergency
                deviceModel:(NSString*) deviceModel
           streamResolution:(StreamResolution) streamResolution
                      block:(void(^)(BOOL success, id res)) block {
    NSMutableArray* keys = [[NSMutableArray alloc] init];
    NSMutableArray* channelIds = [[NSMutableArray alloc] init];
    for(ChannelModel* item in channels) {
        NSLog(@"%@", item);
        [keys addObject:@"channelIds[]"];
        [channelIds addObject:[NSString stringWithFormat:@"%ld", item.identifier]];
    }
    
    NSString* resolution = @"Unknown";
    
    switch (streamResolution) {
        case StreamResolution288p:
            resolution = @"352 x 288";
            break;
        case StreamResolution480p:
            resolution = @"640 x 480";
            break;
        case StreamResolution720p:
            resolution = @"1280 x 720";
            break;
        case StreamResolution1080p:
            resolution = @"1920 x 1080";
            break;
        default:
            resolution = @"Unknown";
            break;
    }
    
    NSDictionary* param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSNumber numberWithInt:streamType], @"streamTypeId",
                           [NSNumber numberWithInt:isEmergency ? 1 : 0], @"is_emergency",
                           @"apple", @"deviceType",
                           resolution, @"resolution",
                           deviceModel, @"deviceName", nil];
    
    [self requestPostWithMultiPart:[AppDelegate shared].apiBaseUrl atPath:API_STREAM_TOKEN arrayValue:channelIds key:keys parameters:param withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void) getStreamVideo:(int) streamId block:(void(^)(BOOL success, id res)) block {
    [self requestGetWithURL:[AppDelegate shared].apiBaseUrl atPath:[NSString stringWithFormat: API_STREAM_VIDEO, streamId] withParams:nil withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

-(void)submitLocation:(double) latitude longitude:(double) longitude isEmergency:(BOOL) isEmergency streamName:(NSString*) streamname withCompletion:(void(^)(BOOL success,id res))block {
    
    NSMutableDictionary* paramDic = [[NSMutableDictionary alloc] init];
    NSNumber* latNum = [NSNumber numberWithDouble:latitude];
    NSNumber* lngNum = [NSNumber numberWithDouble:longitude];
    [paramDic setObject:latNum forKey:@"latitude"];
    [paramDic setObject:lngNum forKey:@"longitude"];
    
    if(isEmergency) {
        NSNumber* emergency = [NSNumber numberWithInt:isEmergency ? 1 : 0];
        [paramDic setObject:emergency forKey:@"is_emergency"];
    }
    
    if([streamname length]) {
        [paramDic setObject:streamname forKey:@"stream_name"];
    }
    
    [self requestPostWithURL: [AppDelegate shared].apiBaseUrl atPath:API_LOCATION withParams: paramDic withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}


#pragma mark - chat apis
-(void) generateTwilioAccessToken:(void(^)(BOOL success,id res))block {
    [self requestPostWithURL: [AppDelegate shared].apiBaseUrl atPath:API_CHAT_ACCESS_TOKEN withParams:nil withResponse:^(BOOL success, id res) {
        if (success) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:res options:0 error:nil];
            block(success, dict);
        }
        else {
            block(success, res);
        }
    }];
}

@end
