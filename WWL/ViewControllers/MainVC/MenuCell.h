//
//  MenuCell.h
//  WWL
//
//  Created by Kristoffer Yap on 5/21/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_icon;
@property (weak, nonatomic) IBOutlet UIImageView *iv_background;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *const_leftMarging;

@property (weak, nonatomic) IBOutlet UIView *seperatorView;

- (void) selectCell:(BOOL) isSelected;

@end
