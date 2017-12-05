//
//  PopupChatVC.h
//  WWL
//
//  Created by Kristoffer Yap on 5/17/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwilioChatClient/TwilioChatClient.h>
#import "SLKTextViewController.h"

@protocol PopupChatDelegate <NSObject>
-(void) PopupChatClosed;
@end

@interface PopupChatVC : SLKTextViewController <TCHChannelDelegate>

@property (nonatomic, weak) id<PopupChatDelegate> popupChatDelegate;
@property (strong, nonatomic) TCHChannel *channel;

-(void) onDone;

@end
