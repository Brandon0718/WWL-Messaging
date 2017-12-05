//
//  PopupChannelListVC.h
//  WWL
//
//  Created by Kristoffer Yap on 5/17/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopupChannelSelectedDelegate <NSObject>
-(void) channelSelected:(TCHChannel*) channel;
@end

@interface PopupChannelListVC : UIViewController <UITableViewDelegate, UITableViewDataSource, TwilioChatClientDelegate>

@property (nonatomic, weak) id<PopupChannelSelectedDelegate> channelSelectedDelegate;

@property (weak, nonatomic) IBOutlet UITableView *tbl_channelList;

- (void)reloadChannelList;

@end
