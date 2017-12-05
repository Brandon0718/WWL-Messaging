//
//  AppDelegate.m
//  8a-ios
//
//  Created by Uncovered on 4/20/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityLogger.h"
#import "AFNetworkActivityConsoleLogger.h"
#import "UIColor+WWLColor.h"
#import "WWLDefine.h"
#import "INTULocationManager.h"

#import "StreamingVC.h"
#import "VideoVC.h"
#import "NSString+custom.h"

#import "UIViewController+Current.h"


#import <GooglePlaces/GMSPlacesClient.h>

//#define STAGING_RELEASE

@interface AppDelegate ()
{
    NSTimer* locationTimer;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Init Papertail
    RMPaperTrailLogger *paperTrailLogger = [RMPaperTrailLogger sharedInstance];
    paperTrailLogger.host = @"logs5.papertrailapp.com";
    paperTrailLogger.port = 43274;
    paperTrailLogger.programName = @"WWL-iOS";
    [DDLog addLogger:paperTrailLogger];
    
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    
    [GMSServices provideAPIKey:GOOGLE_MAP_API_KEY];
    [GMSPlacesClient provideAPIKey:GOOGLE_MAP_API_KEY];
    
#ifdef STAGING_RELEASE
    self.apiBaseUrl = API_BASE_URL_STAGING;
    self.wowzaKey = WOWZA_MAIN_KEY;
    
    DDLogInfo(@"Api Base URL %@", self.apiBaseUrl);
    DDLogInfo(@"Wowza Daily Key:%@", self.wowzaKey);
#else
    self.apiBaseUrl = API_BASE_URL_DEV;
    self.wowzaKey = WOWZA_DAILY_KEY;
    
    DDLogInfo(@"Api Base URL %@", self.apiBaseUrl);
    DDLogInfo(@"Wowza Daily Key:%@", self.wowzaKey);
#endif
    
    self.userData = [UserInfoModel loadInfo];
    if(self.userData) {
        paperTrailLogger.machineName = [NSString stringWithFormat:@"%@", self.userData.phone];
        [MyService shared].token = self.userData.token;
    }
    
    // Customize AFNetworking
//    AFNetworkActivityConsoleLogger *logger = [AFNetworkActivityLogger sharedLogger].loggers.anyObject;
//    logger.level = AFLoggerLevelDebug;
//    [[AFNetworkActivityLogger sharedLogger] startLogging];
    
    // Customize Navigation Bar
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor barTintColor]];
    
    self.filterChannels = [[NSMutableArray alloc] init];
    self.filterNews = [[NSMutableArray alloc] init];
    
    self.selectedChannels = [[NSMutableArray alloc] init];
    self.selectedNews = [[NSMutableArray alloc] init];
    
    // we have to make sure that the Background App Refresh is enable for the Location updates to work in the background.
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied) {
        [[UIViewController currentViewController] presentSimpleAlert:@"The app doesn't work without the Background App Refresh enabled. To turn it on, go to Settings > General > Background App Refresh" title:@"Background App Refresh"];
    } else if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted) {
        [[UIViewController currentViewController] presentSimpleAlert:@"The functions of this app are limited because the Background App Refresh is disable." title:@"Background App Refresh"];
    } else {
        self.locationTracker = [[LocationTracker alloc] init];
        [self.locationTracker startLocationTracking];
    }
    
    locationTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(onSubmitLocation) userInfo:nil repeats:YES];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDdidEnterBackground");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground");
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"%@", options);
    
    return YES;
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if ([self.window.rootViewController.presentedViewController isKindOfClass: [StreamingVC class]] ||
        [self.window.rootViewController.presentedViewController isKindOfClass: [VideoVC class]]) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

#pragma mark - User functions
+ (AppDelegate *)shared {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL) isLoggedIn {
    if (self.userData) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL) isProfileCompleted {
    BOOL completed = YES;
    
    if(![self.profileInfos count]) {
        completed = NO;
    } else {
        for (ProfileModel* item in self.profileInfos) {
            if(item.currentStatus != ProfileFieldStatusValid) {
                completed = NO;
            }
        }
    }
    
    return completed;
}

- (void)logOut {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:CURRENT_USER];
    self.userData = nil;
}


#pragma mark - Location Functions

-(void) onSubmitLocation {
    if([self isLoggedIn] && [self isProfileCompleted]) {
        if(self.mStreamName.length) {
            if(self.mIsStreamingEmergency) {
                [self.locationTracker updateLocationToServer:LocationSubmitTypeEmergency];
            } else {
                [self.locationTracker updateLocationToServer:LocationSubmitTypeStreaming];
            }
        } else if([UserContextManager sharedInstance].locationSharing) {
            [self.locationTracker updateLocationToServer:LocationSubmitTypeNormal];
        }
    } else {
        NSLog(@"Skipping submit location due to user is not looged or and profile is not completed");
    }
}

@end
