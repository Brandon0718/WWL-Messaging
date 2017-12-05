//
//  UITextView+Border.m
//  8a-ios
//
//  Created by Kristoffer Yap on 4/26/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "UITextView+Border.h"

@implementation UITextView (Border)

-(void) setDefaultBorder {
    UIColor *borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = 1.0;
    self.layer.cornerRadius = 5.0;
}

@end
