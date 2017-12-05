//
//  FilterLogoCell.h
//  WWL
//
//  Created by Kristoffer Yap on 5/11/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelModel.h"
#import "StreamTypeModel.h"

@interface FilterLogoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iv_logo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;

@property (nonatomic, assign) BOOL isChannel;
@property (nonatomic, strong) ChannelModel* channel;
@property (nonatomic, strong) StreamTypeModel* newsType;

- (void) configureCell:(ChannelModel*) model;
- (void) configureCellForNews:(StreamTypeModel*) model;
@end
