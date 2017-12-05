//
//  BaseService.h
//  8a-ios
//
//  Created by Mobile on 21/04/2017.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "APIConfig.h"

#define WWL_ERROR_CODE              400
#define WWL_UNAUTHROIZED_CODE       401
#define WWL_ERROR_DOMAIN    @"WWLNetworkError"

@interface BaseService : NSObject

@property(nonatomic, strong) NSString* token;

+(BaseService *)shared;

- (void)requestGetWithURL:(NSString *)url atPath:(NSString *)path withParams:(NSDictionary *)params withResponse:(void(^)(BOOL success,id res))block;
- (void)requestPostWithURL:(NSString *)url atPath:(NSString *)path withParams:(NSDictionary *)params withResponse:(void(^)(BOOL success,id res))block;
- (void)requestDeleteWithURL:(NSString *)url atPath:(NSString *)path withParams:(NSDictionary *)params withResponse:(void(^)(BOOL success,id res))block;
- (void)requestPutWithURL:(NSString *)url atPath:(NSString *)path withParams:(NSDictionary *)params  withResponse:(void(^)(BOOL success,id res))block;

// multi-part
-(void)requestPostWithMultiPart:(NSString*) url
                         atPath:(NSString *)path
                     arrayValue:(NSArray*) arrays
                            key:(NSArray*) keys
                     parameters:(NSDictionary*) params
                   withResponse:(void(^)(BOOL success,id res))block;

-(void)requestPostWithMultiPartData:(NSString*) url
                             atPath:(NSString *)path
                               data:(NSData*) data
                                key:(NSString*) key
                             isFile:(BOOL) isFile
                              param:(NSDictionary*) param
                       withResponse:(void(^)(BOOL success,id res))block;
@end
