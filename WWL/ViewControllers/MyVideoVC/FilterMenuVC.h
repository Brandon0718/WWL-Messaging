//
//  FilterMenuVC.h
//  WWL
//
//  Created by Kristoffer Yap on 5/10/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterMenuCell.h"

@protocol MyVideoFilterDelegate <NSObject>
-(void) myVideoFilterSelected:(MyVideoFilterType) filterType;
@end

@interface FilterMenuVC : UIViewController

@property (nonatomic, weak) id<MyVideoFilterDelegate> myVideoFilterDelegate;

@property (weak, nonatomic) IBOutlet UITableView *tbl_menu;

@property (nonatomic, assign) MyVideoFilterType selectedFilterType;

@end
