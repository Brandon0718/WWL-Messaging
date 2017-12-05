//
//  MainVC.m
//  WWL
//
//  Created by Kristoffer Yap on 5/21/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "MainVC.h"

@interface MainVC ()

@property (assign, nonatomic) NSUInteger type;

@end

@implementation MainVC

-(void)viewDidLoad {
    self.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;
}

- (void)leftViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super leftViewWillLayoutSubviewsWithSize:size];
    
    if (!self.isLeftViewStatusBarHidden) {
        self.leftView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
    }
}

- (void)rightViewWillLayoutSubviewsWithSize:(CGSize)size {
    [super rightViewWillLayoutSubviewsWithSize:size];
    
    if (!self.isRightViewStatusBarHidden ||
        (self.rightViewAlwaysVisibleOptions & LGSideMenuAlwaysVisibleOnPadLandscape &&
         UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
         UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation))) {
            self.rightView.frame = CGRectMake(0.0, 20.0, size.width, size.height-20.0);
        }
}

- (BOOL)isLeftViewStatusBarHidden {
    return super.isLeftViewStatusBarHidden;
}

- (BOOL)isRightViewStatusBarHidden {
    if (self.type == 8) {
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication.statusBarOrientation) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    }
    
    return super.isRightViewStatusBarHidden;
}

- (void)dealloc {
    NSLog(@"MainViewController deallocated");
}

@end
