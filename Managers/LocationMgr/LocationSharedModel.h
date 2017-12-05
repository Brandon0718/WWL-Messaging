//
//  LocationSharedModel.h
//  WWL
//
//  Created by Kristoffer Yap on 6/27/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BackgroundTaskManager.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationSharedModel : NSObject

@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimer * delay10Seconds;
@property (nonatomic) BackgroundTaskManager * bgTask;
@property (nonatomic) NSMutableArray *myLocationArray;

+(id)sharedModel;

@end
