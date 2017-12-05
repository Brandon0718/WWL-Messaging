//
//  MessagingManager.m
//  WWL
//
//  Created by Kristoffer Yap on 5/16/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "MessagingManager.h"


@interface MessagingManager ()
@property (strong, nonatomic) TwilioChatClient *client;
@property (nonatomic, getter=isConnected) BOOL connected;
@end

@implementation MessagingManager

+ (instancetype)sharedManager {
    static MessagingManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init {
    self.delegate = [ChannelManager sharedManager];
    return self;
}


# pragma mark Twilio Client

- (void)initializeClientWithToken:(NSString *)token{
    TwilioChatClientProperties* properties = [[TwilioChatClientProperties alloc] init];
    properties.synchronizationStrategy = TCHClientSynchronizationStrategyAll;
    
    [TwilioChatClient setLogLevel:TCHLogLevelFatal];
    
    self.client = [TwilioChatClient chatClientWithToken:token properties:properties delegate:self];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.connected = YES;
}

#pragma mark TwilioChatClientDelegate

- (void) chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel messageAdded:(TCHMessage *)message {
    if(self.messageDelegate) {
        TwilioUserModel* userInfo = [[TwilioUserModel alloc] initWithMessage:message channel:channel];
        [self.messageDelegate messageAdded:message.body userInfo:userInfo];
    }
    
    [self.delegate chatClient:client channel:channel messageAdded:message];
    
    NSLog(@"Kristoffer NOTE: message added:%@", message.body);
}

- (void)chatClient:(TwilioChatClient *)client channelAdded:(TCHChannel *)channel {
    [self.delegate chatClient:client channelAdded:channel];
}

- (void)chatClient:(TwilioChatClient *)client channelChanged:(TCHChannel *)channel {
    [self.delegate chatClient:client channelChanged:channel];
}

- (void)chatClient:(TwilioChatClient *)client channelDeleted:(TCHChannel *)channel {
    [self.delegate chatClient:client channelDeleted:channel];
}

-(void)chatClient:(TwilioChatClient *)client synchronizationStatusChanged:(TCHClientSynchronizationStatus)status {
    if (status == TCHClientSynchronizationStatusCompleted) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [ChannelManager sharedManager].channelsList = client.channelsList;
        
        [[ChannelManager sharedManager] populateChannels];
    }
    [self.delegate chatClient:client synchronizationStatusChanged:status];
    
    if(self.messageDelegate) {
        [self.messageDelegate messageManagerStatusUpdated:status];
    }
}

-(void)chatClient:(TwilioChatClient *)client userInfo:(TCHUserInfo *)userInfo updated:(TCHUserInfoUpdate)updated {
    NSLog(@"%@, %@", userInfo.identity, userInfo.attributes);
}

@end
