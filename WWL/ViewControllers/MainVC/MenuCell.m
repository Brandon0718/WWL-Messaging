//
//  MenuCell.m
//  WWL
//
//  Created by Kristoffer Yap on 5/21/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "MenuCell.h"
#import "UIColor+WWLColor.h"

@implementation MenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.titleLabel.alpha = highlighted ? 0.5 : 1.0;
}

- (void) selectCell:(BOOL) isSelected {
    if(isSelected) {
        self.backgroundColor = [UIColor barTintColor];
        [self.seperatorView setHidden:YES];
    } else {
        self.backgroundColor = [UIColor clearColor];
        [self.seperatorView setHidden:NO];
    }
    
}

@end
