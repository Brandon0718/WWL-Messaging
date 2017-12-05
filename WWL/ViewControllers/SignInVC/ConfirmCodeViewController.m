//
//  ConfirmCodeViewController.m
//  8a-ios
//
//  Created by Mobile on 21/04/2017.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "ConfirmCodeViewController.h"
#import "ProfileViewController.h"
#import "ChannelsVC.h"
#import "ChannelModel.h"
#import "SignInViewController.h"
#import "UIButton+Border.h"

@interface ConfirmCodeViewController () <UITextFieldDelegate>
{
    BOOL isFirstMove;
    BOOL movedUp;

    NSString* phoneNum;
}

@end

@implementation ConfirmCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Confirm Code";
    self.navigationController.navigationBarHidden = NO;
    
    self.btn_first.layer.cornerRadius = 5.0f;
    self.btn_second.layer.cornerRadius = 5.0f;
    self.btn_third.layer.cornerRadius = 5.0f;
    self.btn_fourth.layer.cornerRadius = 5.0f;
    self.btn_five.layer.cornerRadius = 5.0f;
    self.btn_six.layer.cornerRadius = 5.0f;
    
    [self.errorLabel setHidden:YES];
    
    [self.btn_back customBorder];
    
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    isFirstMove = YES;
    
    [self.txt_code becomeFirstResponder];
    
    // register keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    // unregister keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];

    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCodeChanged:(id)sender {
    [self.errorLabel setHidden:YES];
    
    if(self.txt_code.text.length > 6) {
        self.txt_code.text = [self.txt_code.text substringToIndex:6];
    } else {
        [self refreshCodeText];
        
        if(self.txt_code.text.length == 6) {
            [self confirmCode];
        }
    }
}

- (void) refreshCodeText {
    [self clearAllText];
    
    if(self.txt_code.text.length > 0) {
        [self.btn_first setTitle:[self.txt_code.text substringWithRange:NSMakeRange(0, 1)] forState:UIControlStateNormal];
    }
    
    if(self.txt_code.text.length > 1) {
        [self.btn_second setTitle:[self.txt_code.text substringWithRange:NSMakeRange(1, 1)] forState:UIControlStateNormal];
    }
    
    if(self.txt_code.text.length > 2) {
        [self.btn_third setTitle:[self.txt_code.text substringWithRange:NSMakeRange(2, 1)] forState:UIControlStateNormal];
    }
    
    if(self.txt_code.text.length > 3) {
        [self.btn_fourth setTitle:[self.txt_code.text substringWithRange:NSMakeRange(3, 1)] forState:UIControlStateNormal];
    }
    
    if(self.txt_code.text.length > 4) {
        [self.btn_five setTitle:[self.txt_code.text substringWithRange:NSMakeRange(4, 1)] forState:UIControlStateNormal];
    }
    
    if(self.txt_code.text.length > 5) {
        [self.btn_six setTitle:[self.txt_code.text substringWithRange:NSMakeRange(5, 1)] forState:UIControlStateNormal];
    }
}

- (void) clearAllText {
    [self.btn_first setTitle:@"" forState:UIControlStateNormal];
    [self.btn_second setTitle:@"" forState:UIControlStateNormal];
    [self.btn_third setTitle:@"" forState:UIControlStateNormal];
    [self.btn_fourth setTitle:@"" forState:UIControlStateNormal];
    [self.btn_five setTitle:@"" forState:UIControlStateNormal];
    [self.btn_six setTitle:@"" forState:UIControlStateNormal];
}

- (IBAction)onBtnFirst:(id)sender {
    self.txt_code.text = @"";
    [self refreshCodeText];
}

- (IBAction)onBtnSecond:(id)sender {
    self.txt_code.text = [self.txt_code.text substringToIndex:1];
    [self refreshCodeText];
}

- (IBAction)onBtnThird:(id)sender {
    self.txt_code.text = [self.txt_code.text substringToIndex:2];
    [self refreshCodeText];
}

- (IBAction)onBtnFourth:(id)sender {
    self.txt_code.text = [self.txt_code.text substringToIndex:3];
    [self refreshCodeText];
}

- (IBAction)onBtnFifth:(id)sender {
    self.txt_code.text = [self.txt_code.text substringToIndex:4];
    [self refreshCodeText];
}

- (IBAction)onBtnSix:(id)sender {
    self.txt_code.text = [self.txt_code.text substringToIndex:5];
    [self refreshCodeText];
}


//- (void) setEditingButton:(UIButton*) button isTrue:(BOOL) isTrue {
//    if(isTrue) {
//        button.layer.borderColor = [[UIColor redColor] CGColor];
//        button.layer.borderWidth = 1.0f;
//    } else {
//        button.layer.borderColor = [[UIColor clearColor] CGColor];
//        button.layer.borderWidth = 0.0f;
//    }
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) confirmCode {
    if(self.txt_code.text.length != 6) {
        [self.errorLabel setHidden:NO];
        return;
    }
    
    NSString *code = [NSString stringWithFormat:@"%@-%@",
                      [self.txt_code.text substringToIndex:3],
                      [self.txt_code.text substringFromIndex:3]];
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Confirming your code";
    
    [[MyService shared] loginWithPhoneNum:phoneNum confirmationCode:code withCompletion:^(BOOL success, id res) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (success) {
            if ([res[@"status"] isEqualToString:@"ok"]) {
                UserInfoModel *user = [[UserInfoModel alloc] init];
                [user setPhone:phoneNum];
                [user setToken:[res objectForKey:@"token"]];
                [AppDelegate shared].userData = user;
                [[AppDelegate shared].userData save];
                [AppDelegate shared].sentPhoneNum = nil;
                
                MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.labelText = @"Checking your Profile...";
                [self loadProfileInfo:^(BOOL isCompleted) {
                    [self initializeTwilio:^(BOOL completed) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        if(isCompleted) {
                            switch([AppDelegate shared].signinMotivation) {
                                case SigninMotivationTypeMyVideos:
                                    [self showMyVideos:YES];
                                    break;
                                case SigninMotivationTypeReportNews:
                                    [self showChannelsVC:YES];
                                    break;
                                case SigninMotivationTypeSignin:
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                    break;
                                case SigninMotivationTypeSos:
                                    [self showSosVC:YES];
                                    break;
                            }
                            
                        } else {
                            [self showProfileVC:ProfileMotivationTypeSignin];
                        }
                    }];
                }];
            } else {
                [self.errorLabel setHidden:NO];
            }
        } else {
            NSError* err = (NSError*)res;
            [self showAlertWithTitle:@"Error" message:err.localizedDescription];
        }
    }];
}

#pragma mark - UIButton Actions

- (IBAction)notReceivedTouchUp:(UIButton *)sender {
    [AppDelegate shared].sentPhoneNum = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Public Methods

- (void)setPhoneNumber: (NSString *)sender {
    phoneNum = sender;
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


@end
