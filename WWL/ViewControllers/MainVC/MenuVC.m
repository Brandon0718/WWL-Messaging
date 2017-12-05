//
//  MenuVC.m
//  WWL
//
//  Created by Kristoffer Yap on 5/21/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "MenuVC.h"
#import "MenuCell.h"
#import "MainVC.h"
#import "ChannelsVC.h"
#import "ChannelModel.h"
#import "MyVideoHostVC.h"
#import "ProfileViewController.h"
#import "StreamingVC.h"
#import "ViewController.h"
#import "RTMPTestVC.h"
#import "SettingsVC.h"
#import "ChannelSelectionVC.h"
#import "FavoriteChannelVC.h"
#import "NewsConnectionVC.h"
#import "MainSettingVC.h"
#import "MyVideoMapVC.h"
#import "WatchNewsVC.h"

@interface MenuVC ()
{
    NSInteger selectedIndex;
}

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation MenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // -----
    
    self.titlesArray = @[@"Home",
                         @"Report News",
                         @"SOS",
                         @"Watch News",
                         @"Map View",
                         @"My Videos",
                         @"My News Connection",
                         @"Chat",
                         @"Settings"];
    
    // -----
    
    self.tableView.contentInset = UIEdgeInsetsMake(44.0, 0.0, 44.0, 0.0);
    
    selectedIndex = 0;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
    cell.titleLabel.text = self.titlesArray[indexPath.row];
    
    switch(indexPath.row) {
        case 0:
            cell.img_icon.image = [UIImage imageNamed:@"icon_menu_home"];
            cell.const_leftMarging.constant = 16;
            cell.iv_background.image = nil;
            break;
        case 1:
            cell.img_icon.image = [UIImage imageNamed:@"icon_menu_report"];
            cell.const_leftMarging.constant = 16;
            cell.iv_background.image = [UIImage imageNamed:@"icon_menu_report_gradient"];
            break;
        case 2:
            cell.img_icon.image = [UIImage imageNamed:@"icon_menu_call_red"];
            cell.const_leftMarging.constant = 16;
            cell.iv_background.image = [UIImage imageNamed:@"icon_menu_sos_gradient"];
            break;
        case 3:
            cell.img_icon.image = [UIImage imageNamed:@"icon_menu_watch"];
            cell.const_leftMarging.constant = 16;
            cell.iv_background.image = nil;
            break;
        case 4:
            cell.img_icon.image = [UIImage imageNamed:@"icon_menu_map"];
            cell.const_leftMarging.constant = 48;
            cell.iv_background.image = nil;
            break;
        case 5:
            cell.img_icon.image = [UIImage imageNamed:@"icon_menu_myvideo"];
            cell.const_leftMarging.constant = 16;
            cell.iv_background.image = nil;
            break;
        case 6:
            cell.img_icon.image = [UIImage imageNamed:@"icon_menu_news_conn"];
            cell.const_leftMarging.constant = 16;
            cell.iv_background.image = nil;
            break;
        case 7:
            cell.img_icon.image = [UIImage imageNamed:@"icon_menu_chat"];
            cell.const_leftMarging.constant = 16;
            cell.iv_background.image = nil;
            break;
        case 8:
            cell.img_icon.image = [UIImage imageNamed:@"icon_menu_settings"];
            cell.const_leftMarging.constant = 16;
            cell.iv_background.image = nil;
            break;
        default:
            break;
    }
    
    if(indexPath.row == 2) {
        [cell.titleLabel setTextColor:[UIColor redColor]];
    }
    
    if(indexPath.row == selectedIndex) {
        [cell selectCell:YES];
    } else {
        [cell selectCell:NO];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MainVC *mainViewController = (MainVC *)self.sideMenuController;
    [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
    
    if(selectedIndex == indexPath.row) {
        return;
    }
    
    if(indexPath.row != 2) {
        MenuCell* oldCell = (MenuCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
        [oldCell selectCell:NO];
        selectedIndex = indexPath.row;
        
        MenuCell* cell = (MenuCell*)[tableView cellForRowAtIndexPath:indexPath];
        [cell selectCell:YES];
    }
    
    UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
    
    switch(indexPath.row) {
        case 0: // Home
        {
            ViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
            [navigationController setViewControllers:@[vc]];
            break;
        }
        case 1: // Report News
        {
            ChannelSelectionVC *vc =  (ChannelSelectionVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"ChannelSelectionVC" storyboardName:kStoryboardChannel];
            vc.title = @"Report News";
            [navigationController setViewControllers:@[vc]];
            break;
        }
        case 2: // SOS
        {
            StreamingVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StreamingVC"];
            vc.mode = StreamModeEmergency;
            [navigationController presentViewController:vc animated:YES completion:nil];
            break;
            
        }
        case 3: // Watch News
        {
            WatchNewsVC* vc = (WatchNewsVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"WatchNewsVC" storyboardName:kStoryboardWatchNews];
            vc.title = @"Watch News";
            [navigationController setViewControllers:@[vc]];
            break;
        }
        case 4: // Map View
        {
            MyVideoMapVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyVideoMapVC"];
            vc.title = @"Map View";
            [navigationController setViewControllers:@[vc]];
            break;
        }
        case 5: // My Videos
        {
            MyVideoHostVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyVideoHostVC"];
            vc.title = @"My Videos";
            [navigationController setViewControllers:@[vc]];
            break;
        }
        case 6: // My News Connection
        {
            NewsConnectionVC *vc =  (NewsConnectionVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"NewsConnectionVC" storyboardName:kStoryboardChannel];
            vc.title = @"My News Connection";
            [navigationController setViewControllers:@[vc]];
            break;
        }
        case 7: // Chat
        {
            ChannelListVC *vc = (ChannelListVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"ChannelListVC" storyboardName:kStoryboardTwilio];
            [navigationController setViewControllers:@[vc]];
            break;
        }
        case 8: // Settings
        {
            MainSettingVC *vc = (MainSettingVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"MainSettingVC" storyboardName:kStoryboardSetting];
            vc.title = @"Settings";
            [navigationController setViewControllers:@[vc]];
            break;
        }
        default:
        {
            NSString* title = self.titlesArray[indexPath.row];
            [mainViewController.rootViewController presentSimpleAlert:[NSString stringWithFormat:@"%@ feature coming soon!", title] title:@"Coming Soon"];
            break;
        }
    }
}

- (void) gotoHomePage {
    MainVC *mainViewController = (MainVC *)self.sideMenuController;
    [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
    
    if(selectedIndex == 0) {
        return;
    }
    
    MenuCell* oldCell = (MenuCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
    [oldCell selectCell:NO];
    selectedIndex = 0;
    
    MenuCell* cell = (MenuCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell selectCell:YES];
    
    UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
    
    ViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [navigationController setViewControllers:@[vc]];
}


@end
