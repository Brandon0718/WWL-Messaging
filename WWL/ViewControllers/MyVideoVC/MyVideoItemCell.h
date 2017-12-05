//
//  MyVideoItemCell.h
//  WWL
//
//  Created by Kristoffer Yap on 5/10/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OwnStreamModel.h"

@interface MyVideoItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *view_background;
@property (weak, nonatomic) IBOutlet UIImageView *iv_thumb;

@property (weak, nonatomic) IBOutlet UILabel *lbl_location;
@property (weak, nonatomic) IBOutlet UIImageView *img_newsType;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;
@property (weak, nonatomic) IBOutlet UIView *view_channels;

@property (weak, nonatomic) IBOutlet UIView *view_gradient;
@property (weak, nonatomic) IBOutlet UILabel *lbl_duration;


-(void) configureCell:(OwnStreamModel*) item;

@end
