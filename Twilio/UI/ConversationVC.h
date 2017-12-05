//
//  ConversationVC.h
//  WWL
//
//  Created by Kristoffer Yap on 5/19/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessages.h"
#import <TwilioChatClient/TwilioChatClient.h>

@interface ConversationVC : JSQMessagesViewController <UIActionSheetDelegate, JSQMessagesComposerTextViewPasteDelegate, TCHChannelDelegate>

@property (strong, nonatomic) TCHChannel *channel;

@end
