//
//  WatchNewsFilterModel.m
//  WWL
//
//  Created by Kristoffer Yap on 6/25/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "WatchNewsFilterModel.h"

// SatPaqInfo keys
#define SORT_BY_KEY             @"vod_filter_sort"
#define LOCATION_KEY            @"vod_filter_location"
#define STRINGER_KEY            @"vod_filter_stringer"
#define SEARCH_KEY              @"vod_filter_search"
#define START_DATE_KEY          @"vod_filter_start_date"
#define END_DATE_KEY            @"vod_filter_end_date"
#define SOURCE_KEY              @"vod_filter_source"
#define NEWS_TYPE_KEY           @"vod_filter_news_type"

@implementation WatchNewsFilterModel

- (id) initWithCoder:(NSCoder*) decoder {
    self = [super init];
    if(self && decoder) {
        self.sortBy = [[decoder decodeObjectForKey:SORT_BY_KEY] integerValue];
        self.location = [decoder decodeObjectForKey:LOCATION_KEY];
        self.stringer = [decoder decodeObjectForKey:STRINGER_KEY];
        self.search = [decoder decodeObjectForKey:SEARCH_KEY];
        self.startDate = [decoder decodeObjectForKey:START_DATE_KEY];
        self.endDate = [decoder decodeObjectForKey:END_DATE_KEY];
        self.source = [[decoder decodeObjectForKey:SOURCE_KEY] integerValue];
        self.newsType = [[decoder decodeObjectForKey:NEWS_TYPE_KEY] integerValue];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:[NSNumber numberWithInteger:self.sortBy] forKey:SORT_BY_KEY];
    [encoder encodeObject:self.location forKey:LOCATION_KEY];
    [encoder encodeObject:self.stringer forKey:STRINGER_KEY];
    [encoder encodeObject:self.search forKey:SEARCH_KEY];
    [encoder encodeObject:self.startDate forKey:START_DATE_KEY];
    [encoder encodeObject:self.endDate forKey:END_DATE_KEY];
    [encoder encodeObject:[NSNumber numberWithInteger:self.source] forKey:SOURCE_KEY];
    [encoder encodeObject:[NSNumber numberWithInteger:self.newsType] forKey:NEWS_TYPE_KEY];
}

- (instancetype) initWithDefault {
    self = [super init];
    
    if(self) {
        self.sortBy = VODFilterSortByNone;
        self.location = @"";
        self.stringer = @"";
        self.search = @"";
        self.startDate = nil;
        self.endDate = nil;
        self.source = VODFilterSourceAll;
        self.newsType = VODFilterNewsTypeAll;
    }
    
    return self;
}

-(NSString*) getSortByString {
    switch(self.sortBy) {
        case VODFilterSortByNone:
            return @"None";
        case VODFilterSortByDate:
            return @"Date";
        case VODFilterSortByDuration:
            return @"Duration";
        case VODFilterSortByStringer:
            return @"Stringer";
        default:
            return @"None";
    }
}

-(NSString*) getSourceString {
    switch(self.source) {
        case VODFilterSourceAll:
            return @"All Channels";
        case VODFilterSourceNearBy:
            return @"My News Connections";
        case VODFilterSourceFavorites:
            return @"Favorites";
        case VODFilterSourceMyNewsConnections:
            return @"Near By";
        default:
            return @"All Channels";
    }
}

-(NSString*) getNewsTypeString {
    switch(self.newsType) {
        case VODFilterNewsTypeAll:
            return @"All";
        case VODFilterNewsTypeWar:
            return @"War";
        case VODFilterNewsTypeFire:
            return @"Fire";
        case VODFilterNewsTypeCrime:
            return @"Crime";
        case VODFilterNewsTypeOther:
            return @"Other";
        case VODFilterNewsTypeSport:
            return @"Sport";
        case VODFilterNewsTypeAccident:
            return @"Accident";
        case VODFilterNewsTypePolitics:
            return @"Politics";
        case VODFilterNewsTypeWeathers:
            return @"Weathers";
        case VODFilterNewsTypeCelebrities:
            return @"Celebrities";
        default:
            return @"All";
    }
}

@end
