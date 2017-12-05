//
//  ChannelsVC.h
//  8a-ios
//
//  Created by Kristoffer Yap on 4/28/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRightBarButtonVC.h"

typedef NS_ENUM(NSInteger, ChannelSelectionMode) {
    ChannelSelectionModeFavorite,
    ChannelSelectionModeRent,
    ChannelSelectionModeNear,
    ChannelSelectionModeSearch,
    ChannelSelectionModeSelectFavorite,
};

typedef NS_ENUM(NSInteger, ChannelPageMode) {
    ChannelPageModeSelection,
    ChannelPageModeBrowse,
};

@protocol ChannelSelectedDelegate <NSObject>

- (void) channelSelected:(NSArray*) channels;

@end

@interface ChannelsVC : BaseRightBarButtonVC

@property (weak, nonatomic) id<ChannelSelectedDelegate> selectedDelegate;

@property (weak, nonatomic) IBOutlet UICollectionView *cv_channels;
@property (weak, nonatomic) IBOutlet UIButton *btn_report;

@property (assign, nonatomic) ChannelSelectionMode mode;
@property (assign, nonatomic) ChannelPageMode pageMode;

@end
