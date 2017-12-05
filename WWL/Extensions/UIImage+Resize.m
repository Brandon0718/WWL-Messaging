//
//  UIImage+Resize.m
//  8a-ios
//
//  Created by Kristoffer Yap on 4/26/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

#define MAX_AVATAR_SIZE 400

- (UIImage*) shrinkForAvatar {
    CGFloat maxDimension;
    CGFloat maxImageSize = MAX_AVATAR_SIZE;
    if(self.size.width <= maxImageSize && self.size.height <= maxImageSize)
        return self;
    
    if(self.size.width > self.size.height){
        maxDimension=self.size.width;
    }else{
        maxDimension=self.size.height;
    }
    
    CGFloat k = maxImageSize/maxDimension;
    CGSize newImageSize = CGSizeMake(self.size.height*k, self.size.width*k);
    return [self resizeImage:self
                  resizeSize:newImageSize];
}

-(UIImage *) resizeImage:(UIImage *)orginalImage resizeSize:(CGSize)size
{
    CGFloat actualHeight = orginalImage.size.height;
    CGFloat actualWidth = orginalImage.size.width;
    
    float oldRatio = actualWidth/actualHeight;
    float newRatio = size.width/size.height;
    if(oldRatio < newRatio)
    {
        oldRatio = size.height/actualHeight;
        actualWidth = oldRatio * actualWidth;
        actualHeight = size.height;
    }
    else
    {
        oldRatio = size.width/actualWidth;
        actualHeight = oldRatio * actualHeight;
        actualWidth = size.width;
    }
    
    CGRect rect = CGRectMake(0.0,0.0,actualWidth,actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [orginalImage drawInRect:rect];
    orginalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return orginalImage;
}


@end
