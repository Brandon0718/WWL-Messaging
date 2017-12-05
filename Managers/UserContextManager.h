//
//  UserContextManager.h
//  WWL
//
//  Created by Kristoffer Yap on 6/1/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WatchNewsFilterModel.h"

typedef enum : NSUInteger {
    StreamRecordOptionWeb,
    StreamRecordOptionPhone,
} StreamRecordOption;

@interface UserContextManager : NSObject

DEFINE_SINGLETON

/**
 * user default keys
 */
#define STREAM_RESOLUTION               @"stream_resolution"
#define STREAM_RECORD_OPTION            @"stream_recod_option"
#define LOCATION_SHARING                @"location_sharing"

#define VOD_FILTER_OPTION                @"vod_filter_option"

@property (nonatomic, assign) NSInteger streamResolution;
@property (nonatomic, assign) NSInteger streamRecordOption;
@property (nonatomic, assign) BOOL      locationSharing;
@property (nonatomic, strong) WatchNewsFilterModel* vodFilterOption;

- (void)cleanUserDefaults;

@end
