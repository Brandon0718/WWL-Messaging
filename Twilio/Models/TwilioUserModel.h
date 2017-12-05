//
//  TwilioUserModel.h
//  WWL
//
//  Created by Kristoffer Yap on 5/19/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwilioUserModel : NSObject

@property (strong, nonatomic) NSString* identity;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* avatarLink;

- (instancetype) initWithTCHUserInfo:(TCHUserInfo*) userInfo;
- (instancetype) initWithMessage:(TCHMessage*) message channel:(TCHChannel*) channel;

@end
