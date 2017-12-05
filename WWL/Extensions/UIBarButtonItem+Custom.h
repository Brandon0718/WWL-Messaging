//
//  UIBarButtonItem+Custom.h
//  WWL
//
//  Created by Kristoffer Yap on 5/15/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_LBL_RECEIVED_CNT        1000
#define TAG_LBL_SPINNER             1001

@interface UIBarButtonItem (Custom)

+(nullable UIBarButtonItem *) initForMessageItem:(nullable id)target action:(nullable SEL)action;

- (void) updateMessageCountLabel:(int) count;
- (void) startMessageLoadAnimation:(BOOL) isStart;

@end
