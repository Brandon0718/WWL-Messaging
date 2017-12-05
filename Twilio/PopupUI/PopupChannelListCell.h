//
//  PopupChannelListCell.h
//  WWL
//
//  Created by Kristoffer Yap on 5/17/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupChannelListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_channelLogo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_channelName;

- (void) configureCell:(TCHChannel*) channelInfo;

@end
