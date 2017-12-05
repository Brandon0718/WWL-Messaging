//
//  UIImage+Encode.m
//  8a-ios
//
//  Created by Kristoffer Yap on 5/2/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "UIImage+Encode.h"

@implementation UIImage (Encode)

- (NSString*) encodeImage {
    NSData *imageData = UIImageJPEGRepresentation(self, 1.0);
    NSString *encodedImage = [NSString stringWithFormat:@"data:image/jpeg;base64,%@", [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]];
    return encodedImage;
}

- (NSData*) encodeImageToBinary {
    return UIImageJPEGRepresentation(self, 1.0);
}

+ (UIImage*) decodeImage:(NSString*) base64ImageString {
    NSURL *url = [NSURL URLWithString:base64ImageString];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    return image;
}

@end
