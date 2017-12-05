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
#import "UIBarButtonItem+Image.h"
#import "MyVideoVC.h"
#import "UIBarButtonItem+Custom.h"
#import "StreamingVC.h"

@interface ViewController () <NewMessageDelegate>
{
    UIBarButtonItem* messageItem;
    int mUnreadCount;
    
    UIView* customNavTitleView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // This is app start-up case
    if([[AppDelegate shared] isLoggedIn]) {
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Checking your profile...";
        [self loadProfileInfo:^(BOOL isCompleted) {
            [self updateNavBarButtonItems];
            
            if(isCompleted) {
                [self initializeTwilio:^(BOOL completed) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                }];
            } else {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            }
        }];
    }
    
    
    [self.swt_location setOn:[UserContextManager sharedInstance].locationSharing];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Home";
    self.navigationController.navigationBarHidden = NO;
    
    [self updateNavBarButtonItems];
    
    [MessagingManager sharedManager].messageDelegate = self;

    mUnreadCount = 0;
    [[ChannelManager sharedManager] getUnreadCount:^(NSUInteger unreadCount) {
        mUnreadCount += unreadCount;
        [messageItem updateMessageCountLabel:mUnreadCount];
    }];
    
//    [self setupCustomTitleView];
}

- (void) setupCustomTitleView {
    if(customNavTitleView == nil) {
        
        customNavTitleView = [[UIView alloc] initWithFrame:CGRectZero];
        customNavTitleView.frame = CGRectMake(0, 0, 70, 50);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 50)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageNamed:@"img_logo"]; 
        
        [customNavTitleView addSubview:imageView];
        
        self.navigationItem.titleView = customNavTitleView;
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MessagingManager sharedManager].messageDelegate = nil;
}

- (void) updateNavBarButtonItems {
    if([[AppDelegate shared] isLoggedIn]) {
        if([[AppDelegate shared] isProfileCompleted]) {
            UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_user_white"] style:UIBarButtonItemStylePlain target:self action:@selector(onUserBarButtonClicked)];
            messageItem = [UIBarButtonItem initForMessageItem:self action:@selector(onMessageClicked)];
            
            self.navigationItem.rightBarButtonItems = @[item, messageItem];
        } else {
            UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_user_white"] style:UIBarButtonItemStylePlain target:self action:@selector(onUserBarButtonClicked)];
            UIBarButtonItem* warningItem = [UIBarButtonItem buttonItemForImage:[UIImage imageNamed:@"icon_warning"] target:self action:@selector(onUserBarButtonClicked)];
            self.navigationItem.rightBarButtonItems = @[item, warningItem];
        }
    } else {
        UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_login_white"] style:UIBarButtonItemStylePlain target:self action:@selector(onUserBarButtonClicked)];
        self.navigationItem.rightBarButtonItems = @[item];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton Actions
- (void) onMessageClicked {
    ChannelListVC *vc = (ChannelListVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"ChannelListVC" storyboardName:kStoryboardTwilio];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)onMyVideoTouchUp:(id)sender {
    if ([[AppDelegate shared] isLoggedIn]) {
        if ([[AppDelegate shared] isProfileCompleted]) {
            
            [self showMyVideos:NO];
        } else {
            [self showProfileVC:ProfileMotivationTypeMyVideos];
        }
        
    } else {
        [self gotoLoginFlow:SigninMotivationTypeMyVideos];
    }
}
- (IBAction)sosTouchUP:(id)sender {
    if ([[AppDelegate shared] isLoggedIn]) {
        if ([[AppDelegate shared] isProfileCompleted]) {
            [self showSosVC:NO];
        } else {
            [self showProfileVC:ProfileMotivationTypeSos];
        }
    }else {
        [self gotoLoginFlow:SigninMotivationTypeSos];
    }
}

- (IBAction)reportNewsTouchUp:(UIButton *)sender {
    if ([[AppDelegate shared] isLoggedIn]) {
        if ([[AppDelegate shared] isProfileCompleted]) {
            [self showChannelsVC:NO];
        } else {
            [self showProfileVC:ProfileMotivationTypeReportNews];
        }
    }else {
        [self gotoLoginFlow:SigninMotivationTypeReportNews];
    }
}
- (IBAction)onLocationShareChanged:(id)sender {
    if(self.swt_location.on) {
        if ([[AppDelegate shared] isLoggedIn]) {
            if ([[AppDelegate shared] isProfileCompleted]) {
                [UserContextManager sharedInstance].locationSharing = self.swt_location.isOn;
            } else {
                [self showProfileVC:ProfileMotivationTypeSos];
                self.swt_location.on = NO;
            }
        }else {
            [self gotoLoginFlow:SigninMotivationTypeSos];
            self.swt_location.on = NO;
        }
    } else {
        [UserContextManager sharedInstance].locationSharing = NO;
    }
    
}

#pragma mark - Custom Methods
- (void) onUserBarButtonClicked
{
    if([[AppDelegate shared] isLoggedIn]) {
        [self showProfileVC:ProfileMotivationTypeProfile];
    } else {
        [self gotoLoginFlow:SigninMotivationTypeSignin];
    }
}

#pragma mark - NewMessageDelegate Methods

-(void)messageAdded:(NSString *)message userInfo:(TwilioUserModel *)userInfo {
    mUnreadCount++;
    [messageItem updateMessageCountLabel:mUnreadCount];
}

-(void)messageManagerStatusUpdated:(TCHClientSynchronizationStatus)status {
    if(status < TCHClientSynchronizationStatusCompleted) {
        [messageItem startMessageLoadAnimation:YES];
    } else {
        [messageItem startMessageLoadAnimation:NO];
    }
}

@end
