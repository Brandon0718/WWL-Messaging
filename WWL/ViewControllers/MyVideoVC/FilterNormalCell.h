//
//  FilterNormalCell.h
//  WWL
//
//  Created by Kristoffer Yap on 5/11/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DayFilterType) {
    DayFilterTypeNone = 0,
    DayFilterTypeLast7Days = 1,
    DayFilterTypeLast2Weeks = 2,
    DayFilterTypeLast1Month = 3,
    DayFilterTypeLast3Months = 4,
};

@interface FilterNormalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_title;

-(void) configureCell:(DayFilterType) itemType;

@end
