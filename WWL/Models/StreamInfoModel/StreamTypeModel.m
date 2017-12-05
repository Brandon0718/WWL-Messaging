//
//  StreamTypeModel.m
//  8a-ios
//
//  Created by Kristoffer Yap on 5/2/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "StreamTypeModel.h"

@implementation StreamTypeModel

#define KEY_DATA                @"data"
#define KEY_ID                  @"id"
#define KEY_NAME                @"name"
#define KEY_ICON                @"icon"
#define KEY_ICON_KEY            @"key"

- (id)initWith: (NSDictionary *)dic {
    self = [super init];
    
    if(dic) {
        
        if([dic objectForKey:KEY_ID] && [dic objectForKey:KEY_ID] != [NSNull null]) {
            self.identifier = [[dic objectForKey:KEY_ID] integerValue];
        }
        
        if([dic objectForKey:KEY_NAME] && [dic objectForKey:KEY_NAME] != [NSNull null]) {
            self.name = [dic objectForKey:KEY_NAME];
        }
        
        if([dic objectForKey:KEY_ICON] && [dic objectForKey:KEY_ICON] != [NSNull null]) {
            NSDictionary* iconDic = [dic objectForKey:KEY_ICON];
            if([iconDic objectForKey:KEY_ICON_KEY] && [iconDic objectForKey:KEY_ICON_KEY] != [NSNull null]) {
                self.icon = [iconDic objectForKey:KEY_ICON_KEY];
            }
        }
    }
    
    return self;
}

- (BOOL) sameWith:(StreamTypeModel*) item {
    if(item.identifier == self.identifier) {
        return YES;
    } else {
        return NO;
    }
}

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
