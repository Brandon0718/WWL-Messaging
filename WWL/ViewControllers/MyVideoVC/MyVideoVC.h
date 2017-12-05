//
//  MyVideoVC.h
//  WWL
//
//  Created by Kristoffer Yap on 5/9/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyVideoListDelegate <NSObject>
-(void) refreshRequested;
@end

@interface MyVideoVC : UIViewController

@property (nonatomic, weak) id<MyVideoListDelegate> myVideoListDelegate;

@property (weak, nonatomic) IBOutlet UICollectionView *cv_videos;
@property (strong, nonatomic) UIRefreshControl*   mRefreshControl;

@property (strong, nonatomic) NSArray*   myStreams;

@end
