//
//  MessagingManager.h
//  WWL
//
//  Created by Kristoffer Yap on 5/16/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TwilioChatClient/TwilioChatClient.h>
#import <TwilioAccessManager/TwilioAccessManager.h>
#import "ChannelManager.h"
#import "TwilioUserModel.h"

#define CHAT_VOICE_CALLING          @"::VOICE_CALLING::"

#define CHAT_VOICE_ACCEPT           @"::VOICE_ACCEPT::"
#define CHAT_VOICE_DENY             @"::VOICE_DENY::"
#define CHAT_VOICE_END              @"::VOICE_END::"
#define CHAT_VOICE_END_ME           @"::VOICE_END_ME::"

@protocol NewMessageDelegate <NSObject>

- (void) messageAdded:(NSString*) message userInfo:(TwilioUserModel*) userInfo;
- (void) messageManagerStatusUpdated:(TCHClientSynchronizationStatus) status;

@end

@interface MessagingManager : NSObject <TwilioAccessManagerDelegate, TwilioChatClientDelegate>

@property (weak, nonatomic) id<NewMessageDelegate> messageDelegate;
@property (strong, nonatomic, readonly) TwilioChatClient *client;
@property (nonatomic, readonly) BOOL isLoggedIn;
@property (weak, nonatomic) ChannelManager<TwilioChatClientDelegate> *delegate;

+ (instancetype)sharedManager;
- (void)initializeClientWithToken:(NSString *)token;

@end
