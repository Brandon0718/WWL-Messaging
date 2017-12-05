//
//  RecordingOptionVC.m
//  WWL
//
//  Created by Kristoffer Yap on 6/29/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "RecordingOptionVC.h"

@interface RecordingOptionVC ()

@end

@implementation RecordingOptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_back"]];
    
    switch([UserContextManager sharedInstance].streamRecordOption) {
        case StreamRecordOptionPhone:
            self.swt_recordDevice.on = YES;
            break;
        case StreamRecordOptionWeb:
            self.swt_recordDevice.on = NO;
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRecordDeviceUpdate:(id)sender {
    if(self.swt_recordDevice.isOn) {
        [UserContextManager sharedInstance].streamRecordOption = StreamRecordOptionPhone;
    } else {
        [UserContextManager sharedInstance].streamRecordOption = StreamRecordOptionWeb;
    }
}

#pragma mark - tableview delegate and data source

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
            titleLabel.text = @"While Streaming";
            break;
        default:
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

@end
