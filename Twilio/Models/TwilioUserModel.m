//
//  TwilioUserModel.m
//  WWL
//
//  Created by Kristoffer Yap on 5/19/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "TwilioUserModel.h"

@implementation TwilioUserModel

-(instancetype) initWith:(NSString*) identity name:(NSString*) name avatarLink:(NSString*) avatarLink {
    self = [super init];
    
    self.identity = identity;
    self.name = name;
    self.avatarLink = avatarLink;
    
    return self;
}

- (instancetype) initWithTCHUserInfo:(TCHUserInfo*) userInfo {
    self = [super init];
    
    self.identity = userInfo.identity;
    self.name = [userInfo.attributes objectForKey:@"name"];
    
    return self;
}

- (instancetype) initWithMessage:(TCHMessage*) message channel:(TCHChannel*) channel {
    self = [super init];
    
    TCHMember* member = [channel memberWithIdentity:message.author];
    
    NSString* displayName = [NSString stringWithFormat:@"User %@", message.author];
    
    if(member) {
        NSDictionary* attributes = member.userInfo.attributes;
        if([attributes objectForKey:@"name"] && [attributes objectForKey:@"name"] != [NSNull null]) {
            if([[member.userInfo.attributes objectForKey:@"name"] length]) {
                displayName = [member.userInfo.attributes objectForKey:@"name"];
            }
        }
        
        if([attributes objectForKey:@"profile_photo"] && [attributes objectForKey:@"profile_photo"] != [NSNull null]) {
            self.avatarLink = [attributes objectForKey:@"profile_photo"];
        }
    }
    
    self.identity = message.author;
    self.name = displayName;
    
    return self;
}

@end
