//
//  ViewController.m
//  8a-ios
//
//  Created by Uncovered on 4/20/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "ViewController.h"
#import "SignInViewController.h"
#import "ProfileViewController.h"
#import "ChannelsVC.h"
#import "ChannelModel.h"
#import "ConfirmCodeViewController.h"
#import "UIButton+Border.h"

@interface ViewController ()
{
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.btn_report customBorder];
    [self.btn_watch customBorder];
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"WWL";
    self.navigationController.navigationBarHidden = NO;
    
    // Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_user"] style:UIBarButtonItemStylePlain target:self action:@selector(loginProfile)];
    self.navigationItem.rightBarButtonItem = item;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark - UIButton Actions

- (IBAction)watchNewsTouchUp:(UIButton *)sender {
    [self showConfirmCodeVC:@"123"];
}

- (IBAction)reportNewsTouchUp:(UIButton *)sender {
    if ([[AppDelegate shared] isLoggedIn]) {
        [self showChannelsVC:NO];
    }else {
        [self showSignInVC];
    }
}

#pragma mark - Custom Methods

//- (void)showProfileVC {
//    ProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
//    
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)loginProfile
{
    if([[AppDelegate shared] isLoggedIn]) {
        [self showProfileVC:NO];
    } else {
        [self showSignInVC];
    }
    
}

- (void)showSignInVC {
    SignInViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showConfirmCodeVC: (NSString *)phoneNum {
    ConfirmCodeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmCodeViewController"];
    [vc setPhoneNumber:phoneNum];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
