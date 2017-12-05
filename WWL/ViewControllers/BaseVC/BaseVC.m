//
//  BaseVC.m
//  8a-ios
//
//  Created by Kristoffer Yap on 4/28/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "BaseVC.h"

#import "ChannelsVC.h"
#import "ChannelModel.h"
#import "ProfileViewController.h"
#import "MyVideoHostVC.h"
#import "MyVideoVC.h"
#import "StreamingVC.h"
#import "ConfirmCodeViewController.h"
#import "SignInViewController.h"
#import "ChannelSelectionVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem* hamburgerItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_hamburger"] style:UIBarButtonItemStylePlain target:self action:@selector(onHamburger)];
    
    if([self.navigationController.viewControllers count] == 1) {
        self.navigationItem.leftBarButtonItems = @[hamburgerItem];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onHamburger {
    if([[AppDelegate shared] isLoggedIn]) {
        if([[AppDelegate shared] isProfileCompleted]) {
            if(self.sideMenuController.isLeftViewShowing) {
                [self.sideMenuController hideLeftViewAnimated];
            } else {
                [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
            }
        } else {
            [self showProfileVC:ProfileMotivationTypeProfile];
        }
    } else {
        [self gotoLoginFlow:SigninMotivationTypeSignin];
    }
}

- (void) hideKeyboard {
    [self.view endEditing:YES];
}

- (void)showAlertWithTitle: (NSString *)title message: (NSString *)message {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okA = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:okA];
    
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void) loadProfileInfo:(void(^)(BOOL isCompleted))block {
    if([AppDelegate shared].profileInfos) {
        [[AppDelegate shared].profileInfos removeAllObjects];
    } else {
        [AppDelegate shared].profileInfos = [[NSMutableArray alloc] init];
    }
    
    [[MyService shared] getUserProfileFields:^(BOOL success, id res) {
        if (success) {
            NSArray *arr = res[@"data"];
            for (NSDictionary *dic in arr) {
                ProfileModel *model = [[ProfileModel alloc] initWith:dic];
                [[AppDelegate shared].profileInfos addObject:model];
            }
        } else {
            NSError* err = (NSError*)res;
            [self showAlertWithTitle:@"Error" message:err.localizedDescription];
            
            if(err.code == WWL_UNAUTHROIZED_CODE) {
                [[AppDelegate shared] logOut];
            }
        }
        
        block([[AppDelegate shared] isProfileCompleted]);
    }];
}

- (void) initializeTwilio:(void(^)(BOOL completed))block {
    [[MyService shared] generateTwilioAccessToken:^(BOOL success, id res) {
        if(success) {
            if ([res[@"status"] isEqualToString:@"ok"]) {
                NSDictionary* tokenDic = res[@"data"];
                NSString* token = [tokenDic objectForKey:@"token"];
                NSString* identity = [tokenDic objectForKey:@"identity"];
                
                DDLogInfo(@"Twilio Token:%@ Identitiy:%@", token, identity);
                [[MessagingManager sharedManager] initializeClientWithToken:token];
            }
        }
        
        block(success);
    }];
}

- (void) gotoLoginFlow:(SigninMotivationType) motivation {
    [AppDelegate shared].signinMotivation = motivation;
    
    if([[AppDelegate shared].sentPhoneNum length]) {
        ConfirmCodeViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ConfirmCodeViewController"];
        [vc setPhoneNumber:[AppDelegate shared].sentPhoneNum];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        SignInViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)showProfileVC:(ProfileMotivationType) motivationType {
    ProfileViewController *vc = (ProfileViewController*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"ProfileViewController" storyboardName:kStoryboardMain];
    vc.motivationType = motivationType;
    
    if(motivationType == ProfileMotivationTypeSignin) {
        [self pushNewAndClear:vc];
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) showChannelsVC:(BOOL) toRoot {
    ChannelSelectionVC *vc =  (ChannelSelectionVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"ChannelSelectionVC" storyboardName:kStoryboardChannel];
    vc.title = @"Select Channels";
    
    if(toRoot) {
        [self pushNewAndClear:vc];
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) showSosVC:(BOOL) toRoot {
    StreamingVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StreamingVC"];
    vc.mode = StreamModeEmergency;

    if(toRoot) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void) showMyVideos:(BOOL) toRoot {
    MyVideoHostVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyVideoHostVC"];
    if(toRoot) {
        [self pushNewAndClear:vc];
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void) pushNewAndClear:(UIViewController*) vc {
    NSArray *viewControllers = self.navigationController.viewControllers;
    NSMutableArray *newViewControllers = [NSMutableArray array];
    
    // preserve the root view controller
    [newViewControllers addObject:[viewControllers objectAtIndex:0]];
    // add the new view controller
    [newViewControllers addObject:vc];
    // animatedly change the navigation stack
    [self.navigationController setViewControllers:newViewControllers animated:YES];
}

@end
