//
//  UserDataModel.h
//  8a-ios
//
//  Created by Mobile on 24/04/2017.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ProfileFieldTypeUnknown,
    ProfileFieldTypeText,
    ProfileFieldTypeTextArea,
    ProfileFieldTypeImage,
} ProfileFieldType;

typedef NS_ENUM(NSInteger, ProfileFieldStatus)
{
    ProfileFieldStatusInvalid,
    ProfileFieldStatusValid,
    ProfileFieldStatusInputting,
    ProfileFieldStatusPosting,
};

typedef NS_ENUM(NSInteger, ProfileFieldErrorType)
{
    ProfileFieldErrorTypeNone,
    ProfileFieldErrorTypeUnknown,
    ProfileFieldErrorTypeRequired,
    ProfileFieldErrorTypeWrongFormat,
};

@interface ProfileModel : NSObject

@property (nonatomic, assign) long          identifier;
@property (nonatomic, strong) NSString*     label;
@property (nonatomic, strong) id            value;
@property (nonatomic, assign) BOOL          isValid;



// Own Fields
@property (nonatomic, assign) NSInteger             rowIndex;
@property (nonatomic, assign) ProfileFieldType      type;
@property (nonatomic, assign) ProfileFieldStatus    currentStatus;
@property (nonatomic, assign) ProfileFieldErrorType errorType;

- (id) initWith: (NSDictionary *)dic;
- (void) updateWith: (NSDictionary *)dic;
+ (ProfileFieldType)typeFromString: (NSString *)string;
- (NSString*) getErrorMsg;
- (void) updateWithErrorDic: (NSDictionary*) dic;

@end
