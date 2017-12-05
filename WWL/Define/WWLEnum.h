//
//  WWLEnum.h
//  WWL
//
//  Created by Kristoffer Yap on 5/15/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#ifndef WWLEnum_h
#define WWLEnum_h

typedef NS_ENUM(NSInteger, SigninMotivationType) {
    SigninMotivationTypeMyVideos,
    SigninMotivationTypeReportNews,
    SigninMotivationTypeSos,
    SigninMotivationTypeSignin,
};

typedef NS_ENUM(NSInteger, ProfileMotivationType) {
    ProfileMotivationTypeMyVideos,
    ProfileMotivationTypeReportNews,
    ProfileMotivationTypeSos,
    ProfileMotivationTypeSignin,
    ProfileMotivationTypeProfile,
    ProfileMotivationTypeChannels,
};

typedef enum : NSUInteger {
    StreamResolution288p,
    StreamResolution480p,
    StreamResolution720p,
    StreamResolution1080p,
} StreamResolution;

#endif /* WWLEnum_h */
