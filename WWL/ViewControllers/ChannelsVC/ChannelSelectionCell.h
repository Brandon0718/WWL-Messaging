//
//  ChannelSelectionCell.h
//  WWL
//
//  Created by Kristoffer Yap on 6/1/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ChannelAddCellType) {
    ChannelAddCellTypeFavorite,
    ChannelAddCellTypeRecent,
    ChannelAddCellTypeNearBy,
    ChannelAddCellTypeSearch,
};

@interface ChannelSelectionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_item;
@property (weak, nonatomic) IBOutlet UIImageView *img_item;

-(void) configureCell:(ChannelAddCellType) type;

@end
