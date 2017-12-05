//
//  CountryModel.m
//  8a-ios
//
//  Created by Kristoffer Yap on 5/1/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "CountryModel.h"

@implementation CountryModel

- (id)initWith: (NSString *)code name:(NSString*) name phoneCode:(NSString*) phoneCode {
    self = [super init];
    
    if(self) {
        self.code = code;
        self.name = name;
        self.phoneCode = phoneCode;
        
        if([self.code isEqualToString:@"US"]) {
            self.additionalSearchTags = @"USA, United States of America";
        }
    }
    
    return self;
}

@end
