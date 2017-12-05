//
//  ChannelListVC.h
//  WWL
//
//  Created by Kristoffer Yap on 5/16/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwilioChatClient/TwilioChatClient.h>
#import "BaseVC.h"

@interface ChannelListVC : BaseVC <UITableViewDelegate, UITableViewDataSource, TwilioChatClientDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tbl_channelList;

- (void)reloadChannelList;

@end
