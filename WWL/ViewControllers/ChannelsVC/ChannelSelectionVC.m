//
//  ChannelSelectionVC.m
//  WWL
//
//  Created by Kristoffer Yap on 6/1/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "ChannelSelectionVC.h"
#import "ChannelSelectionCell.h"
#import "ChannelsVC.h"
#import "UIButton+Border.h"
#import "StreamingVC.h"
#import "ChannelModel.h"
#import "FavPopupCell.h"

#import "UIBarButtonItem+Image.h"
#import "UIBarButtonItem+Custom.h"
#import "INTULocationManager.h"
#import "MenuVC.h"

@interface ChannelSelectionVC () <UITableViewDataSource, UITableViewDelegate, ChannelSelectedDelegate, StreamEndedDelegate, TagViewDelegate>
{
    NSMutableArray* recommendChannels;
    NSMutableArray* selectedChannels;
    NSMutableArray* favCandidateChannels;
    NSMutableArray* favSelectedChannels;
}
@end

@implementation ChannelSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedChannels = [[NSMutableArray alloc] init];
    favCandidateChannels = [[NSMutableArray alloc] init];
    favSelectedChannels = [[NSMutableArray alloc] init];
    recommendChannels = [[NSMutableArray alloc] init];
    
    self.tbl_selectOptions.tableFooterView = [UIView new];
    
    [self.btn_report customBorder];
    
    [self.btn_report setBackgroundColor:[UIColor grayColor]];
    [self.btn_report setEnabled:NO];
    
    // Init Favorite Popup
    self.view_favoritePopupBack.hidden = YES;
    self.view_favoritePopup.layer.cornerRadius = 5.0f;
    
    // Init Recommend Popup
    self.view_recommendBack.hidden = YES;
    self.view_recommendPopup.layer.cornerRadius = 5.0f;
    
    self.view_channelTags.tagBackgroundColor = [UIColor whiteColor];
    self.view_channelTags.textFont = [UIFont systemFontOfSize:14.0f];
    self.view_channelTags.tagViewDelegate = self;
    self.tbl_favoritePopup.tableFooterView = [UIView new];
    
    [self loadRecommends];
}

