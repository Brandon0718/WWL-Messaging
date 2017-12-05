//
//  UserContextManager.m
//  WWL
//
//  Created by Kristoffer Yap on 6/1/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "UserContextManager.h"

@implementation UserContextManager

static UserContextManager *sharedInstance = nil;

+ (id)sharedInstance {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[UserContextManager alloc] init];
        }
        return sharedInstance;
    }
}

+ (void)resetSharedInstance {
    @synchronized(self) {
        sharedInstance = nil;
    }
}

- (id)init {
    self = [super init];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSObject *obj = [userDefaults objectForKey:STREAM_RESOLUTION];
    if (obj != nil) {
        _streamResolution = [(NSString *)obj integerValue];
    } else {
        _streamResolution = StreamResolution480p;
    }
    
    obj = [userDefaults objectForKey:STREAM_RECORD_OPTION];
    if (obj != nil) {
        _streamRecordOption = [(NSString *)obj integerValue];
    } else {
        _streamRecordOption = StreamRecordOptionWeb;
    }
    
    obj = [userDefaults objectForKey:LOCATION_SHARING];
    if (obj != nil) {
        _locationSharing = [(NSString *)obj boolValue];
    } else {
        _locationSharing = YES;
    }
    
    obj = [userDefaults objectForKey:VOD_FILTER_OPTION];
    if (obj != nil) {
        _vodFilterOption = [NSKeyedUnarchiver unarchiveObjectWithData:(NSData*)obj];
    } else {
        _vodFilterOption = [[WatchNewsFilterModel alloc] initWithDefault];
    }
    
    return self;
}

-(void)cleanUserDefaults {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:STREAM_RESOLUTION];
    [userDefaults removeObjectForKey:STREAM_RECORD_OPTION];
    [userDefaults removeObjectForKey:VOD_FILTER_OPTION];
}

-(void)setStreamResolution:(NSInteger)streamResolution {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _streamResolution = streamResolution;
    [userDefaults setObject:[NSNumber numberWithInteger:streamResolution] forKey:STREAM_RESOLUTION];
    [userDefaults synchronize];
}

-(void)setStreamRecordOption:(NSInteger)streamRecordOption {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _streamRecordOption = streamRecordOption;
    [userDefaults setObject:[NSNumber numberWithInteger:streamRecordOption] forKey:STREAM_RECORD_OPTION];
    [userDefaults synchronize];
}

-(void)setLocationSharing:(BOOL)locationSharing {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _locationSharing = locationSharing;
    [userDefaults setObject:[NSNumber numberWithBool:locationSharing] forKey:LOCATION_SHARING];
    [userDefaults synchronize];
}

-(void)setVodFilterOption:(WatchNewsFilterModel *)vodFilterOption {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _vodFilterOption = vodFilterOption;
    NSData* encodedObject = [NSKeyedArchiver archivedDataWithRootObject:vodFilterOption];
    [userDefaults setObject:encodedObject forKey:VOD_FILTER_OPTION];
    [userDefaults synchronize];
}

@end
