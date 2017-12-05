//
//  UIColor+WWLColor.m
//  8a-ios
//
//  Created by Kristoffer Yap on 4/29/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "UIColor+WWLColor.h"

@implementation UIColor (WWLColor)

+(UIColor*) defaultColor {
    return [UIColor colorWithRed:0.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}

+(UIColor*) barTintColor {
    return [UIColor colorWithRed:25.0f/255.0f green:93.0f/255.0f blue:140.0f/255.0f alpha:1.0f];
}

+(UIColor*) wwlRedColor {
    return [UIColor colorWithRed:180.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
}

+ (UIColor *)sectionColor {
    return [UIColor colorWithRed:(float)0xf0/0xff green:(float)0xef/0xff blue:(float)0xf5/0xff alpha:1.0];
}

+ (UIColor *)borderColor {
    return [UIColor colorWithRed:(float)0xc9/0xff green:(float)0xc8/0xff blue:(float)0xcd/0xff alpha:1.0];
}

+ (UIColor *)darkMessageColor {
    return [UIColor colorWithRed:(float)0x5b/0xff green:(float)0x4f/0xff blue:(float)0x51/0xff alpha:1.0];
}

@end
