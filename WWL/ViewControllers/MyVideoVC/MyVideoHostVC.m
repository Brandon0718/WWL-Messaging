//
//  MyVideoHostVC.m
//  WWL
//
//  Created by Kristoffer Yap on 5/15/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "MyVideoHostVC.h"
#import "MyVideoVC.h"
#import "MyVideoMapVC.h"
#import "FilterVC.h"
#import "OwnStreamModel.h"
#import "ChannelModel.h"
#import "MetaModel.h"
#import "UIColor+WWLColor.h"
#import "MyLocalVideoVC.h"

@interface MyVideoHostVC () <ViewPagerDelegate, ViewPagerDataSource, MyVideoListDelegate>
{
    int                 mCurPage;
    NSUInteger          mCurSliderPager;
    NSMutableArray*     mMyStreams;
    
    MetaModel*          metaData;
    
    MyVideoVC*          listVC;
    MyVideoMapVC*       mapVC;
    MyLocalVideoVC*     localVideoVC;
}
@end

@implementation MyVideoHostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = self;
    self.delegate = self;
    
    UIBarButtonItem* mFilterItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_filter"] style:UIBarButtonItemStylePlain target:self action:@selector(onFilter)];
    self.navigationItem.rightBarButtonItems = @[mFilterItem];
    
    mMyStreams = [[NSMutableArray alloc] init];
    
    listVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyVideoVC"];
    listVC.myVideoListDelegate = self;
    mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyVideoMapVC"];
    localVideoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyLocalVideoVC"];
    
    UIBarButtonItem* hamburgerItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_hamburger"] style:UIBarButtonItemStylePlain target:self action:@selector(onHamburger)];
    
    if([self.navigationController.viewControllers count] == 1) {
        self.navigationItem.leftBarButtonItems = @[hamburgerItem];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    mCurPage = 1;
    
    if(self.isMapFirst) {
        [self selectTabAtIndex:1];
    }
    
    if(mCurSliderPager == 0) {
        [mMyStreams removeAllObjects];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self loadStreams:mCurPage block:^(BOOL success) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            mCurPage = metaData.current_page + 1;
        }];
    }
}

- (void) onHamburger {
    if(self.sideMenuController.isLeftViewShowing) {
        [self.sideMenuController hideLeftViewAnimated];
    } else {
        [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
    }
}

- (void) loadStreams:(int) page block:(void(^)(BOOL success))block  {
    [[MyService shared] getOwnStreamsForPage:page
                                  channelIds:[AppDelegate shared].selectedChannels
                               streamTypeIds:[AppDelegate shared].selectedNews
                                     dayType:[AppDelegate shared].selectedDayType
                                       block:^(BOOL success, id res) {
                                           [listVC.mRefreshControl endRefreshing];
                                           
                                           BOOL isSuccess = NO;
                                           if(success) {
                                               if([res[@"status"] isEqualToString:@"ok"]) {
                                                   metaData = [[MetaModel alloc] initWith:res];
                                                   NSArray* datas = [res objectForKey:@"data"];
                                                   for(NSDictionary* item in datas) {
                                                       [mMyStreams addObject:[[OwnStreamModel alloc] initWith:item]];
                                                   }
                                                   
                                                   for(OwnStreamModel* item in mMyStreams) {
                                                       NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier = %d", item.streamType.identifier];
                                                       NSArray* tmpArray = [[AppDelegate shared].filterNews filteredArrayUsingPredicate:predicate];
                                                       if(![tmpArray count]) {
                                                           if(item.streamType) {
                                                               [[AppDelegate shared].filterNews addObject:item.streamType];
                                                           }
                                                       }
                                                       
                                                       for(ChannelModel* channelItem in item.channels) {
                                                           predicate = [NSPredicate predicateWithFormat:@"identifier = %d", channelItem.identifier];
                                                           tmpArray = [[AppDelegate shared].filterChannels filteredArrayUsingPredicate:predicate];
                                                           if(![tmpArray count]) {
                                                               [[AppDelegate shared].filterChannels addObject:channelItem];
                                                           }
                                                       }
                                                   }
                                                   
                                                   listVC.myStreams = mMyStreams;
                                                   [listVC.cv_videos reloadData];
                                                   
//                                                   mapVC.mStreams = mMyStreams;
//                                                   [mapVC reloadMap];
                                                   
                                                   isSuccess = YES;
                                               }
                                           }
                                           
                                           if(block) {
                                               block(isSuccess);
                                           }
                                       }];
}

-(void) onFilter {
    FilterVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterVC"];
    vc.mChannels = [AppDelegate shared].filterChannels;
    vc.mNewsTypes = [AppDelegate shared].filterNews;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MyVideoList Delegate Methods
-(void)refreshRequested {
    [self loadStreams:mCurPage block:^(BOOL success) {
        if(mCurPage <= metaData.total_pages) {
            mCurPage = metaData.current_page + 1;
        }
    }];
}

- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 2;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    
    UILabel *label = [UILabel new];
    
    switch(index) {
        case 0:
            label.text = @"On Web";
            break;
        case 1:
            label.text = @"On Device";
            break;
    }
    
    label.textColor = [UIColor whiteColor];
    
    [label sizeToFit];
    
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    switch(index) {
        case 0:
            return listVC;
        case 1:
            return localVideoVC;
        default:
            return nil;
    }
}

-(void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    mCurSliderPager = index;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
        case ViewPagerOptionCenterCurrentTab:
            return 1.0;
        case ViewPagerOptionTabLocation:
            return 1.0;
        case ViewPagerOptionTabHeight:
            return 49.0;
        case ViewPagerOptionTabOffset:
            return 36.0;
        case ViewPagerOptionTabWidth:
            return self.view.frame.size.width / 2;
        case ViewPagerOptionFixFormerTabsPositions:
            return 0.0;
        case ViewPagerOptionFixLatterTabsPositions:
            return 0.0;
        default:
            return value;
    }
}
- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color {
    
    switch (component) {
        case ViewPagerIndicator:
            return [UIColor whiteColor];
        case ViewPagerTabsView:
            return [UIColor barTintColor];
        case ViewPagerContent:
            return [UIColor whiteColor];
        default:
            return color;
    }
}


@end
