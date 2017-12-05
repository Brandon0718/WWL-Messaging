//
//  NSString+Regex.h
//  WWL
//
//  Created by Kristoffer Yap on 5/9/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Regex)

-(BOOL) evaluateWithRegex:(NSString*) regex;
-(NSString*) getOnlyAlphabet;

@end
