//
//  ChannelsVC.m
//  8a-ios
//
//  Created by Kristoffer Yap on 4/28/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "ChannelsVC.h"
#import "ChannelCell.h"
#import "StreamingVC.h"
#import "UIColor+WWLColor.h"
#import "LandNavVC.h"
#import "StreamingVC.h"
#import "StreamTypeModel.h"
#import "UIButton+Border.h"
#import "INTULocationManager.h"

#import "UIBarButtonItem+Image.h"
#import "UIBarButtonItem+Custom.h"

#define ITEM_PER_ROW 2

@interface ChannelsVC () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchControllerDelegate>
{
    NSMutableArray* mChannels;
    NSArray* mChannelsForSearch;
    NSMutableArray* selectedChannels;
    
    UIEdgeInsets sectionInsets;
}

@property (nonatomic)        BOOL               searchBarActive;
@property (nonatomic)        float              searchBarBoundsY;

@property (nonatomic,strong) UISearchBar        *searchBar;

@end

@implementation ChannelsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    sectionInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    
    mChannels = [[NSMutableArray alloc] init];
    selectedChannels = [[NSMutableArray alloc] init];
    mChannelsForSearch = [[NSMutableArray alloc] init];
    
    [self loadData];
    
    if(self.mode == ChannelSelectionModeSearch) {
        [self addSearchBar];
    }
    
    if(self.pageMode == ChannelPageModeBrowse) {
        self.btn_report.hidden = YES;
    } else {
        self.btn_report.hidden = NO;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.btn_report customBorder];
    [self.btn_report setEnabled:NO];
    
    if([selectedChannels count]) {
        [self setButtonDisable:NO];
    } else {
        [self setButtonDisable:YES];
    }
}

-(void)dealloc{
    // remove Our KVO observer
    if(self.mode == ChannelSelectionModeSearch) {
        [self removeObservers];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addSearchBar {
    if (!self.searchBar) {
        self.searchBarBoundsY = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,self.searchBarBoundsY, [UIScreen mainScreen].bounds.size.width, 60)];
        self.searchBar.searchBarStyle       = UISearchBarStyleMinimal;
        self.searchBar.tintColor            = [UIColor whiteColor];
        self.searchBar.barTintColor         = [UIColor whiteColor];
        self.searchBar.delegate             = self;
        self.searchBar.placeholder          = @"search here";
        
        [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor whiteColor]];
        
        // add KVO observer.. so we will be informed when user scroll colllectionView
        [self addObservers];
    }
    
    if (![self.searchBar isDescendantOfView:self.view]) {
        [self.view addSubview:self.searchBar];
    }
}

#pragma mark - observer
- (void)addObservers{
    [self.cv_channels addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}
- (void)removeObservers{
    [self.cv_channels removeObserver:self forKeyPath:@"contentOffset" context:Nil];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(UICollectionView *)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"] && object == self.cv_channels ) {
        self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x,
                                          self.searchBarBoundsY + ((-1* object.contentOffset.y)-self.searchBarBoundsY),
                                          self.searchBar.frame.size.width,
                                          self.searchBar.frame.size.height);
    }
}

- (void) loadData {
    __block MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading Channels";
    
    if(self.mode == ChannelSelectionModeFavorite) {
        [[MyService shared] getFavoriteChannelObjects:^(BOOL success, id res) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(success) {
                if ([res[@"status"] isEqualToString:@"ok"]) {
                    NSArray* channels = res[@"data"];
                    for (NSDictionary* item in channels) {
                        ChannelModel* modelItem = [[ChannelModel alloc] initWith:item];
                        [mChannels addObject:modelItem];
                    }
                    [self.cv_channels reloadData];
                } else {
                    [self showAlertWithTitle:@"Error" message:@"Failed to load channels."];
                }
            } else {
                NSError* err = (NSError*)res;
                [self showAlertWithTitle:@"Error" message:err.localizedDescription];
            }
        }];
    } else if(self.mode == ChannelSelectionModeNear) {
        INTULocationManager *locMgr = [INTULocationManager sharedInstance];
        
        [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyRoom
                                           timeout:0.5
                              delayUntilAuthorized:YES
                                             block:
         ^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
             [[MyService shared] getNearbyChannels:currentLocation.coordinate callback:^(BOOL success, id res) {
                 [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                 if(success) {
                     if ([res[@"status"] isEqualToString:@"ok"]) {
                         NSArray* channels = res[@"data"];
                         for (NSDictionary* item in channels) {
                             ChannelModel* modelItem = [[ChannelModel alloc] initWith:item];
                             [mChannels addObject:modelItem];
                         }
                         [self.cv_channels reloadData];
                     } else {
                         [self showAlertWithTitle:@"Error" message:@"Failed to load channels."];
                     }
                 } else {
                     NSError* err = (NSError*)res;
                     [self showAlertWithTitle:@"Error" message:err.localizedDescription];
                 }
             }];
         }];
    } else if(self.mode == ChannelSelectionModeRent) {
        [[MyService shared] getRecentChannels:^(BOOL success, id res) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(success) {
                if ([res[@"status"] isEqualToString:@"ok"]) {
                    NSArray* channels = res[@"data"];
                    for (NSDictionary* item in channels) {
                        ChannelModel* modelItem = [[ChannelModel alloc] initWith:item];
                        [mChannels addObject:modelItem];
                    }
                    [self.cv_channels reloadData];
                } else {
                    [self showAlertWithTitle:@"Error" message:@"Failed to load channels."];
                }
            } else {
                NSError* err = (NSError*)res;
                [self showAlertWithTitle:@"Error" message:err.localizedDescription];
            }
        }];
    } else {
        [[MyService shared] getChannels:^(BOOL success, id res) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(success) {
                if ([res[@"status"] isEqualToString:@"ok"]) {
                    NSArray* channels = res[@"data"];
                    for (NSDictionary* item in channels) {
                        ChannelModel* modelItem = [[ChannelModel alloc] initWith:item];
                        [mChannels addObject:modelItem];
                    }
                    [self.cv_channels reloadData];
                } else {
                    [self showAlertWithTitle:@"Error" message:@"Failed to load channels."];
                }
            } else {
                NSError* err = (NSError*)res;
                [self showAlertWithTitle:@"Error" message:err.localizedDescription];
            }
        }];
    }
}

