//
//  WatchNewsVC.h
//  WWL
//
//  Created by Kristoffer Yap on 6/22/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WatchNewsVC : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *cv_videos;
@property (strong, nonatomic) UIRefreshControl*   mRefreshControl;
@end
