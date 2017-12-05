//
//  StoryboardManager.m
//  WWL
//
//  Created by Kristoffer Yap on 5/16/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "StoryboardManager.h"

@implementation StoryboardManager

IMPLEMENT_SINGLETON

- (UIViewController *)getViewControllerWithIdentifierFromStoryboard:(NSString *)viewControllerIdentifier storyboardName:(NSString *)storyboardName {
    UIStoryboard *stb = [UIStoryboard storyboardWithName: storyboardName bundle: nil];
    UIViewController *vc = [stb instantiateViewControllerWithIdentifier:viewControllerIdentifier];
    return vc;
}

- (UIViewController *)getViewControllerInitial:(NSString *)storyboardName {
    UIStoryboard *mainView = [UIStoryboard storyboardWithName: storyboardName bundle: nil];
    UIViewController *viewcontroller = [mainView instantiateInitialViewController];
    return viewcontroller;
}

@end
