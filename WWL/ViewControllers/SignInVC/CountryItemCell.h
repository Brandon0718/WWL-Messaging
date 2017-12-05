//
//  CountryItemCell.h
//  8a-ios
//
//  Created by Kristoffer Yap on 4/30/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CountryModel.h"

@interface CountryItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_name;
@property (weak, nonatomic) IBOutlet UIImageView *img_flag;
@property (weak, nonatomic) IBOutlet UILabel *lbl_code;

- (void)configure:(CountryModel*) countryModel;

@end
