//
//  MyVideoMapVC.h
//  WWL
//
//  Created by Kristoffer Yap on 5/12/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRightBarButtonVC.h"

@interface MyVideoMapVC : BaseRightBarButtonVC
@property (weak, nonatomic) IBOutlet GMSMapView *view_map;

//@property (strong, nonatomic) NSMutableArray* mStreams;

//- (void) reloadMap;

@end
