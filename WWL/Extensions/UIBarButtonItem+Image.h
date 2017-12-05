//
//  UIBarButtonItem+Image.h
//  8a-ios
//
//  Created by Kristoffer Yap on 5/2/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Image)

+(UIBarButtonItem*) buttonItemForImage:(UIImage*) image target:(id)target action:(SEL)action;

@end
