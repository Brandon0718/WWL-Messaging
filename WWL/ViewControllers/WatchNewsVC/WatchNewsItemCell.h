//
//  WatchNewsItemCell.h
//  WWL
//
//  Created by Kristoffer Yap on 6/22/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OwnStreamModel.h"

@interface WatchNewsItemCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *view_background;
@property (weak, nonatomic) IBOutlet UIImageView *img_thumb;
@property (weak, nonatomic) IBOutlet UIView *view_gradient;
@property (weak, nonatomic) IBOutlet UILabel *lbl_duration;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;
@property (weak, nonatomic) IBOutlet UIImageView *img_news_type;
@property (weak, nonatomic) IBOutlet UIView *view_channels;
@property (weak, nonatomic) IBOutlet UILabel *lbl_location;

-(void) configureCell:(OwnStreamModel*) item;

@end
