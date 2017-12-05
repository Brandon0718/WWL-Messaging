//
//  MyVideoVC.m
//  WWL
//
//  Created by Kristoffer Yap on 5/9/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <AVKit/AVPlayerViewController.h>
#import <AVFoundation/AVFoundation.h>
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>

#import "WatchNewsVC.h"
#import "WatchNewsItemCell.h"
#import "FilterMenuVC.h"
#import "VideoVC.h"
#import "FilterVC.h"
#import "OwnStreamModel.h"
#import "ChannelModel.h"
#import "MyVideoMapVC.h"
#import "MetaModel.h"
#import "NSString+Date.h"
#import "NSDate+UTCString.h"
#import "WatchNewsFilterVC.h"

#define ITEM_PER_ROW 2

@interface WatchNewsVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate>
{
    UIEdgeInsets        sectionInsets;
    NSMutableArray*     videos;
    int                 mCurPage;
    MetaModel*          metaData;
}
@end

@implementation WatchNewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sectionInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    
    self.mRefreshControl = [[UIRefreshControl alloc] init];
    [self.mRefreshControl setTintColor:[UIColor whiteColor]];
    [self.mRefreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Load More Streams"]];
    [self.mRefreshControl addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventValueChanged];
    
    self.cv_videos.bottomRefreshControl = self.mRefreshControl;
    
    UIBarButtonItem* mFilterItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_filter"] style:UIBarButtonItemStylePlain target:self action:@selector(onFilter)];
    self.navigationItem.rightBarButtonItems = @[mFilterItem];
    
    UIBarButtonItem* hamburgerItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_hamburger"] style:UIBarButtonItemStylePlain target:self action:@selector(onHamburger)];
    
    if([self.navigationController.viewControllers count] == 1) {
        self.navigationItem.leftBarButtonItems = @[hamburgerItem];
    }
    
    mCurPage = 1;
    
    videos = [[NSMutableArray alloc] init];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadStreams:mCurPage block:^(BOOL success) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        mCurPage = metaData.current_page + 1;
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

-(void) onHamburger {
    if(self.sideMenuController.isLeftViewShowing) {
        [self.sideMenuController hideLeftViewAnimated];
    } else {
        [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
    }
}

-(void) onFilter {
    WatchNewsFilterVC* vc = (WatchNewsFilterVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"WatchNewsFilterVC" storyboardName:kStoryboardWatchNews];
    vc.title = @"Filters";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) loadMore {
    [self loadStreams:mCurPage block:^(BOOL success) {
        if(mCurPage <= metaData.total_pages) {
            mCurPage = metaData.current_page + 1;
        }
    }];
}

- (void) loadStreams:(int) page block:(void(^)(BOOL success))block  {
    [[MyService shared] getVODStreams:mCurPage
                                param:[UserContextManager sharedInstance].vodFilterOption
                                block:^(BOOL success, id res) {
                                    [self.mRefreshControl endRefreshing];
                                    
                                    BOOL isSuccess = NO;
                                    if(success) {
                                        if([res[@"status"] isEqualToString:@"ok"]) {
                                            metaData = [[MetaModel alloc] initWith:res];
                                            NSArray* datas = [res objectForKey:@"data"];
                                            
//                                            if(!videos) {
//                                                videos = [[NSMutableArray alloc] init];
//                                            } else {
//                                                [videos removeAllObjects];
//                                            }
                                            
                                            for(NSDictionary* item in datas) {
                                                [videos addObject:[[OwnStreamModel alloc] initWith:item]];
                                            }
                                            [self.cv_videos reloadData];
                                            isSuccess = YES;
                                        }
                                    }
                                    
                                    if(block) {
                                        block(isSuccess);
                                    }
                                }];
}


#pragma mark - Collection View Datasources and Delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"total count:%lu", (unsigned long)videos.count);
    return videos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row < videos.count) {
        WatchNewsItemCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WatchNewsItemCell" forIndexPath:indexPath];
        NSLog(@"videos:%ld, total count:%lu", (long)indexPath.row, (unsigned long)videos.count);
        [cell configureCell:[videos objectAtIndex:indexPath.row]];
        return cell;
    } else {
        return nil;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    OwnStreamModel *selectedModel = [videos objectAtIndex:indexPath.row];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MyService shared] getStreamVideo:(int)selectedModel.stream_id block:^(BOOL success, id res) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(success) {
            if([res[@"status"] isEqualToString:@"ok"]) {
                NSDictionary* data = res[@"data"];
                NSString* url = data[@"url"];
                
                VideoVC* vc = (VideoVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"VideoVC" storyboardName:kStoryboardMain];
                vc.videoURL = [NSURL URLWithString:url];
                vc.isWebVideo = YES;
                vc.model = selectedModel;
                
                [self.navigationController presentViewController:vc animated:YES completion:nil];
            }
        }
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat paddingSize = sectionInsets.left * (ITEM_PER_ROW + 1);
    CGFloat availableWidth = self.cv_videos.frame.size.width - paddingSize;
    CGFloat widthPerItem = availableWidth / ITEM_PER_ROW - 3.0f;
    
    return CGSizeMake(widthPerItem, widthPerItem);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return sectionInsets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return sectionInsets.left;
}

@end
