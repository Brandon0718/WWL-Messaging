//
//  UIImage+Encode.h
//  8a-ios
//
//  Created by Kristoffer Yap on 5/2/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Encode)

- (NSString*) encodeImage;
+ (UIImage*) decodeImage:(NSString*) base64ImageString;
- (NSData*) encodeImageToBinary;
@end
