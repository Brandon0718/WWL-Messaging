//
//  MyService.h
//  8a-ios
//
//  Created by Mobile on 21/04/2017.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseService.h"
#import "ProfileModel.h"
#import "FilterNormalCell.h"
#import "ChannelModel.h"
#import "WWLEnum.h"
#import "WatchNewsFilterModel.h"

@interface MyService : BaseService

+ (MyService *)shared;

// Get Confirmation code by Phone Number
-(void)requestConfirmationCodeWithPhoneNum:(NSString *)phoneNum withCompletion:(void(^)(BOOL success,id res))block;

// Login
-(void)loginWithPhoneNum:(NSString *)phoneNum confirmationCode: (NSString *)code withCompletion:(void(^)(BOOL success,id res))block;

-(void)loginWithEmail:(NSString *)email password: (NSString *)password withCompletion:(void(^)(BOOL success,id res))block;

-(void)checkUserProfile:(void(^)(BOOL success))block;

// Get User Profile Fields
-(void) getUserProfileFields:(void(^)(BOOL success,id res))block;
-(void) getChannels:(void(^)(BOOL success, id res)) block;
-(void) getFavoriteChannelIds:(void(^)(BOOL success, id res)) block;
-(void) getFavoriteChannelObjects:(void(^)(BOOL success, id res)) block;
-(void) getNearbyChannels:(CLLocationCoordinate2D) userLocation callback:(void(^)(BOOL success, id res)) block;
-(void) getRecentChannels:(void(^)(BOOL success, id res)) block;

-(void) getChannelConnections:(void(^)(BOOL success, id res)) block;
-(void) insertChannelConnections:(NSArray*) channels block:(void(^)(BOOL success, id res)) block;
-(void) deleteChannelConnections:(ChannelModel*) channel block:(void(^)(BOOL success, id res)) block;

-(void) insertFavoriteChannels:(NSArray*) channels block:(void(^)(BOOL success, id res)) block;
-(void) deleteFavoriteChannel:(ChannelModel*) channel block:(void(^)(BOOL success, id res)) block;



-(void) getOwnStreams:(void(^)(BOOL success,id res))block;
-(void) getOwnStreamsForPage:(int) page
                  channelIds:(NSArray*) channels
               streamTypeIds:(NSArray*) streamTypes
                     dayType:(DayFilterType) dayType
                       block:(void(^)(BOOL success,id res))block;
-(void) getStreamTypes:(void(^)(BOOL success, id res)) block;
-(void) generateStreamToken:(int) streamType
                   channels:(NSArray*) channels
                isEmergency:(BOOL) isEmergency
                deviceModel:(NSString*) deviceModel
           streamResolution:(StreamResolution) streamResolution
                      block:(void(^)(BOOL success, id res)) block;

-(void) getVODStreams:(int) page
                param:(WatchNewsFilterModel*) filterParam
                block:(void (^)(BOOL, id))block;

// Update User Profile Field Data
-(void)updateUserProfileField:(ProfileModel*) dataModel completedBlock:(void(^)(BOOL success, id res)) block;

-(void)submitLocation:(double) latitude longitude:(double) longitude isEmergency:(BOOL) isEmergency streamName:(NSString*) streamname withCompletion:(void(^)(BOOL success,id res))block;

-(void) getStreamVideo:(int) streamId block:(void(^)(BOOL success, id res)) block;

// Chat Apis
-(void) generateTwilioAccessToken:(void(^)(BOOL success,id res))block;

@end
