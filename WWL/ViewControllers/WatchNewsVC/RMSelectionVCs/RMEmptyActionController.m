//
//  RMCustomViewActionController.m
//  RMActionController-Demo
//
//  Created by Roland Moers on 17.05.15.
//  Copyright (c) 2015 Roland Moers. All rights reserved.
//

#import "RMEmptyActionController.h"

@implementation RMEmptyActionController

#pragma mark - Init and Dealloc
- (instancetype)initWithStyle:(RMActionControllerStyle)aStyle title:(NSString *)aTitle message:(NSString *)aMessage selectAction:(RMAction *)selectAction andCancelAction:(RMAction *)cancelAction {
    self = [super initWithStyle:aStyle title:aTitle message:aMessage selectAction:selectAction andCancelAction:cancelAction];
    if(self) {
        self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
        self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSDictionary *bindings = @{@"contentView": self.contentView};
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[contentView(>=300)]" options:0 metrics:nil views:bindings]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentView(0)]" options:0 metrics:nil views:bindings]];
    }
    return self;
}

@end
