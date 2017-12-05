//
//  PopupChatCell.h
//  WWL
//
//  Created by Kristoffer Yap on 5/17/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupChatCell : UITableViewCell
@property(copy, nonatomic) NSString *user;
@property(copy, nonatomic) NSString *message;
@property(copy, nonatomic) NSString *date;
@end
