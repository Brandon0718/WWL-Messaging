//
//  FavoriteChannelCell.h
//  WWL
//
//  Created by Kristoffer Yap on 6/1/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelModel.h"

@interface FavoriteChannelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_channel;
@property (weak, nonatomic) IBOutlet UILabel *lbl_channelName;

-(void) configureCell:(ChannelModel*) item;

@end
