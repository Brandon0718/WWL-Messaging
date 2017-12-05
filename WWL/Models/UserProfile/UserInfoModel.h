//
//  UserProfile.h
//  8a-ios
//
//  Created by Mobile on 24/04/2017.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileModel.h"

@interface UserInfoModel : NSObject<NSCoding>

/// User ID
@property (strong, nonatomic) NSString *uid;
/// User Name
@property (strong, nonatomic) NSString *name;
/// User Email
@property (strong, nonatomic) NSString *email;
/// User Phone Number
@property (strong, nonatomic) NSString *phone;

/// User Phone Number
@property (strong, nonatomic) NSString *token;

/// User Data (Name, Image, Bio ...)
@property (strong, nonatomic) NSMutableArray *dataArr;

/// Save the current user data in NSUserDefaults
- (void)save;

/// Load the current user data in NSUserDefaults
+ (UserInfoModel *)loadInfo;

@end
