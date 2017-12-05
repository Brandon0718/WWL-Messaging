//
//  BaseVC.h
//  8a-ios
//
//  Created by Kristoffer Yap on 4/28/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController

- (void) hideKeyboard;
- (void)showAlertWithTitle: (NSString *)title message: (NSString *)message;

- (void) gotoLoginFlow:(SigninMotivationType) motivation;
- (void) loadProfileInfo:(void(^)(BOOL isCompleted))block;
- (void) initializeTwilio:(void(^)(BOOL completed))block;
- (void) showProfileVC:(ProfileMotivationType) motivationType;
- (void) showChannelsVC:(BOOL) toRoot;
- (void) showMyVideos:(BOOL) toRoot;
- (void) showSosVC:(BOOL) toRoot;
- (void) pushNewAndClear:(UIViewController*) vc;

@end
