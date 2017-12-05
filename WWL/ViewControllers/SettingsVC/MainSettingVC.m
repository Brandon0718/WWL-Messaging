//
//  MainSettingVC.m
//  WWL
//
//  Created by Kristoffer Yap on 6/5/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "MainSettingVC.h"
#import "SettingsVC.h"
#import "ProfileViewController.h"
#import "RecordingOptionVC.h"

@interface MainSettingVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation MainSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 1;
        default:
            return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.section) {
        case 0:
        {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"Video Streaming Resolution";
            } else if(indexPath.row == 1) {
                cell.textLabel.text = @"Recording Preferences";
            }
            break;
        }
        case 1:
        {
            if(indexPath.row == 0) {
                cell.textLabel.text = @"My Profile";
            }
            break;
        }
        default:
            break;
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            if(indexPath.row == 0) { // Streaming Resolution
                SettingsVC *vc = (SettingsVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"SettingsVC" storyboardName:kStoryboardSetting];
                [self.navigationController pushViewController:vc animated:YES];
            } else if(indexPath.row == 1) { // Recording Preference
                RecordingOptionVC* vc = (RecordingOptionVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"RecordingOptionVC" storyboardName:kStoryboardSetting];
                vc.title = @"Recording Options";
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        }
        case 1:
        {
            if(indexPath.row == 0) {    // My Profile
                [self showProfileVC:ProfileMotivationTypeProfile];
            }
            break;
        }
        default:
            break;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 35.0f)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, 5.0f, tableView.bounds.size.width, 30.0f)];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    titleLabel.textColor = [UIColor whiteColor];
    switch (section) {
        case 0:
            titleLabel.text = @"Stream Settings";
            break;
        case 1:
            titleLabel.text = @"Profile Settings";
            break;
    }
    
    [headerView addSubview:titleLabel];
    
    UIView *topBorderView = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5f, tableView.bounds.size.width, 0.5f)];
    [topBorderView setBackgroundColor:[UIColor borderColor]];
    [headerView addSubview:topBorderView];
    
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 0.5f)];
    [footerView setBackgroundColor:[UIColor borderColor]];
    return footerView;
}

@end
