//
//  UserDataModel.m
//  8a-ios
//
//  Created by Mobile on 24/04/2017.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "ProfileModel.h"

@implementation ProfileModel

#define KEY_FIELD_TYPE  @"field_type"
#define KEY_ID          @"id"
#define KEY_LABEL       @"label"
#define KEY_VALUE       @"value"
#define KEY_IS_REQUIRED @"is_required"
#define KEY_IS_VALID    @"is_valid"

#define KEY_REGEX_FAIL_MSG      @"regex_fail_message"
#define KEY_REGEX_RULE          @"regex_rule"
#define KEY_IS_UNIQUE_FAIL_MSG  @"is_unique_fail_message"
#define KEY_IS_UNIQUE           @"is_unique"

#define KEY_ERROR               @"errors"
#define KEY_ERROR_MESSAGE       @"message"
#define KEY_ERROR_KEY           @"error_key"


- (id)initWith: (NSDictionary *)dic {
    self = [super init];
    
    if (self) {
        [self updateWith:dic];
    }
    
    return self;
}

- (void) updateWithErrorDic: (NSDictionary*) dic {
    if([dic objectForKey:KEY_ERROR] && [dic objectForKey:KEY_ERROR] != [NSNull null]) {
        NSArray* errors = [dic objectForKey:KEY_ERROR];
        if([errors count]) {
            self.isValid = NO;
            self.errorType = ProfileFieldErrorTypeUnknown;
            NSDictionary* item = errors[0];
            if([item objectForKey:KEY_ERROR_KEY] && [item objectForKey:KEY_ERROR_KEY] != [NSNull null]) {
                NSString* errorKey = [item objectForKey:KEY_ERROR_KEY];
                if([errorKey isEqualToString:@"validation_required"]) {
                    self.errorType = ProfileFieldErrorTypeRequired;
                } else if([errorKey isEqualToString:@"validation_regex"]) {
                    self.errorType = ProfileFieldErrorTypeWrongFormat;
                }
            }
        }
    }
}

- (void) updateWith: (NSDictionary *)dic {
    if(dic) {
        if([dic objectForKey:KEY_FIELD_TYPE] && [dic objectForKey:KEY_FIELD_TYPE] != [NSNull null]) {
            self.type = [ProfileModel typeFromString:[dic objectForKey:KEY_FIELD_TYPE]];
        }
        
        if([dic objectForKey:KEY_ID] && [dic objectForKey:KEY_ID] != [NSNull null]) {
            self.identifier = [[dic objectForKey:KEY_ID] longValue];
        }
        
        if([dic objectForKey:KEY_LABEL] && [dic objectForKey:KEY_LABEL] != [NSNull null]) {
            self.label = [dic objectForKey:KEY_LABEL];
        }
        
        if([dic objectForKey:KEY_VALUE] && [dic objectForKey:KEY_VALUE] != [NSNull null]) {
            self.value = [dic objectForKey:KEY_VALUE];
        }
        
        if([dic objectForKey:KEY_IS_VALID] && [dic objectForKey:KEY_IS_VALID] != [NSNull null]) {
            self.isValid = [[dic objectForKey:KEY_IS_VALID] boolValue];
            
            if(self.isValid) {
                self.currentStatus = ProfileFieldStatusValid;
            } else {
                self.currentStatus = ProfileFieldStatusInvalid;
            }
        }
        
        self.errorType = ProfileFieldErrorTypeNone;
        
        if([dic objectForKey:KEY_ERROR] && [dic objectForKey:KEY_ERROR] != [NSNull null]) {
            NSArray* errors = [dic objectForKey:KEY_ERROR];
            if([errors count]) {
                self.errorType = ProfileFieldErrorTypeUnknown;
                NSDictionary* item = errors[0];
                if([item objectForKey:KEY_ERROR_KEY] && [item objectForKey:KEY_ERROR_KEY] != [NSNull null]) {
                    NSString* errorKey = [item objectForKey:KEY_ERROR_KEY];
                    if([errorKey isEqualToString:@"validation_required"]) {
                        self.errorType = ProfileFieldErrorTypeRequired;
                    } else if([errorKey isEqualToString:@"validation_regex"]) {
                        self.errorType = ProfileFieldErrorTypeWrongFormat;
                    }
                }
            }
        }
    }
}

- (NSString*) getErrorMsg {
    NSString* errMsg;
    switch (self.errorType) {
        case ProfileFieldErrorTypeUnknown:
            errMsg = @"Please input correct information";
            break;
        case ProfileFieldErrorTypeWrongFormat:
            errMsg = @"Please input the info with correct format!";
            break;
        case ProfileFieldErrorTypeRequired:
            errMsg = @"This field is required!";
            break;
        default:
            break;
    }
    return errMsg;
}

+ (ProfileFieldType) typeFromString: (NSString *)string {
    if ([string isEqualToString:@"text"]) {
        return ProfileFieldTypeText;
    }else if ([string isEqualToString:@"textarea"]) {
        return ProfileFieldTypeTextArea;
    }else if ([string isEqualToString:@"image"]) {
        return ProfileFieldTypeImage;
    } else {
        return ProfileFieldTypeUnknown;
    }
}

+ (NSString*) stringFromType: (ProfileFieldType) type {
    switch(type) {
        case ProfileFieldTypeText:
            return @"text";
        case ProfileFieldTypeImage:
            return @"image";
        case ProfileFieldTypeTextArea:
            return @"textarea";
        case ProfileFieldTypeUnknown:
            return @"";
    }
}

@end
