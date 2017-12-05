//
//  OwnStreamModel.h
//  WWL
//
//  Created by Kristoffer Yap on 5/11/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StreamTypeModel.h"

@interface OwnStreamModel : NSObject

@property(nonatomic, assign) long       stream_id;
@property(nonatomic, strong) NSString*  streamName;
@property(nonatomic, strong) NSString*  status;
@property(nonatomic, strong) NSString*  thumbUrl;
@property(nonatomic, assign) double     longitude;
@property(nonatomic, assign) double     latitude;
@property(nonatomic, strong) NSString*  locationAddr;
@property(nonatomic, strong) NSString*  createdTime;
@property(nonatomic, strong) NSString*  duration;

@property(nonatomic, strong) StreamTypeModel*   streamType;
@property(nonatomic, strong) NSArray*   channels;

- (id)initWith: (NSDictionary *)data;

@end
