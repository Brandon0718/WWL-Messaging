//
//  SignInViewController.h
//  8a-ios
//
//  Created by Mobile on 21/04/2017.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "CountryModel.h"

@protocol CountrySelectedDelegate <NSObject>
-(void) countrySelected:(CountryModel*) selectedCountry;
@end

@interface SignInViewController : BaseVC

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UIView *view_phoneBack;
@property (weak, nonatomic) IBOutlet UIView *view_countryBack;
@property (weak, nonatomic) IBOutlet UIImageView *img_country;
@property (weak, nonatomic) IBOutlet UILabel *lbl_country;
@property (weak, nonatomic) IBOutlet UIButton *btn_confirm;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cons_bottom;
@property (weak, nonatomic) IBOutlet UILabel *lbl_error;

@end
