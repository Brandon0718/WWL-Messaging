//
//  FilterVC.m
//  WWL
//
//  Created by Kristoffer Yap on 5/11/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "FilterVC.h"
#import "UIColor+WWLColor.h"
#import "FilterNormalCell.h"
#import "FilterLogoCell.h"
#import "MyService.h"

@interface FilterVC () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* dateTypes;
    
    UITableViewCell* activatedCell;
}
@end

@implementation FilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Filter Options";
    // Do any additional setup after loading the view.
    dateTypes = [[NSMutableArray alloc] init];
    [dateTypes addObject:[NSNumber numberWithInt:DayFilterTypeLast7Days]];
    [dateTypes addObject:[NSNumber numberWithInt:DayFilterTypeLast2Weeks]];
    [dateTypes addObject:[NSNumber numberWithInt:DayFilterTypeLast1Month]];
    [dateTypes addObject:[NSNumber numberWithInt:DayFilterTypeLast3Months]];
    
    [self.tbl_filters reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch(section) {
        case 0:
            return self.mChannels.count;
        case 1:
            return self.mNewsTypes.count;
        case 2:
            return dateTypes.count;
        default:
            return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell;
    switch (indexPath.section) {
        case 0:
        {
            ChannelModel* item = [self.mChannels objectAtIndex:indexPath.row];
            FilterLogoCell* channelCell = (FilterLogoCell*)[tableView dequeueReusableCellWithIdentifier:@"FilterLogoCell"];
            [channelCell configureCell:item];
            if([item containedTo:[AppDelegate shared].selectedChannels]) {
                [channelCell setAccessoryType:UITableViewCellAccessoryCheckmark];
            } else {
                [channelCell setAccessoryType:UITableViewCellAccessoryNone];
            }

            cell = channelCell;
            break;
        }
        case 1:
        {
            StreamTypeModel* item = [self.mNewsTypes objectAtIndex:indexPath.row];
            FilterLogoCell* newsCell = (FilterLogoCell*)[tableView dequeueReusableCellWithIdentifier:@"FilterLogoCell"];
            [newsCell configureCellForNews:item];
            if([item containedTo:[AppDelegate shared].selectedNews]) {
                [newsCell setAccessoryType:UITableViewCellAccessoryCheckmark];
            } else {
                [newsCell setAccessoryType:UITableViewCellAccessoryNone];
            }
            
            cell = newsCell;
            break;
        }
        case 2:
        {
            FilterNormalCell* dateCell = (FilterNormalCell*)[tableView dequeueReusableCellWithIdentifier:@"FilterNormalCell"];
            DayFilterType type = (DayFilterType)[[dateTypes objectAtIndex:indexPath.row] intValue];
            [dateCell configureCell:type];
            if([AppDelegate shared].selectedDayType == type) {
                [dateCell setAccessoryType:UITableViewCellAccessoryCheckmark];
                activatedCell = dateCell;
            } else {
                [dateCell setAccessoryType:UITableViewCellAccessoryNone];
            }
            
            cell = dateCell;
            break;
        }
        default:
            break;
    }
    
    return cell;
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
    [headerView setBackgroundColor:[UIColor sectionColor]];
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, 5.0f, tableView.bounds.size.width, 30.0f)];
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    titleLabel.textColor = [UIColor darkGrayColor];
    switch (section) {
        case 0:
            titleLabel.text = @"Channels";
            break;
        case 1:
            titleLabel.text = @"Nes Types";
            break;
        case 2:
            titleLabel.text = @"Dates";
            break;
        default:
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
    
    
    switch (indexPath.section) {
        case 0:
        {
            ChannelModel* selectedModel = [self.mChannels objectAtIndex:indexPath.row];
            if([selectedModel containedTo:[AppDelegate shared].selectedChannels]) {
                [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
                [selectedModel removeFrom:[AppDelegate shared].selectedChannels];
            } else {
                [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
                [[AppDelegate shared].selectedChannels addObject:selectedModel];
            }
            break;
        }
        case 1:
        {
            StreamTypeModel* selectedModel = [self.mNewsTypes objectAtIndex:indexPath.row];
            if([selectedModel containedTo:[AppDelegate shared].selectedNews]) {
                [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
                [selectedModel removeFrom:[AppDelegate shared].selectedNews];
            } else {
                [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
                [[AppDelegate shared].selectedNews addObject:selectedModel];
            }
            break;
        }
        case 2:
        {
            int tableSelectedDayType = [[dateTypes objectAtIndex:indexPath.row] intValue];
            if(activatedCell) {
                [activatedCell setAccessoryType:UITableViewCellAccessoryNone];
            }
            
            [AppDelegate shared].selectedDayType = tableSelectedDayType;
            [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
            activatedCell = [tableView cellForRowAtIndexPath:indexPath];
            
            break;
        }
        default:
            break;
    }
}

@end
