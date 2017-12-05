//
//  FilterMenuVC.m
//  WWL
//
//  Created by Kristoffer Yap on 5/10/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "FilterMenuVC.h"

@interface FilterMenuVC () <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* menuList;
}
@end

@implementation FilterMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    menuList = [[NSMutableArray alloc] init];
    
    NSNumber* item = [NSNumber numberWithInt:MyVideoFilterTypeNone];
    [menuList addObject:item];
    
    item = [NSNumber numberWithInt:MyVideoFilterTypeChannels];
    [menuList addObject:item];
    
    item = [NSNumber numberWithInt:MyVideoFilterTypeNews];
    [menuList addObject:item];
    
    item = [NSNumber numberWithInt:MyVideoFilterTypeMap];
    [menuList addObject:item];
    
    item = [NSNumber numberWithInt:MyVideoFilterTypeLast7Days];
    [menuList addObject:item];
    
    item = [NSNumber numberWithInt:MyVideoFilterTypeLast2Weeks];
    [menuList addObject:item];
    
    item = [NSNumber numberWithInt:MyVideoFilterTypeLast1Month];
    [menuList addObject:item];
    
    item = [NSNumber numberWithInt:MyVideoFilterTypeLast3Months];
    [menuList addObject:item];
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

#pragma mark - tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menuList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FilterMenuCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FilterMenuCell"];
    
    NSNumber* item = [menuList objectAtIndex:indexPath.row];
    MyVideoFilterType itemType = (MyVideoFilterType)[item intValue];
    
    if(itemType == self.selectedFilterType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [cell configureCell:itemType];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for(int i = 0; i < [menuList count]; i++) {
        FilterMenuCell* cell = (FilterMenuCell*)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    NSNumber* item = [menuList objectAtIndex:indexPath.row];
    MyVideoFilterType itemType = (MyVideoFilterType)[item intValue];
    
    FilterMenuCell* cell = (FilterMenuCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    if(self.myVideoFilterDelegate) {
        [self.myVideoFilterDelegate myVideoFilterSelected:itemType];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

@end
