//
//  UIView+Subview.h
//  WWL
//
//  Created by Kristoffer Yap on 5/15/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Subview)

-(id) getSubview:(int) tag;
-(void) removeAllSubviews;

@end
