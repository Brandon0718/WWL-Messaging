//
//  UIViewController+Alert.h
//  WWL
//
//  Created by Kristoffer Yap on 5/21/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Alert)

typedef void (^AlertCallback)(BOOL isPositive);

- (void)presentSimpleAlert:(NSString*) message title:(NSString*)title;
- (void)presentAskAlert:(NSString*) message title:(NSString*)title okText:(NSString*) okText cancelText:(NSString*) cancelText handler:(AlertCallback) callback;

@end
