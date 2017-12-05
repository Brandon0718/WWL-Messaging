//
//  ChannelListVC.m
//  WWL
//
//  Created by Kristoffer Yap on 5/16/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "ChannelListVC.h"
#import "ChannelListCell.h"
#import "ChannelManager.h"
#import "ConversationVC.h"
//#import "ChatVC.h"

@interface ChannelListVC () 

@end

@implementation ChannelListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Chat";
    [ChannelManager sharedManager].delegate = self;
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

- (void)viewWillAppear:(BOOL)animated {
    if([[MessagingManager sharedManager].client synchronizationStatus] != TCHClientSynchronizationStatusCompleted) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

#pragma mark - UITableView Delegates

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ChannelManager sharedManager].channels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChannelListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelListCell"];
    
    TCHChannel *channel = [[ChannelManager sharedManager].channels objectAtIndex:indexPath.row];
    [cell configureCell:channel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ConversationVC *vc = (ConversationVC*)[[StoryboardManager sharedInstance] getViewControllerWithIdentifierFromStoryboard:@"ConversationVC" storyboardName:kStoryboardTwilio];
    [vc setChannel:[[ChannelManager sharedManager].channels objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
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

-(void)chatClient:(TwilioChatClient *)client synchronizationStatusChanged:(TCHClientSynchronizationStatus)status {
    if(status == TCHClientSynchronizationStatusCompleted) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

@end
