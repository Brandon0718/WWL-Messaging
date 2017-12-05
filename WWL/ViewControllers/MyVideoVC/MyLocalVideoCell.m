//
//  MyLocalVideoCell.m
//  WWL
//
//  Created by Kristoffer Yap on 6/9/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MyLocalVideoCell.h"

@implementation MyLocalVideoCell

-(void) configureCell:(NSString*) fileName basePath:(NSURL*) basePath {
    self.view_back.layer.cornerRadius = 4.0f;
    self.view_back.layer.borderColor = [[UIColor barTintColor] CGColor];
    self.view_back.layer.borderWidth = 1.0f;
    
    NSURL* fileURL = [basePath URLByAppendingPathComponent:fileName];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        UIImage *thumbnailImage = [self thumbnailImageFromURL:fileURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.iv_thumb.image = thumbnailImage;
        });
    });
    
    unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:fileURL.path error:nil] fileSize];
    unsigned long long fileSizeK = fileSize / 1024;
    
    self.lbl_file_name.text = fileName;
    self.lbl_size.text = [NSString stringWithFormat:@"%lld KBytes", fileSizeK];
    
}

- (UIImage *)thumbnailImageFromURL:(NSURL *)videoURL {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL: videoURL options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    NSError *err = NULL;
    CMTime requestedTime = CMTimeMake(1, 60);     // To create thumbnail image
    CGImageRef imgRef = [generator copyCGImageAtTime:requestedTime actualTime:NULL error:&err];
    NSLog(@"err = %@, imageRef = %@", err, imgRef);
    
    UIImage *thumbnailImage = [[UIImage alloc] initWithCGImage:imgRef];
    CGImageRelease(imgRef);    // MUST release explicitly to avoid memory leak
    
    return thumbnailImage;
}

@end
