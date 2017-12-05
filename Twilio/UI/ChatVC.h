//
//  ChatVC.h
//  WWL
//
//  Created by Kristoffer Yap on 5/16/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwilioChatClient/TwilioChatClient.h>
#import "SLKTextViewController.h"

@interface ChatVC : SLKTextViewController <TCHChannelDelegate>

@property (strong, nonatomic) TCHChannel *channel;

@end
