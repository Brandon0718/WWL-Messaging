//
//  ProfileFieldCell.h
//  8a-ios
//
//  Created by Kristoffer Yap on 4/26/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileModel.h"

#define ProfileFieldCellIdentifier @"ProfileFieldCellIdentifier"

@protocol ProfileUpdatedDelegate <NSObject>
-(void) profileFieldChanged:(NSInteger) row;
@end

@interface ProfileFieldCell : UITableViewCell

@property (nonatomic, weak) id<ProfileUpdatedDelegate> updatedDelegate;

@property (weak, nonatomic) IBOutlet UIImageView *iv_status;
@property (weak, nonatomic) IBOutlet UILabel *lbl_caption;
@property (weak, nonatomic) IBOutlet UITextView *tv_content;
@property (weak, nonatomic) IBOutlet UIImageView *img_content;
@property (weak, nonatomic) IBOutlet UITextField *txt_content;
@property (weak, nonatomic) IBOutlet UILabel *lbl_error;

@property (nonatomic, strong) UIViewController* vcInstance;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) ProfileModel* dataModel;

-(void) configureCell:(ProfileModel*) dataModel;
-(CGFloat) getHeight;

@end
