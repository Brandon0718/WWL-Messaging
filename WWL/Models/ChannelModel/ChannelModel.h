//
//  ChannelModel.h
//  8a-ios
//
//  Created by Kristoffer Yap on 4/28/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelModel : NSObject

@property (nonatomic, strong) NSString*     status;
@property (nonatomic, assign) long          identifier;
@property (nonatomic, strong) NSString*     name;
@property (nonatomic, strong) NSString*     thumbUrl;

- (id)initWith: (NSDictionary *)dic;
//- (BOOL) sameWith:(ChannelModel*) item;
- (BOOL) containedTo:(NSArray*) items;
- (void) removeFrom:(NSMutableArray*) items;

@end
