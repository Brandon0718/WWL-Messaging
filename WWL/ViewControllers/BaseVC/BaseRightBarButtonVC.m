//
//  BaseRightBarButtonVC.m
//  WWL
//
//  Created by Kristoffer Yap on 6/5/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "BaseRightBarButtonVC.h"

#import "UIBarButtonItem+Image.h"
#import "UIBarButtonItem+Custom.h"

@interface BaseRightBarButtonVC () <NewMessageDelegate>
{
    int mUnreadCount;
    UIBarButtonItem* messageItem;
}
@end

@implementation BaseRightBarButtonVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem* item = [UIBarButtonItem buttonItemForImage:[UIImage imageNamed:@"icon_user_white"] target:self action:@selector(onProfileBarButtonClicked)];
    UIBarButtonItem* warningItem = [UIBarButtonItem buttonItemForImage:[UIImage imageNamed:@"icon_warning"] target:self action:@selector(onProfileBarButtonClicked)];
    messageItem = [UIBarButtonItem initForMessageItem:self action:@selector(onMessageClicked)];
    if([[AppDelegate shared] isProfileCompleted]) {
        self.navigationItem.rightBarButtonItems = @[item, messageItem];
    } else {
        self.navigationItem.rightBarButtonItems = @[item, warningItem];
    }
    
    mUnreadCount = 0;
    [[ChannelManager sharedManager] getUnreadCount:^(NSUInteger unreadCount) {
        mUnreadCount += unreadCount;
        [messageItem updateMessageCountLabel:mUnreadCount];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [MessagingManager sharedManager].messageDelegate = self;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [MessagingManager sharedManager].messageDelegate = nil;
}

- (void) onMessageClicked {
    ChannelListVC *vc = (ChannelListVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"ChannelListVC" storyboardName:kStoryboardTwilio];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onProfileBarButtonClicked {
    [self showProfileVC:ProfileMotivationTypeProfile];
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
