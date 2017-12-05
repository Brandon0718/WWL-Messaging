//
//  ConversationVC.m
//  WWL
//
//  Created by Kristoffer Yap on 5/19/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "ConversationVC.h"
#import "StatusEntry.h"
#import "TwilioUserModel.h"
#import "NSString+Regex.h"
#import "TwilioChannelInfo.h"

@interface ConversationVC ()
{
    UIView*             customNavTitleView;
    NSMutableDictionary* avatarDic;
}

@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) TwilioUserModel* userInfo;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@end

@implementation ConversationVC


#pragma mark - View lifecycle

/**
 *  Override point for customization.
 *
 *  Customize your view.
 *  Look at the properties on `JSQMessagesViewController` and `JSQMessagesCollectionView` to see what is possible.
 *
 *  Customize your layout.
 *  Look at the properties on `JSQMessagesCollectionViewFlowLayout` to see what is possible.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    avatarDic = [[NSMutableDictionary alloc] init];
    
    self.inputToolbar.contentView.textView.pasteDelegate = self;
    self.showLoadEarlierMessagesHeader = NO;
    
    self.messages = [[NSMutableArray alloc] init];
    self.userInfo = [[TwilioUserModel alloc] initWithTCHUserInfo:[MessagingManager sharedManager].client.userInfo];
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    /**
     *  Register custom menu actions for cells.
     */
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];
    
    
    /**
     *  OPT-IN: allow cells to be deleted
     */
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(delete:)];
    
    /**
     *  Customize your toolbar buttons
     *
     *  self.inputToolbar.contentView.leftBarButtonItem = custom button or nil to remove
     *  self.inputToolbar.contentView.rightBarButtonItem = custom button or nil to remove
     */
    
    /**
     *  Set a maximum height for the input toolbar
     *
     *  self.inputToolbar.maximumHeight = 150;
     */
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /**
     *  Enable/disable springy bubbles, default is NO.
     *  You must set this from `viewDidAppear:`
     *  Note: this feature is mostly stable, but still experimental
     */
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
    
    [self.channel.messages setAllMessagesConsumed];
}

- (void) setupCustomTitleView {
    if(customNavTitleView == nil) {
        TwilioChannelInfo* channelInfo = [[TwilioChannelInfo alloc] initWithChannel:self.channel];
        
        self.title = @"";
        customNavTitleView = [[UIView alloc] initWithFrame:CGRectZero];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.text = channelInfo.name;
        [label sizeToFit];
        label.frame = CGRectMake(16, 0, label.frame.size.width, label.frame.size.height);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(label.frame.size.width + 24, (label.frame.size.height - 16) / 2, 28, 16)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        customNavTitleView.frame = CGRectMake(0, 0, label.frame.size.width + 52, label.frame.size.height);
        
        if([channelInfo.logoURL length]) {
            [imageView sd_setImageWithURL:[channelInfo.logoURL getImageURL]
                                   placeholderImage:[UIImage imageNamed:@"img_default_channel"]
                                            options:SDWebImageRefreshCached];
        }
        
        [customNavTitleView addSubview:label];
        [customNavTitleView addSubview:imageView];
        
        self.navigationItem.titleView = customNavTitleView;
    }
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
    [self setupCustomTitleView];
    self.channel.delegate = self;
    
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
    }
}

#pragma mark - Message List Management
- (void)addMessages:(NSArray *)messages {
    for(TCHMessage* tchMessage in messages) {
        TwilioUserModel* userInfo = [[TwilioUserModel alloc] initWithMessage:tchMessage channel:self.channel];
        
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:userInfo.identity
                                                 senderDisplayName:userInfo.name
                                                              date:tchMessage.timestampAsDate
                                                              text:[tchMessage.body getFilteredMessage:userInfo.name]];
        [self.messages addObject:message];
        
        if(![avatarDic objectForKey:message.senderId] && [userInfo.avatarLink length]) {
            [[SDWebImageManager sharedManager] loadImageWithURL:[userInfo.avatarLink getImageURL] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if(image) {
                    [avatarDic setObject:image forKey:message.senderId];
                    [self.collectionView reloadData];
                }
            }];
        }
    }
    
    // Workaround to load first messages without animation
    if([messages count] > 3) {
        [self finishSendingMessageAnimated:NO];
    } else {
        [self finishSendingMessageAnimated:YES];
    }
    
}

- (void)loadMessages {
    [self.messages removeAllObjects];
    if (self.channel.synchronizationStatus == TCHChannelSynchronizationStatusAll) {
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Loading Messages";
        [self.channel.messages
         getLastMessagesWithCount:100
         completion:^(TCHResult *result, NSArray *messages) {
             [hud hide:YES];
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


#pragma mark - Custom menu actions for cells

- (void)didReceiveMenuWillShowNotification:(NSNotification *)notification
{
    /**
     *  Display custom menu actions for cells.
     */
    UIMenuController *menu = [notification object];
    menu.menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"Custom Action" action:@selector(customAction:)] ];
    
    [super didReceiveMenuWillShowNotification:notification];
}


#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    TCHMessage *message = [self.channel.messages createMessageWithBody:text];
    [self.channel.messages sendMessage:message completion:nil];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    [self.inputToolbar.contentView.textView resignFirstResponder];
}

#pragma mark - TMMessageDelegate

- (void)chatClient:(TwilioChatClient *)client
           channel:(TCHChannel *)channel
      messageAdded:(TCHMessage *)message {
    if (![self.messages containsObject:message]) {
        [self addMessages:@[message]];
    }
    
    [self.channel.messages setAllMessagesConsumed];
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
    }
}

#pragma mark - JSQMessages CollectionView DataSource

- (NSString *)senderId {
    return self.userInfo.identity;
}

- (NSString *)senderDisplayName {
    return self.userInfo.name;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    [self.messages removeObjectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    
    return self.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    
    JSQMessagesAvatarImage* avatar;
    
    if(![avatarDic objectForKey:message.senderId]) {
        avatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"img_default_avatar"] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    } else {
        avatar = [JSQMessagesAvatarImageFactory avatarImageWithImage:[avatarDic objectForKey:message.senderId] diameter:kJSQMessagesCollectionViewAvatarSizeDefault];
    }
    
    return avatar;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 5 == 0) {
        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.messages objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}

- (BOOL)shouldShowAccessoryButtonForMessage:(id<JSQMessageData>)message
{
    return NO;
}


#pragma mark - UICollectionView Delegate

#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{
    NSLog(@"Custom action received! Sender: %@", sender);
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.messages objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

#pragma mark - JSQMessagesComposerTextViewPasteDelegate methods

- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender
{
    if ([UIPasteboard generalPasteboard].image) {
        // If there's an image in the pasteboard, construct a media item with that image and `send` it.
        JSQPhotoMediaItem *item = [[JSQPhotoMediaItem alloc] initWithImage:[UIPasteboard generalPasteboard].image];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                                 senderDisplayName:self.senderDisplayName
                                                              date:[NSDate date]
                                                             media:item];
        [self.messages addObject:message];
        [self finishSendingMessage];
        return NO;
    }
    return YES;
}

#pragma mark - JSQMessagesViewAccessoryDelegate methods

- (void)messageView:(JSQMessagesCollectionView *)view didTapAccessoryButtonAtIndexPath:(NSIndexPath *)path
{
    NSLog(@"Tapped accessory button!");
}

@end
