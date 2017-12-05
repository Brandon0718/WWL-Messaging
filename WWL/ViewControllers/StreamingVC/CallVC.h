//
//  CallVC.h
//  WWL
//
//  Created by Kristoffer Yap on 5/30/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CallDelegate <NSObject>
-(void) callProecessed:(BOOL) isAccept;
@end


@interface CallVC : UIViewController

@property (nonatomic, weak) id<CallDelegate> callDelegate;

@property (weak, nonatomic) IBOutlet UIView *view_call;
@property (weak, nonatomic) IBOutlet UIImageView *img_avatar;
@property (weak, nonatomic) IBOutlet UILabel *lbl_callLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn_accept;
@property (weak, nonatomic) IBOutlet UIButton *btn_reject;
@property (weak, nonatomic) IBOutlet UILabel *lbl_username;

@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* avatarLink;

@end
