//
//  MyLocalVideoVC.m
//  WWL
//
//  Created by Kristoffer Yap on 6/9/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "MyLocalVideoVC.h"
#import "MyLocalVideoCell.h"
#import "MP4Writer.h"
#import "VideoVC.h"

#define ITEM_PER_ROW 2

@interface MyLocalVideoVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>
{
    UIEdgeInsets        sectionInsets;
    NSArray*            mVideos;
    NSURL*              mURL;
}
@end

@implementation MyLocalVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sectionInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    
    // attach long press gesture to collectionView
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    [self.cv_videos addGestureRecognizer:lpgr];
}

- (void) loadData {
    NSArray * paths = [[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
    if (paths.count) {
        mURL = paths.lastObject;
        mURL = [mURL URLByAppendingPathComponent:LOCAL_VIDEO_FOLDER];
        NSArray* tmpVideoFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:mURL.path error:nil];
        
        NSMutableArray* mLocalVideos = [[NSMutableArray alloc] init];
        
        for (NSString *path in tmpVideoFiles) {
            NSURL* fileURL = [mURL URLByAppendingPathComponent:path];
            
            NSDictionary *attr = [NSFileManager.defaultManager attributesOfItemAtPath:fileURL.path error:nil];
            NSDate *createdDate = [attr objectForKey:NSFileCreationDate];
            
            [mLocalVideos addObject:[NSDictionary dictionaryWithObjectsAndKeys:path, @"fileURL", createdDate, @"createdDate", nil]];
        }
        
        NSSortDescriptor *sortedByDate = [NSSortDescriptor sortDescriptorWithKey:@"createdDate"
                                                                     ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortedByDate];
        mVideos = [mLocalVideos sortedArrayUsingDescriptors:sortDescriptors];
    }
    
    [self.cv_videos reloadData];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Datasources and Delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return mVideos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyLocalVideoCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyLocalVideoCell" forIndexPath:indexPath];
    
    [cell configureCell:[[mVideos objectAtIndex:indexPath.row] objectForKey:@"fileURL"] basePath:mURL];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VideoVC"];
    NSString* fileName = [[mVideos objectAtIndex:indexPath.row] objectForKey:@"fileURL"];
    
    NSURL* fileURL = [mURL URLByAppendingPathComponent:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileURL.path]) {
        vc.isWebVideo = NO;
        vc.videoURL = fileURL;
    }

    [self.navigationController presentViewController:vc animated:YES completion:nil];
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

#pragma mark - Gesture Delegate
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint p = [gestureRecognizer locationInView:self.cv_videos];
    
    NSIndexPath *indexPath = [self.cv_videos indexPathForItemAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        // get the cell at indexPath (the one you long pressed)
//        UICollectionViewCell* cell = [self.cv_videos cellForItemAtIndexPath:indexPath];
        // do stuff with the cell
        
        NSString* fileName = [[mVideos objectAtIndex:indexPath.row] objectForKey:@"fileURL"];
        NSURL* fileURL = [mURL URLByAppendingPathComponent:fileName];
        [self presentAskAlert:[NSString stringWithFormat:@"Are you sure to remove %@?", fileName] title:@"Confirm" okText:@"YES" cancelText:@"NO" handler:^(BOOL isPositive) {
            if(isPositive) {
                [[NSFileManager defaultManager] removeItemAtPath: fileURL.path error:nil];
                [self loadData];
            }
        }];
    }
}


@end
