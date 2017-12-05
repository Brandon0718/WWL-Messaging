//
//  VideoVC.h
//  WWL
//
//  Created by Kristoffer Yap on 5/14/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <AVKit/AVKit.h>
#import "OwnStreamModel.h"

@interface VideoVC : AVPlayerViewController

@property (nonatomic, assign) BOOL isWebVideo;
@property (nonatomic, strong) NSURL* videoURL;
@property (nonatomic, strong) OwnStreamModel* model;

@end
