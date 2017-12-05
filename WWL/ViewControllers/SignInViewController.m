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

@interface SignInViewController () <CountrySelectedDelegate>
{
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

-(BOOL)shouldAutorotate {
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
//}

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

- (IBAction)getConfirmationCodeTouchUp:(UIButton *)sender {
    NSString *phoneNum = [self.phoneNumTF text];
    
    if (phoneNum == nil || [phoneNum length] < 8) {
        [self showAlertWithTitle:@"" message:@"Please input the valid phone number"];
        return;
    }
    
    [self showConfirmCodeVC:phoneNum];
    
    phoneNum = [NSString stringWithFormat:@"%@%@", countryInfo.phoneCode, phoneNum];
    [[MyService shared] requestConfirmationCodeWithPhoneNum:phoneNum withCompletion:^(BOOL success, id res) {
        if (success) {
            if ([res[@"status"] isEqualToString:@"ok"]) {
            } else {
                NSLog(@"Request Code Response Status: %@", res[@"status"]);
            }
        }else {
            NSLog(@"%@", [res localizedDescription]);
        }
    }];
}

#pragma mark - Custom Methods

- (void)showConfirmCodeVC: (NSString *)phoneNum {
    ConfirmCodeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmCodeViewController"];
    [vc setPhoneNumber:phoneNum];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Keyboard state
//the Function that call when keyboard show.
- (void)keyboardWasShown:(NSNotification *)notif {
    CGSize _keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if(!movedUp) {
        [self.view layoutIfNeeded];
        self.cons_bottom.constant = _keyboardSize.height;
        [UIView animateWithDuration:5
                         animations:^{
                             [self.view layoutIfNeeded];
                             movedUp = true;
                         }];
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
