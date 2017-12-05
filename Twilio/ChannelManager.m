//
//  ChannelManager.m
//  WWL
//
//  Created by Kristoffer Yap on 5/16/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "ChannelManager.h"

static NSString * const TWCFriendlyNameKey = @"friendlyName";

@interface ChannelManager()
{
    UnreadCallback unreadCallback;
}

@end

@implementation ChannelManager

+ (instancetype)sharedManager {
    static ChannelManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (instancetype)init {
    self.channels = [[NSMutableOrderedSet alloc] init];
    unreadCallback = nil;
    return self;
}

#pragma mark Populate channels

- (void)populateChannels {
    self.channels = [[NSMutableOrderedSet alloc] init];
    [self.channelsList userChannelsWithCompletion:^(TCHResult *result,
                                                    TCHChannelPaginator *channelPaginator) {
        [self.channels addObjectsFromArray:[channelPaginator items]];
        [self calUnreadCount:unreadCallback];
        
        [self sortAndDedupeChannels];
        if (self.delegate) {
            [self.delegate reloadChannelList];
        }
        
        if(self.popupDelegate) {
            [self.popupDelegate reloadChannelList];
        }
    }];
    
    [self.channelsList publicChannelsWithCompletion:^(TCHResult *result,
                                                      TCHChannelDescriptorPaginator *channelDescPaginator) {
        [self.channels addObjectsFromArray: [channelDescPaginator items]];
        [self sortAndDedupeChannels];
        if (self.delegate) {
            [self.delegate reloadChannelList];
        }
        
        if(self.popupDelegate) {
            [self.popupDelegate reloadChannelList];
        }
    }];
}

- (void)sortAndDedupeChannels {
    NSMutableDictionary *channelsDict = [[NSMutableDictionary alloc] init];
    
    for(TCHChannel *channel in self.channels) {
        if (![channelsDict objectForKey: channel.sid] ||
            ![[channelsDict objectForKey: channel.sid] isKindOfClass: [NSNull class]]) {
            [channelsDict setObject:channel forKey:channel.sid];
        }
    }
    
    NSMutableOrderedSet *dedupedChannels = [NSMutableOrderedSet
                                            orderedSetWithArray:[channelsDict allValues]];
    
    SEL sortSelector = @selector(localizedCaseInsensitiveCompare:);
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:TWCFriendlyNameKey
                                                               ascending:YES
                                                                selector:sortSelector];
    
    [dedupedChannels sortUsingDescriptors:@[descriptor]];
    
    self.channels = dedupedChannels;
}

- (void) getUnreadCount:(UnreadCallback) block {
    if([MessagingManager sharedManager].client.synchronizationStatus < TCHClientSynchronizationStatusCompleted) {
        unreadCallback = block;
    } else {
        unreadCallback = nil;
        [self calUnreadCount:block];
    }
}

- (void) calUnreadCount:(UnreadCallback)block {
    for(TCHChannel* item in self.channels) {
        [item getUnconsumedMessagesCountWithCompletion:^(TCHResult *result, NSUInteger count) {
            if(block) {
                block(count);
                unreadCallback = nil;
            }
        }];
    }
}

# pragma mark TwilioChatClientDelegate

-(void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel messageAdded:(TCHMessage *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate chatClient:client channel:channel messageAdded:message];
        [self.popupDelegate chatClient:client channel:channel messageAdded:message];
    });
}

- (void)chatClient:(TwilioChatClient *)client channelAdded:(TCHChannel *)channel{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channels addObject:channel];
        [self sortAndDedupeChannels];
        [self.delegate chatClient:client channelAdded:channel];
        [self.popupDelegate chatClient:client channelAdded:channel];
    });
}

- (void)chatClient:(TwilioChatClient *)client channelChanged:(TCHChannel *)channel {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate chatClient:client channelChanged:channel];
        [self.popupDelegate chatClient:client channelAdded:channel];
    });
}

- (void)chatClient:(TwilioChatClient *)client channelDeleted:(TCHChannel *)channel {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[ChannelManager sharedManager].channels removeObject:channel];
        [self.delegate chatClient:client channelDeleted:channel];
        [self.popupDelegate chatClient:client channelAdded:channel];
    });
}

-(void)chatClient:(TwilioChatClient *)client synchronizationStatusChanged:(TCHClientSynchronizationStatus)status {
    [self.delegate chatClient:client synchronizationStatusChanged:status];
}

@end
