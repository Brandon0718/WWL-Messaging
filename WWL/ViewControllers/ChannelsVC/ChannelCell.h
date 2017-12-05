//
//  ChannelCell.h
//  8a-ios
//
//  Created by Kristoffer Yap on 4/28/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelModel.h"

@interface ChannelCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UIImageView *iv_logo;
@property (weak, nonatomic) IBOutlet UIView *view_fore;

- (void) configureCell:(ChannelModel*) data;
- (void) selectCell:(BOOL) isSelected;

@end
