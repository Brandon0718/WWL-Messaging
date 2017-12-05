//
//  NSDate+UTCString.h
//  WWL
//
//  Created by Kristoffer Yap on 5/14/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (UTCString)

-(NSString*) getUTCString;
-(NSString*) getStartDateString:(DayFilterType) filterType;

@end
