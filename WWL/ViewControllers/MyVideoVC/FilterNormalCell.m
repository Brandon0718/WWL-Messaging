//
//  FilterNormalCell.m
//  WWL
//
//  Created by Kristoffer Yap on 5/11/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "FilterNormalCell.h"

@implementation FilterNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) configureCell:(DayFilterType) itemType {
    switch (itemType) {
        case DayFilterTypeNone:
            self.lbl_title.text = @"All days";
            break;
        case DayFilterTypeLast7Days:
            self.lbl_title.text = @"Last 7 days";
            break;
        case DayFilterTypeLast2Weeks:
            self.lbl_title.text = @"Last 2 weeks";
            break;
        case DayFilterTypeLast1Month:
            self.lbl_title.text = @"Last a month";
            break;
        case DayFilterTypeLast3Months:
            self.lbl_title.text = @"Last 3 months";
            break;
        default:
            break;
    }
}

@end
