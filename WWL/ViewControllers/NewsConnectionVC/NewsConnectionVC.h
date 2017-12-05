//
//  NewsConnectionVC.h
//  WWL
//
//  Created by Kristoffer Yap on 6/5/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRightBarButtonVC.h"

@interface NewsConnectionVC : BaseRightBarButtonVC

@property (weak, nonatomic) IBOutlet UITableView *tbl_newsConnection;
@property (weak, nonatomic) IBOutlet UITableView *tbl_add;

@end
