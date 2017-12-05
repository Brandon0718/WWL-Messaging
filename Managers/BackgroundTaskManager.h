//
//  BackgroundTaskManager.h
//  WWL
//
//  Created by Kristoffer Yap on 6/27/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackgroundTaskManager : NSObject

+(instancetype)sharedBackgroundTaskManager;

-(UIBackgroundTaskIdentifier)beginNewBackgroundTask;
-(void)endAllBackgroundTasks;

@end
