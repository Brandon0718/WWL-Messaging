//
//  ChannelSelectionCell.m
//  WWL
//
//  Created by Kristoffer Yap on 6/1/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "ChannelSelectionCell.h"

@implementation ChannelSelectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configureCell:(ChannelAddCellType) type {
    switch (type) {
        case ChannelAddCellTypeFavorite:
            self.lbl_item.text = @"Favorites";
            self.img_item.image = [UIImage imageNamed:@"icon_menu_favorite"];
            break;
        case ChannelAddCellTypeRecent:
            self.lbl_item.text = @"Recently Used";
            self.img_item.image = [UIImage imageNamed:@"icon_recent"];
            break;
        case ChannelAddCellTypeNearBy:
            self.lbl_item.text = @"Near By";
            self.img_item.image = [UIImage imageNamed:@"icon_menu_map"];
            break;
        case ChannelAddCellTypeSearch:
            self.lbl_item.text = @"Search";
            self.img_item.image = [UIImage imageNamed:@"icon_search"];
            break;
        default:
            break;
    }
}

@end
