//
//  MetaModel.m
//  WWL
//
//  Created by Kristoffer Yap on 5/14/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "MetaModel.h"

@implementation MetaModel

#define KEY_META                @"meta"
#define KEY_PAGINATION          @"pagination"
#define KEY_TOTAL               @"total"
#define KEY_COUNT               @"count"
#define KEY_PER_PAGE            @"per_page"
#define KEY_CURRENT_PAGE        @"current_page"
#define KEY_TOTAL_PAGES         @"total_pages"
#define KEY_LINKS               @"links"
#define KEY_LINKS_NEXT          @"next"

- (id)initWith: (NSDictionary *)dic {
    self = [super init];
    
    if(dic) {
        NSDictionary* meta = [dic objectForKey:KEY_META];
        
        if(meta) {
            if([meta objectForKey:KEY_PAGINATION] && [meta objectForKey:KEY_PAGINATION] != [NSNull null]) {
                NSDictionary* pagination = [meta objectForKey:KEY_PAGINATION];
                if([pagination objectForKey:KEY_TOTAL] && [pagination objectForKey:KEY_TOTAL] != [NSNull null]) {
                    self.total = [[pagination objectForKey:KEY_TOTAL] intValue];
                }
                
                if([pagination objectForKey:KEY_COUNT] && [pagination objectForKey:KEY_COUNT] != [NSNull null]) {
                    self.count = [[pagination objectForKey:KEY_COUNT] intValue];
                }
                
                if([pagination objectForKey:KEY_PER_PAGE] && [pagination objectForKey:KEY_PER_PAGE] != [NSNull null]) {
                    self.per_page = [[pagination objectForKey:KEY_PER_PAGE] intValue];
                }
                
                if([pagination objectForKey:KEY_CURRENT_PAGE] && [pagination objectForKey:KEY_CURRENT_PAGE] != [NSNull null]) {
                    self.current_page = [[pagination objectForKey:KEY_CURRENT_PAGE] intValue];
                }
                
                if([pagination objectForKey:KEY_TOTAL_PAGES] && [pagination objectForKey:KEY_TOTAL_PAGES] != [NSNull null]) {
                    self.total_pages = [[pagination objectForKey:KEY_TOTAL_PAGES] intValue];
                }
                
//                if([pagination objectForKey:KEY_LINKS] && [pagination objectForKey:KEY_LINKS] != [NSNull null]) {
//                    NSDictionary* linkDict = [pagination objectForKey:KEY_LINKS];
//                    self.nextLink = [linkDict objectForKey:KEY_LINKS_NEXT];
//                }
            }
        }
    }
    
    return self;
}

@end
