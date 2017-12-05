//  NewsTypeCell.h
//  8a-ios
//
//  Created by Kristoffer Yap on 5/2/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StreamTypeModel.h"

@interface NewsTypeCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img_back;


-(void) configureCell:(StreamTypeModel*) data;
-(void) selectCell:(BOOL) isSelect;

@end
