//
//  TwilioChannelInfo.h
//  WWL
//
//  Created by Kristoffer Yap on 5/21/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwilioChannelInfo : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* logoURL;

-(instancetype) initWithChannel:(TCHChannel*) channel;

@end
