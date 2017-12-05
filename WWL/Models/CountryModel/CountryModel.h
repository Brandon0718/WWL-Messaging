//
//  CountryModel.h
//  8a-ios
//
//  Created by Kristoffer Yap on 5/1/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CountryModel : NSObject

@property (nonatomic, strong) NSString* code;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* phoneCode;
@property (nonatomic, strong) NSString* additionalSearchTags;

- (id)initWith: (NSString *)code name:(NSString*) name phoneCode:(NSString*) phoneCode;

@end
