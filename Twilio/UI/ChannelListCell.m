
//
//  ChannelListCell.m
//  WWL
//
//  Created by Kristoffer Yap on 5/16/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "ChannelListCell.h"
#import "UIColor+WWLColor.h"
#import "TwilioUserModel.h"
#import "TwilioChannelInfo.h"

@implementation ChannelListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCell:(TCHChannel*) channelInfo {
    self.iv_channelLogo.layer.borderColor = [[UIColor barTintColor] CGColor];
    self.iv_channelLogo.layer.borderWidth = 1.0f;
    self.iv_channelLogo.layer.cornerRadius = 3.0f;
    
    TwilioChannelInfo* info = [[TwilioChannelInfo alloc] initWithChannel:channelInfo];
    self.lbl_message.text = info.name;
    if([info.logoURL length]) {
        [self.iv_channelLogo sd_setImageWithURL:[info.logoURL getImageURL]
                         placeholderImage:[UIImage imageNamed:@"img_default_channel"]
                                  options:SDWebImageRefreshCached];
    }
    
    [channelInfo.members membersWithCompletion:^(TCHResult *result, TCHMemberPaginator *paginator) {
        if([result isSuccessful]) {
            for(TCHMember* member in paginator.items) {
                NSLog(@"User Identity:%@, UserAttributes:%@", member.userInfo.identity, member.userInfo.attributes);
            }
        }
    }];
    
    int lastConsumedIndex = [[channelInfo.messages lastConsumedMessageIndex] intValue];
    [channelInfo.messages getLastMessagesWithCount:1 completion:^(TCHResult *result, NSArray<TCHMessage *> *messages)
    {
        if([result isSuccessful] && [messages count] > 0) {
            TCHMessage* message = [messages objectAtIndex:0];
            TwilioUserModel* userModel = [[TwilioUserModel alloc] initWithMessage:message channel:channelInfo];
            
            int messageIndex = [message.index intValue];
            int unreadCount = messageIndex - lastConsumedIndex;
            
            if(unreadCount) {
                self.lbl_message.font = [UIFont boldSystemFontOfSize:15.0f];
            } else {
                self.lbl_message.font = [UIFont systemFontOfSize:14.0f];
            }
            
            self.lbl_message.text = [NSString stringWithFormat:@"%@: %@", userModel.name, message.body];
        }
    }];
}

@end
