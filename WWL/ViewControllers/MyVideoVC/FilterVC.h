//
//  FilterVC.h
//  WWL
//
//  Created by Kristoffer Yap on 5/11/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterVC : UIViewController

@property (nonatomic, strong) NSArray* mChannels;
@property (nonatomic, strong) NSArray* mNewsTypes;
@property (weak, nonatomic) IBOutlet UITableView *tbl_filters;

@end
