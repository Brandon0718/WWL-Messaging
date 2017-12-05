//
//  SettingsVC.m
//  WWL
//
//  Created by Kristoffer Yap on 6/1/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "SettingsVC.h"

@interface SettingsVC ()
{
    UITableViewCell* activatedCell;
}
@end

@implementation SettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Video Streaming Resolution";
    UIBarButtonItem* hamburgerItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_hamburger"] style:UIBarButtonItemStylePlain target:self action:@selector(onHamburger)];
    
    if([self.navigationController.viewControllers count] == 1) {
        self.navigationItem.leftBarButtonItems = @[hamburgerItem];
    }
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_back"]];
}

- (void) onHamburger {
    if(self.sideMenuController.isLeftViewShowing) {
        [self.sideMenuController hideLeftViewAnimated];
    } else {
        [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    StreamResolution curOption = (StreamResolution)[UserContextManager sharedInstance].streamResolution;
    
    switch (curOption) {
        case StreamResolution288p:
            self.cell_video_288p.accessoryType = UITableViewCellAccessoryCheckmark;
            activatedCell = self.cell_video_288p;
            break;
        case StreamResolution480p:
            self.cell_video_480p.accessoryType = UITableViewCellAccessoryCheckmark;
            activatedCell = self.cell_video_480p;
            break;
        case StreamResolution720p:
            self.cell_video_720p.accessoryType = UITableViewCellAccessoryCheckmark;
            activatedCell = self.cell_video_720p;
            break;
        case StreamResolution1080p:
            self.cell_video_1080p.accessoryType = UITableViewCellAccessoryCheckmark;
            activatedCell = self.cell_video_1080p;
            break;
        default:
            break;
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


#pragma mark - TableView Delegate

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
    titleLabel.textColor = [UIColor darkGrayColor];
    switch (section) {
        case 0:
            titleLabel.text = @"";
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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
    if(activatedCell) {
        activatedCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if(indexPath.section == 0) {
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        activatedCell = cell;
        [UserContextManager sharedInstance].streamResolution = (NSInteger)indexPath.row;
    }
}

@end
