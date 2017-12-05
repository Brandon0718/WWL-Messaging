//
//  WatchNewsFilterModel.h
//  WWL
//
//  Created by Kristoffer Yap on 6/25/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    VODFilterSortByNone,
    VODFilterSortByDate,
    VODFilterSortByStringer,
    VODFilterSortByDuration,
} VODFilterSortBy;

typedef enum : NSUInteger {
    VODFilterSourceAll,
    VODFilterSourceMyNewsConnections,
    VODFilterSourceFavorites,
    VODFilterSourceNearBy,
} VODFilterSource;

typedef enum : NSUInteger {
    VODFilterNewsTypeAll,
    VODFilterNewsTypeFire,
    VODFilterNewsTypeCrime,
    VODFilterNewsTypeWar,
    VODFilterNewsTypeAccident,
    VODFilterNewsTypePolitics,
    VODFilterNewsTypeWeathers,
    VODFilterNewsTypeCelebrities,
    VODFilterNewsTypeSport,
    VODFilterNewsTypeOther,
} VODFilterNewsType;


@interface WatchNewsFilterModel : NSObject

@property (nonatomic, assign) VODFilterSortBy sortBy;
@property (nonatomic, strong) NSString* location;
@property (nonatomic, strong) NSString* stringer;
@property (nonatomic, strong) NSString* search;
@property (nonatomic, strong) NSDate* startDate;
@property (nonatomic, strong) NSDate* endDate;
@property (nonatomic, assign) VODFilterSource source;
@property (nonatomic, assign) VODFilterNewsType newsType;

- (instancetype) initWithDefault;

-(id) initWithCoder:(NSCoder*) decoder;
-(void)encodeWithCoder:(NSCoder*)encoder;

-(NSString*) getSortByString;
-(NSString*) getSourceString;
-(NSString*) getNewsTypeString;

@end
