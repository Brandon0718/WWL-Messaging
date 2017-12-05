//
//  ChannelModel.m
//  8a-ios
//
//  Created by Kristoffer Yap on 4/28/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "ChannelModel.h"

@implementation ChannelModel

#define KEY_STATUS      @"status"
#define KEY_ID          @"id"
#define KEY_NAME        @"name"
#define KEY_THUMB       @"thumbnail"
#define KEY_LOGO        @"logo"

- (id)initWith: (NSDictionary *)dic {
    self = [super init];
    
    if(dic) {
        if([dic objectForKey:KEY_STATUS] && [dic objectForKey:KEY_STATUS] != [NSNull null]) {
            self.status = [dic objectForKey:KEY_STATUS];
        }
        
        if([dic objectForKey:KEY_ID] && [dic objectForKey:KEY_ID] != [NSNull null]) {
            self.identifier = [[dic objectForKey:KEY_ID] longValue];
        }
        
        if([dic objectForKey:KEY_NAME] && [dic objectForKey:KEY_NAME] != [NSNull null]) {
            self.name = [dic objectForKey:KEY_NAME];
        }
        
        if([dic objectForKey:KEY_THUMB] && [dic objectForKey:KEY_THUMB] != [NSNull null]) {
            NSDictionary* urlDic = [dic objectForKey:KEY_THUMB];
            if([urlDic objectForKey:@"url"] && [urlDic objectForKey:@"url"] != [NSNull null]) {
                self.thumbUrl = [urlDic objectForKey:@"url"];
            }
        }
        
        if([dic objectForKey:KEY_LOGO] && [dic objectForKey:KEY_LOGO] != [NSNull null]) {
            NSDictionary* urlDic = [dic objectForKey:KEY_LOGO];
            if([urlDic objectForKey:@"url"] && [urlDic objectForKey:@"url"] != [NSNull null]) {
                self.thumbUrl = [urlDic objectForKey:@"url"];
            }
        }
    }
    
    return self;
}

//- (BOOL) sameWith:(ChannelModel*) item {
//    if(item.identifier == self.identifier) {
//        return YES;
//    } else {
//        return NO;
//    }
//}

- (BOOL) containedTo:(NSArray*) items {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier=%d", self.identifier];
    NSArray* candidates = [items filteredArrayUsingPredicate:predicate];
    if(candidates.count) {
        return YES;
    } else {
        return NO;
    }
}

- (void) removeFrom:(NSMutableArray*) items {
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier=%d", self.identifier];
    NSArray* candidates = [items filteredArrayUsingPredicate:predicate];
    if(candidates.count) {
        [items removeObject:candidates[0]];
    }
}

@end
