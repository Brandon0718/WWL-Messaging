//
//  WatchNewsFilterVC.h
//  WWL
//
//  Created by Kristoffer Yap on 6/21/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatchNewsFilterVC : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *txt_search;
@property (weak, nonatomic) IBOutlet UILabel *lbl_sortBy;
@property (weak, nonatomic) IBOutlet UILabel *lbl_location;
@property (weak, nonatomic) IBOutlet UITextField *txt_stringer;
@property (weak, nonatomic) IBOutlet UIButton *btn_date_start;
@property (weak, nonatomic) IBOutlet UIButton *btn_date_end;
@property (weak, nonatomic) IBOutlet UIButton *btn_source;
@property (weak, nonatomic) IBOutlet UIButton *btn_news_type;
@property (weak, nonatomic) IBOutlet UILabel *lbl_news_type;
@property (weak, nonatomic) IBOutlet UILabel *lbl_source;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date_end;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date_start;

@end
