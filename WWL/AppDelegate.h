//
//  AppDelegate.h
//  8a-ios
//
//  Created by Uncovered on 4/20/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterNormalCell.h"
#import "WWLEnum.h"
#import "LocationTracker.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow*         window;

@property (strong, nonatomic) NSString*         apiBaseUrl;
@property (strong, nonatomic) NSMutableArray*   profileInfos;
@property (strong, nonatomic) UserInfoModel*      userData;
@property (strong, nonatomic) NSString*         wowzaKey;

@property (strong, nonatomic) LocationTracker* locationTracker;

// For SignIn Process
@property (strong, nonatomic) NSString*             sentPhoneNum;
@property (assign, nonatomic) SigninMotivationType  signinMotivation;

// For saving filter items
@property (strong, nonatomic) NSMutableArray* filterChannels;
@property (strong, nonatomic) NSMutableArray* filterNews;

@property (strong, nonatomic) NSMutableArray* selectedChannels;
@property (strong, nonatomic) NSMutableArray* selectedNews;
@property (assign, nonatomic) DayFilterType selectedDayType;

@property (assign, nonatomic) BOOL mIsLocationUpdating;
@property (strong, nonatomic) NSString* mStreamName;
@property (assign, nonatomic) BOOL mIsStreamingEmergency;

@property (assign, nonatomic) BOOL mIsStreaming;

+ (AppDelegate *)shared;

- (void) logOut;
- (BOOL) isLoggedIn;
- (BOOL) isProfileCompleted;

@end

