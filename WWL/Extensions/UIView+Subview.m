//
//  UIView+Subview.m
//  WWL
//
//  Created by Kristoffer Yap on 5/15/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "UIView+Subview.h"

@implementation UIView (Subview)

-(id) getSubview:(int) tag {
    for (UIView* view in self.subviews) {
        if(view.tag == tag) {
            return  view;
        }
    }
    
    return nil;
}

-(void) removeAllSubviews {
    for (UIView* view in self.subviews) {
        [view removeFromSuperview];
    }
}

@end
