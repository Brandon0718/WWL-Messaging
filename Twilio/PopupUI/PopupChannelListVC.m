//
//  PopupChannelListVC.m
//  WWL
//
//  Created by Kristoffer Yap on 5/17/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "PopupChannelListVC.h"
#import "PopupChannelListCell.h"
#import "PopupChatVC.h"

@interface PopupChannelListVC ()

@end

@implementation PopupChannelListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [ChannelManager sharedManager].popupDelegate = self;
    [self reloadChannelList];
    
    [self.tbl_channelList setTableFooterView:[[UIView alloc] init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadChannelList {
    [self.tbl_channelList reloadData];
}

#pragma mark - UITableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ChannelManager sharedManager].channels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopupChannelListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"PopupChannelListCell"];
    
    TCHChannel *channel = [[ChannelManager sharedManager].channels objectAtIndex:indexPath.row];
    [cell configureCell:channel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self dismissViewControllerAnimated:YES completion:^{
        if(self.channelSelectedDelegate) {
            [self.channelSelectedDelegate channelSelected:[[ChannelManager sharedManager].channels objectAtIndex:indexPath.row]];
        }
    }];
    
}

#pragma mark - TwilioChatClientDelegate delegate
-(void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel messageAdded:(TCHMessage *)message {
    [self.tbl_channelList reloadData];
}

- (void)chatClient:(TwilioChatClient *)client channelAdded:(TCHChannel *)channel {
    [self.tbl_channelList reloadData];
}

- (void)chatClient:(TwilioChatClient *)client channelChanged:(TCHChannel *)channel {
    [self.tbl_channelList reloadData];
}

- (void)chatClient:(TwilioChatClient *)client channelDeleted:(TCHChannel *)channel {
    [self.tbl_channelList reloadData];
}

@end
