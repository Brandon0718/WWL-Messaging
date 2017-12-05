//
//  StreamTypeModel.h
//  8a-ios
//
//  Created by Kristoffer Yap on 5/2/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StreamTypeModel : NSObject

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* icon;

- (id)initWith: (NSDictionary *)dic;
- (BOOL) sameWith:(StreamTypeModel*) item;
- (BOOL) containedTo:(NSArray*) items;
- (void) removeFrom:(NSMutableArray*) items;

@end
