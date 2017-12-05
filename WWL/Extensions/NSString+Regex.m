//
//  NSString+Regex.m
//  WWL
//
//  Created by Kristoffer Yap on 5/9/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "NSString+Regex.h"
#import "RegExCategories.h"

@implementation NSString (Regex)

-(BOOL) evaluateWithRegex:(NSString*) regex {
    if(![regex length]) {
        return YES;
    }
    
    // remove the expression mark for iOS
    regex = [regex stringByReplacingOccurrencesOfString:@"/" withString:@""];
    return [self isMatch:RX(regex)];
}

-(NSString*) getOnlyAlphabet
{
    return [[self componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""];
}

@end
