//
//  ProfileViewController.h
//  8a-ios
//
//  Created by Mobile on 21/04/2017.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface ProfileViewController : BaseVC

@property (weak, nonatomic) IBOutlet UITableView *tbl_profileFields;
@property (weak, nonatomic) IBOutlet UIButton *btn_logout;
@property (weak, nonatomic) IBOutlet UIButton *btn_continue;

@property (assign, nonatomic) ProfileMotivationType motivationType;

@end
