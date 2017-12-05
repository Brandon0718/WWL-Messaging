//
//  FavoriteChannelVC.m
//  WWL
//
//  Created by Kristoffer Yap on 6/1/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "FavoriteChannelVC.h"
#import "FavoriteChannelCell.h"
#import "ChannelModel.h"

#import "UIBarButtonItem+Image.h"
#import "UIBarButtonItem+Custom.h"
#import "ChannelsVC.h"

#import "ChannelSelectionCell.h"

@interface FavoriteChannelVC () <UITableViewDelegate, UITableViewDataSource, ChannelSelectedDelegate>
{
    NSMutableArray* mChannels;
}
@end

@implementation FavoriteChannelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    mChannels = [[NSMutableArray alloc] init];
    
    self.tbl_favorite.tableFooterView = [UIView new];
    
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void) loadData {
    __block MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading Channels";
    
    [mChannels removeAllObjects];
    [[MyService shared] getFavoriteChannelObjects:^(BOOL success, id res) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if(success) {
            if ([res[@"status"] isEqualToString:@"ok"]) {
                NSArray* channels = res[@"data"];
                for (NSDictionary* item in channels) {
                    ChannelModel* modelItem = [[ChannelModel alloc] initWith:item];
                    [mChannels addObject:modelItem];
                }
                
                [self.tbl_favorite reloadData];
            } else {
                [self showAlertWithTitle:@"Error" message:@"Failed to load channels."];
            }
        } else {
            NSError* err = (NSError*)res;
            [self showAlertWithTitle:@"Error" message:err.localizedDescription];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Channel Selected Delegate
-(void)channelSelected:(NSArray *)channels {
    if(mChannels.count + channels.count > 3) {
        [self showAlertWithTitle:@"Limit Reached" message:@"Updgrade to premium to save more favorites."];
    } else {
        __block MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Adding Favorite Channels";
        
        [[MyService shared] insertFavoriteChannels:channels block:^(BOOL success, id res) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(success) {
                if ([res[@"status"] isEqualToString:@"ok"]) {
                    [self loadData];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView.tag == 0) {
        return mChannels.count;
    } else {
        return 3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == 0) {
        FavoriteChannelCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FavoriteChannelCell"];
        ChannelModel* item = [mChannels objectAtIndex:indexPath.row];
        [cell configureCell:item];
        return cell;
    } else {
        ChannelSelectionCell* cell = (ChannelSelectionCell*)[tableView dequeueReusableCellWithIdentifier:@"ChannelSelectionCell"];
        
        switch (indexPath.row) {
            case 0:
                [cell configureCell:ChannelAddCellTypeRecent];
                break;
            case 1:
                [cell configureCell:ChannelAddCellTypeNearBy];
                break;
            case 2:
                [cell configureCell:ChannelAddCellTypeSearch];
                break;
            default:
                break;
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView.tag == 1) {
        ChannelsVC *vc =  (ChannelsVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"ChannelsVC" storyboardName:kStoryboardChannel];
        switch (indexPath.row) {
            case 0:
                vc.mode = ChannelSelectionModeRent;
                vc.title = @"Recently Used";
                break;
            case 1:
                vc.mode = ChannelSelectionModeNear;
                vc.title = @"Near By";
                break;
            case 2:
                vc.mode = ChannelSelectionModeSearch;
                vc.title = @"Search";
                break;
            default:
                break;
        }
        
        vc.pageMode = ChannelPageModeSelection;
        vc.selectedDelegate = self;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView.tag == 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ChannelModel* item = [mChannels objectAtIndex:indexPath.row];
        
        __block MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Deleting Favorite";
        [[MyService shared] deleteFavoriteChannel:item block:^(BOOL success, id res) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if(success) {
                if ([res[@"status"] isEqualToString:@"ok"]) {
                    [mChannels removeObjectAtIndex:indexPath.row];
                    [self.tbl_favorite reloadData];
                } else {
                    [self showAlertWithTitle:@"Error" message:@"Failed to remove favorite channel."];
                }
            } else {
                NSError* err = (NSError*)res;
                [self showAlertWithTitle:@"Error" message:err.localizedDescription];
            }
        }];
    }
}

@end
