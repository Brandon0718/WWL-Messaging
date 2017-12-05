//
//  FavoriteChannelCell.m
//  WWL
//
//  Created by Kristoffer Yap on 6/1/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "FavoriteChannelCell.h"

@implementation FavoriteChannelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configureCell:(ChannelModel*) item {
    self.img_channel.layer.borderColor = [[UIColor barTintColor] CGColor];
    self.img_channel.layer.borderWidth = 1.0f;
    self.img_channel.layer.cornerRadius = 3.0f;
    
    self.lbl_channelName.text = item.name;
    if([item.thumbUrl length]) {
        [self.img_channel sd_setImageWithURL:[item.thumbUrl getImageURL]
                               placeholderImage:[UIImage imageNamed:@"img_default_channel"]
                                        options:SDWebImageRefreshCached];
    }
}

@end
