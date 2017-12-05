//
//  CountryCodeModalVC.h
//  8a-ios
//
//  Created by Kristoffer Yap on 4/30/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignInViewController.h"

@interface CountryCodeModalVC : UIViewController

@property (nonatomic, weak) id<CountrySelectedDelegate> selectedDelegate;

@property (weak, nonatomic) IBOutlet UIView *view_back;
@property (weak, nonatomic) IBOutlet UITextField *txt_search;
@property (weak, nonatomic) IBOutlet UITableView *tbl_country;

@end
