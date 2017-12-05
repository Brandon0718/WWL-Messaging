//
//  MetaModel.h
//  WWL
//
//  Created by Kristoffer Yap on 5/14/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MetaModel : NSObject

@property (nonatomic, assign) int total;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) int per_page;
@property (nonatomic, assign) int current_page;
@property (nonatomic, assign) int total_pages;
@property (nonatomic, strong) NSString* nextLink;

- (id)initWith: (NSDictionary *)dic;

@end
