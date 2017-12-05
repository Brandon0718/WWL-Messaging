//
//  SignInViewController.m
//  8a-ios
//
//  Created by Mobile on 21/04/2017.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "SignInViewController.h"
#import "ConfirmCodeViewController.h"
#import "ChannelsVC.h"
#import "ChannelModel.h"
#import "CountryCodeModalVC.h"
#import "UIButton+Border.h"
#import "NBAsYouTypeFormatter.h"
#import "NBPhoneNumber.h"
#import "NBPhoneNumberUtil.h"

@interface SignInViewController () <CountrySelectedDelegate>
{
    BOOL isFirstMove;
    BOOL movedUp;
    CountryModel* countryInfo;
}
@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCountryPicker)];
    [self.view_countryBack addGestureRecognizer:tapGesture];
    
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    
    countryInfo = [[CountryModel alloc] initWith:@"US" name:@"United States" phoneCode:@"+1"];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Login";
    self.navigationController.navigationBarHidden = NO;
    
    self.view_phoneBack.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.view_phoneBack.layer.borderWidth = 1.0f;
    self.view_phoneBack.layer.cornerRadius = 3.0f;
    
    [self.lbl_error setHidden:YES];
    
    [self.btn_confirm customBorder];
    
    // register keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    isFirstMove = YES;
    [self.phoneNumTF becomeFirstResponder];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // unregister keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButon Actions

- (void) showCountryPicker {
    CountryCodeModalVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CountryCodeModalVC"];
//    [vc showInView:self.view animated:YES];
    vc.providesPresentationContextTransitionStyle = YES;
    vc.definesPresentationContext = YES;
    [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    vc.selectedDelegate = self;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

-(void)countrySelected:(CountryModel *)selectedCountry {
    countryInfo = selectedCountry;
    self.lbl_country.text = [NSString stringWithFormat:@"(%@) %@", selectedCountry.code, selectedCountry.phoneCode];
    self.img_country.image = [UIImage imageNamed:[selectedCountry.code lowercaseString]];
}

- (IBAction)onPhoneNumberChanged:(id)sender {
    [self.lbl_error setHidden:YES];
}

- (IBAction)getConfirmationCodeTouchUp:(UIButton *)sender {
    NSString *phoneNum = [self.phoneNumTF text];
    phoneNum = [NSString stringWithFormat:@"%@%@", countryInfo.phoneCode, phoneNum];
    
    NSString* errorMsg = [self validatePhonenumber:phoneNum];
    if ([errorMsg length]) {
        self.lbl_error.text = errorMsg;
        [self.lbl_error setHidden:NO];
        return;
    }
    
    [self showConfirmCodeVC:phoneNum];
    
    [[MyService shared] requestConfirmationCodeWithPhoneNum:phoneNum withCompletion:^(BOOL success, id res) {
        if (success) {
            if ([res[@"status"] isEqualToString:@"ok"]) {
            } else {
                NSLog(@"Request Code Response Status: %@", res[@"status"]);
            }
        }else {
            NSError* err = (NSError*)res;
            [self showAlertWithTitle:@"Error" message:err.localizedDescription];
            NSLog(@"%@", [err localizedDescription]);
        }
    }];
}

-(NSString*) validatePhonenumber:(NSString*) phoneNumber {
    NBPhoneNumberUtil* phoneUtil = [[NBPhoneNumberUtil alloc] init];
    NSError* error = nil;
    NBPhoneNumber* number = [phoneUtil parse:phoneNumber defaultRegion:countryInfo.code error:&error];
    if(error) {
        return @"Please input a valid phonenumber.";
    } else {
        if([phoneUtil isValidNumber:number]) {
            return nil;
        } else {
            return @"Please input a valid phonenumber.";
        }
    }
}

#pragma mark - Custom Methods

- (void)showConfirmCodeVC: (NSString *)phoneNum {
    [AppDelegate shared].sentPhoneNum = phoneNum;
    ConfirmCodeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmCodeViewController"];
    [vc setPhoneNumber:phoneNum];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Keyboard state
//the Function that call when keyboard show.
- (void)keyboardWasShown:(NSNotification *)notif {
    CGSize _keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if(!movedUp) {
        if(isFirstMove) {
            movedUp = YES;
            isFirstMove = NO;
            self.cons_bottom.constant = _keyboardSize.height;
        } else {
            [self.view layoutIfNeeded];
            self.cons_bottom.constant = _keyboardSize.height;
            [UIView animateWithDuration:5
                             animations:^{
                                 [self.view layoutIfNeeded];
                                 movedUp = true;
                             }];
        }
    }
}
//the Function that call when keyboard hide.
- (void)keyboardWillBeHidden:(NSNotification *)notif {
    if(movedUp) {
        [self.view layoutIfNeeded];
        
        self.cons_bottom.constant = 0;
        [UIView animateWithDuration:5
                         animations:^{
                             [self.view layoutIfNeeded];
                             movedUp = false;
                         }];
    }
}

@end