- (void) loadRecommends {
    __block MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading News Connections";
    [[MyService shared] getChannelConnections:^(BOOL success, id res) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if(success) {
            if ([res[@"status"] isEqualToString:@"ok"]) {
                NSArray* channels = res[@"data"];
                if(channels.count) {
                    [self.btn_report setBackgroundColor:[UIColor clearColor]];
                    [self.btn_report setEnabled:YES];
                    
                    for (NSDictionary* item in channels) {
                        ChannelModel* modelItem = [[ChannelModel alloc] initWith:item];
                        [selectedChannels addObject:modelItem];
                        
                        [self.view_channelTags addTag:modelItem.identifier title:modelItem.name imageUrl:modelItem.thumbUrl];
                    }
                } else {
                    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
                    
                    [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyRoom
                                                       timeout:0.5
                                          delayUntilAuthorized:YES
                                                         block:
                     ^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                         __block MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                         hud.labelText = @"Loading Nearby Connections";
                         
                         [[MyService shared] getNearbyChannels:currentLocation.coordinate callback:^(BOOL success, id res) {
                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                             if(success) {
                                 if ([res[@"status"] isEqualToString:@"ok"]) {
                                     NSArray* channels = res[@"data"];
                                     if(channels.count) {
                                         [self.btn_report setBackgroundColor:[UIColor clearColor]];
                                         [self.btn_report setEnabled:YES];
                                         
                                         for (NSDictionary* item in channels) {
                                             if(selectedChannels.count < 3) {
                                                 ChannelModel* modelItem = [[ChannelModel alloc] initWith:item];
                                                 [selectedChannels addObject:modelItem];
                                                 
                                                 [self.view_channelTags addTag:modelItem.identifier title:modelItem.name imageUrl:modelItem.thumbUrl];
                                             } else {
                                                 break;
                                             }
                                         }
                                     }
                                 } else {
                                    [self showAlertWithTitle:@"Error" message:@"Failed to load channels."];
                                 }
                             } else {
                                 NSError* err = (NSError*)res;
                                 [self showAlertWithTitle:@"Error" message:err.localizedDescription];
                             }
                         }];
                     }];
                }
            } else {
                [self showAlertWithTitle:@"Error" message:@"Failed to load channels."];
            }
        } else {
            NSError* err = (NSError*)res;
            [self showAlertWithTitle:@"Error" message:err.localizedDescription];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - User Actions

- (void) onMessageClicked {
    ChannelListVC *vc = (ChannelListVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"ChannelListVC" storyboardName:kStoryboardTwilio];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onProfileBarButtonClicked {
    [self showProfileVC:ProfileMotivationTypeChannels];
}

- (IBAction)onReport:(id)sender {
    if(![selectedChannels count]) {
        [self showAlertWithTitle:@"Validation" message:@"Please select a channel first!"];
    } else {
        if([[AppDelegate shared] isProfileCompleted]) {
            MBProgressHUD* progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            progressHUD.labelText = @"Please wait...";
            
            // Get Stream types
            [[MyService shared] getStreamTypes:^(BOOL success, id res) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if (success) {
                    if([res[@"status"] isEqualToString:@"ok"]) {
                        StreamingVC *vc = (StreamingVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"StreamingVC" storyboardName:kStoryboardMain];
                        
                        vc.streamDelegate = self;
                        
                        NSMutableArray* types = [[NSMutableArray alloc] init];
                        NSArray* data = res[@"data"];
                        
                        for(NSDictionary* item in data) {
                            StreamTypeModel* model = [[StreamTypeModel alloc] initWith:item];
                            [types addObject:model];
                        }
                        
                        vc.mode = StreamModeNormal;
                        vc.types = types;
                        vc.selectedChannels = selectedChannels;
                        
                        [self.navigationController presentViewController:vc animated:YES completion:nil];
                    }
                } else {
                    NSError* err = (NSError*)res;
                    [self showAlertWithTitle:@"Error" message:err.localizedDescription];
                }
            }];
        } else {
            [self showProfileVC:ProfileMotivationTypeChannels];
        }
    }
}

#pragma mark - Recommed View Events
- (IBAction)onRecommendReport:(id)sender {
    [self.view_recommendBack setHidden:YES];
    
    [selectedChannels addObjectsFromArray:recommendChannels];
    [recommendChannels removeAllObjects];
    
    [self onReport:nil];
}
- (IBAction)onRecommendSkip:(id)sender {
    [self.view_recommendBack setHidden:YES];
}


#pragma mark - TableView Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (tableView.tag) {
        case 0:
            return 4;
        case 1:
            return [recommendChannels count];
        case 2:
            return [favCandidateChannels count];
        default:
            return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == 0) {
        ChannelSelectionCell* cell = (ChannelSelectionCell*)[tableView dequeueReusableCellWithIdentifier:@"ChannelSelectionCell"];
        [cell configureCell:indexPath.row];
        return cell;
    } else if(tableView.tag == 1) {
        FavPopupCell* cell = (FavPopupCell*)[tableView dequeueReusableCellWithIdentifier:@"FavPopupCell"];
        [cell configureCell:[recommendChannels objectAtIndex:indexPath.row]];
        return cell;
    } else if(tableView.tag == 2) {
        FavPopupCell* cell = (FavPopupCell*)[tableView dequeueReusableCellWithIdentifier:@"FavPopupCell"];
        [cell configureCell:[favCandidateChannels objectAtIndex:indexPath.row]];
        return cell;
    } else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView.tag == 0) {
        ChannelsVC *vc =  (ChannelsVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"ChannelsVC" storyboardName:kStoryboardChannel];
        
        switch (indexPath.row) {
            case 0:
                vc.mode = ChannelSelectionModeFavorite;
                vc.title = @"Favorites";
                break;
            case 1:
                vc.mode = ChannelSelectionModeRent;
                vc.title = @"Recently Used";
                break;
            case 2:
                vc.mode = ChannelSelectionModeNear;
                vc.title = @"Near By";
                break;
            case 3:
                vc.mode = ChannelSelectionModeSearch;
                vc.title = @"Search";
                break;
            default:
                break;
        }
        
        vc.selectedDelegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        switch(indexPath.row) {
            case 0:
                break;
            default:
                break;
        }
    } else if (tableView.tag == 2){
        ChannelModel* selectedItem = [favCandidateChannels objectAtIndex:indexPath.row];
        FavPopupCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if([favSelectedChannels containsObject:selectedItem]) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [favSelectedChannels removeObject:selectedItem];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [favSelectedChannels addObject:selectedItem];
        }
    }
}

