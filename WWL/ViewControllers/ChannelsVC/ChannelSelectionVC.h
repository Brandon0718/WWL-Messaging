//
//  ChannelSelectionVC.h
//  WWL
//
//  Created by Kristoffer Yap on 6/1/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagListView.h"
#import "BaseRightBarButtonVC.h"

@interface ChannelSelectionVC : BaseRightBarButtonVC

@property (weak, nonatomic) IBOutlet TagListView *view_channelTags;
@property (weak, nonatomic) IBOutlet UITableView *tbl_selectOptions;
@property (weak, nonatomic) IBOutlet UIButton *btn_report;
@property (weak, nonatomic) IBOutlet UIView *view_favoritePopup;
@property (weak, nonatomic) IBOutlet UIView *view_favoritePopupBack;

@property (weak, nonatomic) IBOutlet UIView *view_recommendBack;
@property (weak, nonatomic) IBOutlet UIView *view_recommendPopup;
@property (weak, nonatomic) IBOutlet UITableView *tbl_recommend;
@property (weak, nonatomic) IBOutlet UIButton *btn_recommnedReport;
@property (weak, nonatomic) IBOutlet UIButton *btn_recommnedSkip;
@property (weak, nonatomic) IBOutlet UILabel *lbl_recommendTitle;


@property (weak, nonatomic) IBOutlet UITableView *tbl_favoritePopup;
@property (weak, nonatomic) IBOutlet UIButton *btn_skipPopup;
@property (weak, nonatomic) IBOutlet UIButton *btn_favoritePopup;

@end
