//
//  CountryItemCell.m
//  8a-ios
//
//  Created by Kristoffer Yap on 4/30/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "CountryItemCell.h"

@implementation CountryItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configure:(CountryModel*) countryModel {
    self.lbl_name.text = [NSString stringWithFormat:@"%@ (%@)", countryModel.name, countryModel.code];
    self.lbl_code.text = countryModel.phoneCode;
    self.img_flag.image = [UIImage imageNamed:[countryModel.code lowercaseString]];
}

@end
