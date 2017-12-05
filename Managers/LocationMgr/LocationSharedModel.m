//
//  LocationSharedModel.m
//  WWL
//
//  Created by Kristoffer Yap on 6/27/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "LocationSharedModel.h"

@implementation LocationSharedModel

//Class method to make sure the share model is synch across the app
+ (id)sharedModel
{
    static id sharedMyModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyModel = [[self alloc] init];
    });
    return sharedMyModel;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

@end
