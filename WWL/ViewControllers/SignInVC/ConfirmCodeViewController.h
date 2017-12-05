//
//  ConfirmCodeViewController.h
//  8a-ios
//
//  Created by Mobile on 21/04/2017.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface ConfirmCodeViewController : BaseVC

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (weak, nonatomic) IBOutlet UIButton *btn_first;
@property (weak, nonatomic) IBOutlet UIButton *btn_second;
@property (weak, nonatomic) IBOutlet UIButton *btn_third;
@property (weak, nonatomic) IBOutlet UIButton *btn_fourth;
@property (weak, nonatomic) IBOutlet UIButton *btn_five;
@property (weak, nonatomic) IBOutlet UIButton *btn_six;
@property (weak, nonatomic) IBOutlet UITextField *txt_code;

@property (weak, nonatomic) IBOutlet UIButton *btn_back;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons_bottom;


- (void)setPhoneNumber: (NSString *)sender;

@end
