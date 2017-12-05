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

#import "MyVideoVC.h"
#import "MyVideoItemCell.h"
#import "FilterMenuVC.h"
#import "VideoVC.h"
#import "FilterVC.h"
#import "OwnStreamModel.h"
#import "ChannelModel.h"
#import "MyVideoMapVC.h"
#import "MetaModel.h"
#import "NSString+Date.h"
#import "NSDate+UTCString.h"

#define ITEM_PER_ROW 2

@interface MyVideoVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate>
{
    UIEdgeInsets        sectionInsets;
}
@end

@implementation MyVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sectionInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    
    self.mRefreshControl = [[UIRefreshControl alloc] init];
    [self.mRefreshControl setTintColor:[UIColor whiteColor]];
    [self.mRefreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"Load More Streams"]];
    [self.mRefreshControl addTarget:self action:@selector(loadMore) forControlEvents:UIControlEventValueChanged];
    
    self.cv_videos.bottomRefreshControl = self.mRefreshControl;
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

-(void) loadMore {
    if(self.myVideoListDelegate) {
        [self.myVideoListDelegate refreshRequested];
    }
}

#pragma mark - Collection View Datasources and Delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.myStreams.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyVideoItemCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyVideoItemCell" forIndexPath:indexPath];
    [cell configureCell:[self.myStreams objectAtIndex:indexPath.row]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    OwnStreamModel *selectedModel = [self.myStreams objectAtIndex:indexPath.row];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MyService shared] getStreamVideo:(int)selectedModel.stream_id block:^(BOOL success, id res) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(success) {
            if([res[@"status"] isEqualToString:@"ok"]) {
                NSDictionary* data = res[@"data"];
                NSString* url = data[@"url"];
                
                VideoVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoVC"];
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
