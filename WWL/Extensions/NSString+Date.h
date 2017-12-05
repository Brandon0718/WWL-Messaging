//
//  NSString+Date.h
//  WWL
//
//  Created by Kristoffer Yap on 5/14/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)

-(NSString*) getLocalTimeString;
-(NSString*) getDaysAgoString;
+(NSString*) getLocalVideoNameString;

@end
