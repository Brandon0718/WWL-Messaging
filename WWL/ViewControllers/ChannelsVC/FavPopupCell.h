//
//  FavPopupCell.h
//  WWL
//
//  Created by Kristoffer Yap on 6/2/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelModel.h"

@interface FavPopupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UIImageView *img_logo;

- (void) configureCell:(ChannelModel*) data;

@end