#pragma mark - Favorite Popup

- (IBAction)onFavorite:(id)sender {
    if(!favSelectedChannels.count) {
        [self showAlertWithTitle:@"Favorites" message:@"Please select the favorite channels!"];
        return;
    }
    
    // Call Favorite Api
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Please Wait";
    [[MyService shared] insertFavoriteChannels:favSelectedChannels block:^(BOOL success, id res) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(success) {
                if ([res[@"status"] isEqualToString:@"ok"]) {
                    [self gotoHomePage];
                    self.view_favoritePopupBack.hidden = YES;
                } else {
                    [self showAlertWithTitle:@"Error" message:@"Failed to load channels."];
                }
            } else {
                NSError* err = (NSError*)res;
                [self showAlertWithTitle:@"Error" message:err.localizedDescription];
            }
    }];
}
- (IBAction)onSkip:(id)sender {
    [self gotoHomePage];
    self.view_favoritePopupBack.hidden = YES;
}

#pragma mark - Tag View Delegate Methods
-(void)tagDeleteReceived:(long)identifier {
    NSArray* filteredArrays = [selectedChannels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %ld", identifier]];
    if(filteredArrays.count) {
        [selectedChannels removeObject:[filteredArrays objectAtIndex:0]];
    }
}

#pragma mark - Channel Selected Delegate Methods
-(void)channelSelected:(NSArray *)channels {
    if(selectedChannels.count + channels.count > 3) {
        [self showAlertWithTitle:@"Limit Reached" message:@"Updgrade to premium to stream to more news connections."];
    } else if([channels count]) {
        for(ChannelModel* item in channels) {
            NSArray* exists = [selectedChannels filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %ld", item.identifier]];
            if(!exists.count) {
                [selectedChannels addObject:item];
                
                [self.btn_report setBackgroundColor:[UIColor clearColor]];
                [self.btn_report setEnabled:YES];
                
                [self.view_channelTags addTag:item.identifier title:item.name imageUrl:item.thumbUrl];
            }
        }
    }
}

#pragma mark - Stream Ended Delegate
-(void)channelStreamEnded:(NSArray *)channels {
    [self.view_favoritePopupBack setHidden:NO];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[MyService shared] getFavoriteChannelIds:^(BOOL success, id res) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if(success) {
            if ([res[@"status"] isEqualToString:@"ok"]) {
                NSArray* channelIds = res[@"data"];
                for(ChannelModel* channel in channels) {
                    BOOL isFavorite = NO;
                    for (NSDictionary* item in channelIds) {
                        if([item objectForKey:@"channel_id"] && [item objectForKey:@"channel_id"] != [NSNull null]) {
                            long identifier = [[item objectForKey:@"channel_id"] longValue];
                            if(channel.identifier == identifier) {
                                isFavorite = YES;
                                break;
                            }
                        }
                    }
                    
                    if(!isFavorite) {
                        [favCandidateChannels addObject:channel];
                    }
                }
                
                if(![favCandidateChannels count]) {
                    [self gotoHomePage];
                    [self.view_favoritePopupBack setHidden:YES];
                } else {
                    [self.tbl_favoritePopup reloadData];
                }
            } else {
                [self showAlertWithTitle:@"Error" message:@"Failed to load favorite channels."];
            }
        } else {
            NSError* err = (NSError*)res;
            [self showAlertWithTitle:@"Error" message:err.localizedDescription];
        }
    }];
}

-(void) gotoHomePage {
    MenuVC* leftVC = (MenuVC*)self.sideMenuController.leftViewController;
    [leftVC gotoHomePage];
}

@end
