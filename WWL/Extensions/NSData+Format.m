//
//  NSData+Format.m
//  WWL
//
//  Created by Kristoffer Yap on 5/12/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "NSData+Format.h"

@implementation NSData (Format)

-(NSString*) getLogPrintableString {
    NSString* dataStr = [[NSString alloc] initWithData:self encoding:NSASCIIStringEncoding];
    
    NSMutableString *asciiCharacters = [NSMutableString string];
    for (NSInteger i = 32; i < 127; i++)  {
        [asciiCharacters appendFormat:@"%c", (char)i];
    }
    
    NSCharacterSet *nonAsciiCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:asciiCharacters] invertedSet];
    
    return [[dataStr componentsSeparatedByCharactersInSet:nonAsciiCharacterSet] componentsJoinedByString:@"."];
}

@end
