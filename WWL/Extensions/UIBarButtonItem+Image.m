//
//  UIBarButtonItem+Image.m
//  8a-ios
//
//  Created by Kristoffer Yap on 5/2/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "UIBarButtonItem+Image.h"

@implementation UIBarButtonItem (Image)

/**
 * Create UIBarButtonItem for a image
 */
+(UIBarButtonItem*) buttonItemForImage:(UIImage*) image target:(id)target action:(SEL)action {
    UIBarButtonItem* item;
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    item = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return item;
}

@end
