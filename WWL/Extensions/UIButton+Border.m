//
//  UIButton+Border.m
//  8a-ios
//
//  Created by Kristoffer Yap on 5/3/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "UIButton+Border.h"

@implementation UIButton (Border)

-(void) customBorder {
    self.layer.cornerRadius = 5.0f;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.layer.borderWidth = 2.0f;
}

@end
