//
//  StoryboardManager.h
//  WWL
//
//  Created by Kristoffer Yap on 5/16/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryboardManager : NSObject

DEFINE_SINGLETON

- (UIViewController *)getViewControllerWithIdentifierFromStoryboard:(NSString *)viewControllerIdentifier storyboardName:(NSString *)storyboardName;
- (UIViewController *)getViewControllerInitial:(NSString *)storyboardName;

@end
