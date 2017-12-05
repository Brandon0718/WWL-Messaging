//
//  WWLDefine.h
//  8a-ios
//
//  Created by Kristoffer Yap on 4/28/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#ifndef WWLDefine_h
#define WWLDefine_h

#define WOWZA_MAIN_KEY      @"GOSK-0643-0100-37FB-CF5B-E480"        // com.wwl.myLiveApp

#define WOWZA_DAILY_KEY     @"GSDK-1944-0003-3973-F49A-C1B5"        // com.wwl.myLiveAppDaily
#define WOWZA_BETA_KEY      @"GSDK-1944-0003-3973-F49A-C1B5"        // com.wwl.myLiveAppBeta
#define WOWZA_RELEASE_KEY   @"GSDK-1944-0003-61E7-BF13-B6AC"        // com.wwl.myLiveAppRelease

#define GOOGLE_MAP_API_KEY  @"AIzaSyA2unY0R_nWlizAiW3llsz3deJoeXjDjoI"
#define GOOGLE_MAP_API_KEY_ME  @"AIzaSyBtdg0uUYeyQX8KyOsm7irGaUFU1OrrCvo"


// Storyboard and ViewControllers

#define kStoryboardMain                     @"Main"
#define kStoryboardTwilio                   @"Twilio"
#define kStoryboardSetting                  @"Setting"
#define kStoryboardChannel                  @"Channel"
#define kStoryboardWatchNews                @"WatchNews"

#define LOCATION_UPDATE_INTERVAL            3


// Singleton Define

#ifndef DEFINE_SINGLETON
#define DEFINE_SINGLETON        + (instancetype)sharedInstance;
#endif


#ifndef IMPLEMENT_SINGLETON
#define IMPLEMENT_SINGLETON     + (instancetype)sharedInstance \
{ \
static dispatch_once_t once; \
static id sharedInstance; \
dispatch_once(&once, ^ \
{ \
sharedInstance = [self new]; \
}); \
return sharedInstance; \
}
#endif

#endif /* WWLDefine_h */
