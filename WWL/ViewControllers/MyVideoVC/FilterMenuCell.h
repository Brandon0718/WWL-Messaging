//
//  FilterMenuCell.h
//  WWL
//
//  Created by Kristoffer Yap on 5/10/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MyVideoFilterType) {
    MyVideoFilterTypeNone = 0,
    MyVideoFilterTypeChannels = 1,
    MyVideoFilterTypeNews = 2,
    MyVideoFilterTypeMap = 3,
    MyVideoFilterTypeLast7Days = 4,
    MyVideoFilterTypeLast2Weeks = 5,
    MyVideoFilterTypeLast1Month = 6,
    MyVideoFilterTypeLast3Months = 7,
};

@interface FilterMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;

-(void) configureCell:(MyVideoFilterType) itemType;

@end
