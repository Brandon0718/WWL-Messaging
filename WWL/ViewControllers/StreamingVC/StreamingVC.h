//
//  StreamingVC.h
//  8a-ios
//
//  Created by Kristoffer Yap on 4/28/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "StreamInfoModel.h"
#import "StreamTypeModel.h"

@protocol StreamEndedDelegate <NSObject>

- (void) channelStreamEnded:(NSArray*) channels;

@end

typedef NS_ENUM(NSInteger, StreamMode) {
    StreamModeNormal,
    StreamModeEmergency,
};

typedef NS_ENUM(NSInteger, EmergencyCallStatus) {
    EmergencyCallStatusNone,
    EmergencyCallStatusCalling,
    EmergencyCallStatusAccept,
};

@interface StreamingVC : BaseVC

@property (weak, nonatomic) id<StreamEndedDelegate> streamDelegate;
@property (weak, nonatomic) IBOutlet UIButton *btn_backOrient;

@property (weak, nonatomic) IBOutlet UIButton *btn_back;
@property (weak, nonatomic) IBOutlet UIButton *btn_record;
@property (weak, nonatomic) IBOutlet UIView *view_types;
@property (weak, nonatomic) IBOutlet UICollectionView *cv_types;
@property (weak, nonatomic) IBOutlet UIView *view_chat;
@property (weak, nonatomic) IBOutlet UILabel *lbl_chat_unread;
@property (weak, nonatomic) IBOutlet UIView *view_recording;
@property (weak, nonatomic) IBOutlet UIView *view_rotateWarning;
@property (weak, nonatomic) IBOutlet UIImageView *img_rotateWarning;
@property (weak, nonatomic) IBOutlet UIView *view_rotateDesc;
@property (weak, nonatomic) IBOutlet UIButton *btn_setting;
@property (weak, nonatomic) IBOutlet UIView *view_setting;
@property (weak, nonatomic) IBOutlet UITableView *tbl_setting;
@property (weak, nonatomic) IBOutlet UIView *view_settingBack;
@property (weak, nonatomic) IBOutlet UILabel *lbl_streamNotice;

@property (weak, nonatomic) IBOutlet UIView *view_streamRecordOption;
@property (weak, nonatomic) IBOutlet UITableView *tbl_streamRecordOption;


@property (nonatomic, strong) StreamInfoModel* data;
@property (nonatomic, strong) NSArray* types;
@property (nonatomic, strong) NSArray* selectedChannels;
@property (nonatomic, assign) StreamMode mode;

@end
