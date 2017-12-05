//
//  FilterMenuCell.m
//  WWL
//
//  Created by Kristoffer Yap on 5/10/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "FilterMenuCell.h"

@implementation FilterMenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configureCell:(MyVideoFilterType) itemType {
    switch (itemType) {
        case MyVideoFilterTypeNone:
            self.lbl_title.text = @"No Filter";
            break;
        case MyVideoFilterTypeChannels:
            self.lbl_title.text = @"Channels";
            break;
        case MyVideoFilterTypeNews:
            self.lbl_title.text = @"News Type";
            break;
        case MyVideoFilterTypeMap:
            self.lbl_title.text = @"Map View";
            break;
        case MyVideoFilterTypeLast7Days:
            self.lbl_title.text = @"Last 7 Days";
            break;
        case MyVideoFilterTypeLast2Weeks:
            self.lbl_title.text = @"Last 2 Weeks";
            break;
        case MyVideoFilterTypeLast1Month:
            self.lbl_title.text = @"Last A Month";
            break;
        case MyVideoFilterTypeLast3Months:
            self.lbl_title.text = @"Last 3 Months";
            break;
        default:
            break;
    }
}

@end
