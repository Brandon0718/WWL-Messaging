//
//  ChannelManager.h
//  WWL
//
//  Created by Kristoffer Yap on 5/16/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TwilioChatClient/TwilioChatClient.h>
#import "ChannelListVC.h"
#import "PopupChannelListVC.h"

typedef void (^UnreadCallback)(NSUInteger unreadCount);

@interface ChannelManager : NSObject <TwilioChatClientDelegate>

@property (weak, nonatomic) ChannelListVC<TwilioChatClientDelegate> *delegate;
@property (weak, nonatomic) PopupChannelListVC<TwilioChatClientDelegate> *popupDelegate;

@property (strong, nonatomic) NSMutableOrderedSet *channels;
@property (strong, nonatomic) TCHChannels *channelsList;

+ (instancetype)sharedManager;

- (void)populateChannels;
- (void) getUnreadCount:(UnreadCallback) block;

@end
