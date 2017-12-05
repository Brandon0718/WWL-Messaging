//
//  PopupChatVC.m
//  WWL
//
//  Created by Kristoffer Yap on 5/17/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "PopupChatVC.h"
#import "StatusEntry.h"
#import "PopupChatCell.h"
#import "DateTodayFormatter.h"
#import "NSDate+ISO8601Parser.h"
#import "UIButton+Border.h"
#import "TwilioUserModel.h"
#import "NSString+Regex.h"
#import "UIColor+WWLColor.h"
#import "TwilioChannelInfo.h"

static NSString * const TWCChatCellIdentifier = @"PopupChatTableCell";
static NSString * const TWCChatStatusCellIdentifier = @"PopupChatStatusTableCell";
static NSInteger const TWCLabelTag = 200;

@interface PopupChatVC ()

@property (strong, nonatomic) NSMutableOrderedSet *messages;

@end

@implementation PopupChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bounces = YES;
    self.shakeToClearEnabled = YES;
    self.keyboardPanningEnabled = YES;
    self.shouldScrollToBottomAfterKeyboardShows = NO;
    self.inverted = YES;
    
    UINib *cellNib = [UINib nibWithNibName:TWCChatCellIdentifier bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:TWCChatCellIdentifier];
    
    UINib *cellStatusNib = [UINib nibWithNibName:TWCChatStatusCellIdentifier bundle:nil];
    [self.tableView registerNib:cellStatusNib
         forCellReuseIdentifier:TWCChatStatusCellIdentifier];
    
    self.textInputbar.autoHideRightButton = NO;
    self.textInputbar.maxCharCount = 256;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
    self.textInputbar.counterPosition = SLKCounterPositionTop;
    
    self.textInputbar.textView.keyboardAppearance = UIKeyboardAppearanceDark;
    
    [self.textInputbar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIToolbarPositionAny
                          barMetrics:UIBarMetricsDefault];
    
    [self.textInputbar setBackgroundColor:[UIColor clearColor]];
    
    UIFont *font = [UIFont fontWithName:@"Avenir-Light" size:14];
    self.textView.font = font;
    
    [self.rightButton setTitleColor:[UIColor colorWithRed:0.973 green:0.557 blue:0.502 alpha:1]
                           forState:UIControlStateNormal];
    self.rightButton.backgroundColor = [UIColor blackColor];
    self.rightButton.layer.cornerRadius = 4.0f;
    
    font = [UIFont fontWithName:@"Avenir-Heavy" size:20.0f];
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:font};
    
    self.tableView.allowsSelection = NO;
    self.tableView.estimatedRowHeight = 70;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self scrollToBottomMessage];
    
    TwilioChannelInfo* channelInfo = [[TwilioChannelInfo alloc] initWithChannel:self.channel];
    
    UIButton* doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 76, 16, 60, 36)];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor darkMessageColor] forState:UIControlStateNormal];
    doneButton.backgroundColor = [UIColor clearColor];
    [doneButton customBorder];
    [doneButton addTarget:self action:@selector(onDone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    
    UILabel* channelName = [UILabel new];
    channelName.text = channelInfo.name;
    channelName.font = [UIFont systemFontOfSize:16.0f];
    channelName.textColor = [UIColor darkMessageColor];
    [channelName sizeToFit];
    channelName.frame = CGRectMake(self.view.frame.size.width - 76 - channelName.frame.size.width - 16, 16, channelName.frame.size.width, doneButton.frame.size.height);
    [self.view addSubview:channelName];
    
    UIImageView* channelLogo = [[UIImageView alloc] initWithFrame:CGRectMake(channelName.frame.origin.x - 68, 16, 60, 36)];
    channelLogo.contentMode = UIViewContentModeScaleAspectFit;
    channelLogo.image = [UIImage imageNamed:@"img_default_channel"];
    if([channelInfo.logoURL length]) {
        [channelLogo sd_setImageWithURL:[channelInfo.logoURL getImageURL]
                               placeholderImage:[UIImage imageNamed:@"img_default_channel"]
                                        options:SDWebImageRefreshCached];
    }
    
    [self.view addSubview:channelLogo];
}

-(void) onDone {
    [self dismissViewControllerAnimated:YES completion:^{
        if(self.popupChatDelegate) {
            [self.popupChatDelegate PopupChatClosed];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableOrderedSet *)messages {
    if (!_messages) {
        _messages = [[NSMutableOrderedSet alloc] init];
    }
    return _messages;
}

#pragma mark - Set Channel
- (void)setChannel:(TCHChannel *)channel {
    if ([channel isKindOfClass:[TCHChannelDescriptor class]]) {
        TCHChannelDescriptor *channelDescriptor = (TCHChannelDescriptor*)channel;
        [channelDescriptor channelWithCompletion:^(TCHResult *success, TCHChannel *channel) {
            if (success) {
                [self actuallySetChannel:channel];
            }
        }];
    } else {
        [self actuallySetChannel:channel];
    }
}

- (void)actuallySetChannel:(TCHChannel *)channel {
    _channel = channel;
    self.title = self.channel.friendlyName;
    self.channel.delegate = self;
    
    [self setViewOnHold:YES];
    
    if (self.channel.status != TCHChannelStatusJoined) {
        [self.channel joinWithCompletion:^(TCHResult* result) {
            NSLog(@"%@", @"Channel Joined");
        }];
    }
    if (self.channel.synchronizationStatus != TCHChannelSynchronizationStatusAll) {
        [self.channel synchronizeWithCompletion:^(TCHResult *result) {
            if ([result isSuccessful]) {
                NSLog(@"%@", @"Synchronization started. Delegate method will load messages");
            }
        }];
    }
    else {
        [self loadMessages];
        [self setViewOnHold:NO];
    }
}


#pragma mark - TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    id message = [self.messages objectAtIndex:indexPath.row];
    
    if ([message isKindOfClass:[TCHMessage class]]) {
        cell = [self getChatCellForTableView:tableView forIndexPath:indexPath message:message];
    }
    else {
        cell = [self getStatuCellForTableView:tableView forIndexPath:indexPath message:message];
    }
    
    cell.transform = tableView.transform;
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (PopupChatCell *)getChatCellForTableView:(UITableView *)tableView
                              forIndexPath:(NSIndexPath *)indexPath
                                   message:(TCHMessage *)message {
    UITableViewCell *cell = [self.tableView
                             dequeueReusableCellWithIdentifier:TWCChatCellIdentifier forIndexPath:indexPath];
    
    PopupChatCell *chatCell = (PopupChatCell *)cell;
    
    TwilioUserModel* userModel = [[TwilioUserModel alloc] initWithMessage:message channel:self.channel];
    
    chatCell.user = userModel.name;
    chatCell.date = [[[DateTodayFormatter alloc] init]
                     stringFromDate:[NSDate dateWithISO8601String:message.timestamp]];
    
    chatCell.message = [message.body getFilteredMessage:userModel.name];
    chatCell.backgroundColor = [UIColor clearColor];
    return chatCell;
}

- (UITableViewCell *)getStatuCellForTableView:(UITableView *)tableView
                                 forIndexPath:(NSIndexPath *)indexPath
                                      message:(StatusEntry *)message {
    UITableViewCell *cell = [self.tableView
                             dequeueReusableCellWithIdentifier:TWCChatStatusCellIdentifier forIndexPath:indexPath];
    
    UILabel *label = [cell viewWithTag:TWCLabelTag];
    label.text = [NSString stringWithFormat:@"User %@ has %@",
                  message.member.userInfo.identity, (message.status == TWCMemberStatusJoined) ? @"joined" : @"left"];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)didPressRightButton:(id)sender {
    [self.textView refreshFirstResponder];
    [self sendMessage: [self.textView.text copy]];
    [super didPressRightButton:sender];
}

#pragma mark Chat Service
- (void)sendMessage: (NSString *)inputMessage {
    TCHMessage *message = [self.channel.messages createMessageWithBody:inputMessage];
    [self.channel.messages sendMessage:message completion:nil];
}


#pragma mark - Message List Management
- (void)addMessages:(NSArray *)messages {
    [self.messages addObjectsFromArray:messages];
    [self sortMessages];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        if (self.messages.count > 0) {
            [self scrollToBottomMessage];
        }
    });
}

- (void)sortMessages {
    [self.messages sortUsingDescriptors:@[[[NSSortDescriptor alloc]
                                           initWithKey:@"timestamp" ascending:NO]]];
    
    if([self.messages count]) {
        TCHMessage* message = [self.messages objectAtIndex:0];
        [self.channel.messages advanceLastConsumedMessageIndex:message.index];
    }
}

- (void)scrollToBottomMessage {
    if (self.messages.count == 0) {
        return;
    }
    
    NSIndexPath *bottomMessageIndex = [NSIndexPath indexPathForRow:0
                                                         inSection:0];
    [self.tableView scrollToRowAtIndexPath:bottomMessageIndex
                          atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (void)loadMessages {
    [self.messages removeAllObjects];
    if (self.channel.synchronizationStatus == TCHChannelSynchronizationStatusAll) {
        [self.channel.messages
         getLastMessagesWithCount:100
         completion:^(TCHResult *result, NSArray *messages) {
             if ([result isSuccessful]) {
                 [self addMessages: messages];
             }
         }];
    }
}

- (void)leaveChannel {
    [self.channel leaveWithCompletion:^(TCHResult* result) {
        if ([result isSuccessful]) {
            // Process something after leave
        }
    }];
}


#pragma mark - View Actions
// Disable user input and show activity indicator
- (void)setViewOnHold:(BOOL)onHold {
    self.textInputbarHidden = onHold;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = onHold;
}


#pragma mark - TMMessageDelegate

- (void)chatClient:(TwilioChatClient *)client
           channel:(TCHChannel *)channel
      messageAdded:(TCHMessage *)message {
    if (![self.messages containsObject:message]) {
        [self addMessages:@[message]];
    }
}

- (void)chatClient:(TwilioChatClient *)client
    channelDeleted:(TCHChannel *)channel {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (channel == self.channel) {
            DDLogError(@"Channel Deleted");
        }
    });
}

- (void)chatClient:(TwilioChatClient *)client
           channel:(TCHChannel *)channel
      memberJoined:(TCHMember *)member {
    [self addMessages:@[[StatusEntry statusEntryWithMember:member status:TWCMemberStatusJoined]]];
}

- (void)chatClient:(TwilioChatClient *)client
           channel:(TCHChannel *)channel
        memberLeft:(TCHMember *)member {
    [self addMessages:@[[StatusEntry statusEntryWithMember:member status:TWCMemberStatusLeft]]];
}

- (void)chatClient:(TwilioChatClient *)client channel:(TCHChannel *)channel synchronizationStatusChanged:(TCHChannelSynchronizationStatus)status {
    if (status == TCHChannelSynchronizationStatusAll) {
        [self loadMessages];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self setViewOnHold:NO];
        });
    }
}

@end
