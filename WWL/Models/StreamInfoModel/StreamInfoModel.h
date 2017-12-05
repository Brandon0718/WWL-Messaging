//
//  StreamInfoModel.h
//  8a-ios
//
//  Created by Kristoffer Yap on 5/2/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StreamInfoModel : NSObject

@property (nonatomic, strong) NSString* ipAddress;
@property (nonatomic, strong) NSString* recordUrl;
@property (nonatomic, strong) NSString* streamName;
@property (nonatomic, strong) NSString* token;

- (id)initWith: (NSDictionary *)dic;

@end
