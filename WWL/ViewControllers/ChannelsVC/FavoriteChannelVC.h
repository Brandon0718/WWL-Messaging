//
//  FavoriteChannelVC.h
//  WWL
//
//  Created by Kristoffer Yap on 6/1/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRightBarButtonVC.h"

@interface FavoriteChannelVC : BaseRightBarButtonVC
@property (weak, nonatomic) IBOutlet UITableView *tbl_favorite;
@property (weak, nonatomic) IBOutlet UITableView *tbl_add;

@end
