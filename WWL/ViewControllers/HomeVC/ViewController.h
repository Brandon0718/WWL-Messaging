//
//  ViewController.h
//  8a-ios
//
//  Created by Uncovered on 4/20/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface ViewController : BaseVC

@property (weak, nonatomic) IBOutlet UIButton *btn_report;
@property (weak, nonatomic) IBOutlet UIButton *btn_sos;
@property (weak, nonatomic) IBOutlet UISwitch *swt_location;

@end

