//
//  ChannelListCell.h
//  WWL
//
//  Created by Kristoffer Yap on 5/16/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwilioChatClient/TwilioChatClient.h>

@interface ChannelListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iv_channelLogo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_message;

- (void) configureCell:(TCHChannel*) channelInfo;

@end