- (void) onMessageClicked {
    ChannelListVC *vc = (ChannelListVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"ChannelListVC" storyboardName:kStoryboardTwilio];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onProfileBarButtonClicked {
    [self showProfileVC:ProfileMotivationTypeChannels];
}

- (void) setButtonDisable:(BOOL) disable {
    if(disable) {
        [self.btn_report setBackgroundColor:[UIColor grayColor]];
        [self.btn_report setEnabled:NO];
    } else {
        [self.btn_report setBackgroundColor:[UIColor clearColor]];
        [self.btn_report setEnabled:YES];
    }
}

- (IBAction)onReport:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if(self.selectedDelegate) {
        [self.selectedDelegate channelSelected:selectedChannels];
    }
}

#pragma mark - Collection View Datasources and Delegates

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.searchBarActive) {
        return mChannelsForSearch.count;
    }
    return mChannels.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChannelCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ChannelCell" forIndexPath:indexPath];
    
    if (self.searchBarActive) {
        [cell configureCell:[mChannelsForSearch objectAtIndex:indexPath.row]];
    }else{
        [cell configureCell:[mChannels objectAtIndex:indexPath.row]];
    }
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.pageMode == ChannelPageModeBrowse) {
        return;
    }
    
    ChannelModel *selectedModel;
    if (self.searchBarActive) {
        selectedModel = [mChannelsForSearch objectAtIndex:indexPath.row];
    } else {
        selectedModel = [mChannels objectAtIndex:indexPath.row];
    }
    
    ChannelCell* cell = (ChannelCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if([selectedChannels containsObject:selectedModel]) {
        [selectedChannels removeObject:selectedModel];
        [cell selectCell:NO];
    } else {
        [selectedChannels addObject:selectedModel];
        [cell selectCell:YES];
    }
    
    if([selectedChannels count]) {
        [self setButtonDisable:NO];
    } else {
        [self setButtonDisable:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat paddingSize = sectionInsets.left * (ITEM_PER_ROW + 1);
    CGFloat availableWidth = self.cv_channels.frame.size.width - paddingSize;
    CGFloat widthPerItem = availableWidth / ITEM_PER_ROW - 4.0f;
    
    CGFloat heightPerItem = widthPerItem / 16 * 9 + 16 +17;
    
    return CGSizeMake(widthPerItem, heightPerItem);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(self.searchBar.frame.size.height + sectionInsets.top, sectionInsets.left, sectionInsets.right, sectionInsets.bottom);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return sectionInsets.left;
}

#pragma mark - search
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    mChannelsForSearch = [mChannels filteredArrayUsingPredicate:resultPredicate];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    // user did type something, check our datasource for text that looks the same
    if (searchText.length>0) {
        // search and reload data source
        self.searchBarActive = YES;
        [self filterContentForSearchText:searchText
                                   scope:[[self.searchBar scopeButtonTitles]
                                          objectAtIndex:[self.searchBar
                                                         selectedScopeButtonIndex]]];
        [self.cv_channels reloadData];
    }else{
        // if text lenght == 0
        // we will consider the searchbar is not active
        self.searchBarActive = NO;
        [self.cv_channels reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self cancelSearching];
    [self.cv_channels reloadData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchBarActive = YES;
    [self.view endEditing:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // we used here to set self.searchBarActive = YES
    // but we'll not do that any more... it made problems
    // it's better to set self.searchBarActive = YES when user typed something
    [self.searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // this method is being called when search btn in the keyboard tapped
    // we set searchBarActive = NO
    // but no need to reloadCollectionView
    self.searchBarActive = NO;
    [self.searchBar setShowsCancelButton:NO animated:YES];
}
-(void)cancelSearching{
    self.searchBarActive = NO;
    [self.searchBar resignFirstResponder];
    self.searchBar.text  = @"";
}

@end
