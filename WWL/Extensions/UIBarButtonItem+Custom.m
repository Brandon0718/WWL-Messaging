    //
//  UIBarButtonItem+Custom.m
//  WWL
//
//  Created by Kristoffer Yap on 5/15/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "UIBarButtonItem+Custom.h"
#import "UIView+Subview.h"
#import "UIColor+WWLColor.h"

@implementation UIBarButtonItem (Custom)

+(nullable UIBarButtonItem *) initForMessageItem:(nullable id)target action:(nullable SEL)action
{
    //Setup right navigation bar item
    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32.0f, 26.0f)];
    
    // Join Badge Tap Gesture to button event
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapGesture.cancelsTouchesInView = NO;
    [itemView addGestureRecognizer:tapGesture];
    
    UIImageView* iv = [[UIImageView alloc] initWithFrame:itemView.bounds];
    iv.image = [UIImage imageNamed:@"icon_chat"];
    iv.contentMode = UIViewContentModeScaleAspectFit;
    [itemView addSubview:iv];
    
    //Check if there is badges unread and add notification bubble to rigth navigation bar item
    UILabel* messageCntLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 30.0f, 22.0f)];
    messageCntLabel.textColor = [UIColor barTintColor];
    messageCntLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    messageCntLabel.tag = TAG_LBL_RECEIVED_CNT;
    messageCntLabel.textAlignment = NSTextAlignmentCenter;
    [itemView addSubview:messageCntLabel];
    
    UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.frame = CGRectMake(0.0f, 1.0f, 30.0f, 22.0f);
    [spinner setColor:[UIColor barTintColor]];
    spinner.tag = TAG_LBL_SPINNER;
    [itemView addSubview:spinner];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:itemView];
    return barButtonItem;
}

- (void) updateMessageCountLabel:(int) count {
    UILabel* messageCntLabel = [self.customView getSubview:TAG_LBL_RECEIVED_CNT];
    if(messageCntLabel) {
        if(count) {
            messageCntLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)count];
        } else {
            messageCntLabel.text = @"";
        }
    }
}

- (void) startMessageLoadAnimation:(BOOL) isStart {
    UIActivityIndicatorView* spinner = [self.customView getSubview:TAG_LBL_SPINNER];
    if(isStart) {
        [spinner setHidden:NO];
        [spinner startAnimating];
    } else {
        [spinner setHidden:YES];
        [spinner stopAnimating];
    }
}

@end
