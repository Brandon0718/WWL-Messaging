#import "ChatTableCell.h"

@interface ChatTableCell ()
@property (weak, nonatomic) UILabel *userLabel;
@property (weak, nonatomic) UILabel *messageLabel;
@property (weak, nonatomic) UILabel *dateLabel;

@property (weak, nonatomic) UIView* usernameView;
@property (weak, nonatomic) UIView* messageView;
@end

static NSInteger const TWCUserLabelTag = 200;
static NSInteger const TWCDateLabelTag = 201;
static NSInteger const TWCMessageLabelTag = 202;

static NSInteger const TWCMessageViewTag = 203;
static NSInteger const TWCUsernameViewTag = 204;

@implementation ChatTableCell

- (void)setUser:(NSString *)user {
  self.userLabel.text = user;
}

- (NSString *)user {
  return self.userLabel.text;
}

- (void)setMessage:(NSString *)message {
  self.messageLabel.text = message;
}

- (NSString *)message {
  return self.messageLabel.text;
}

- (void)setDate:(NSString *)date {
  self.dateLabel.text = date;
}

-(void)setIsRead:(BOOL)isRead {
    if(isRead) {
        self.messageLabel.font = [UIFont fontWithName:@"Avenir-Light" size:14.0f];
    } else {
        self.messageLabel.font = [UIFont fontWithName:@"Avenir-Black" size:14.0f];
    }
}

- (NSString *)date {
  return self.messageLabel.text;
}

- (void)awakeFromNib {
  self.userLabel = (UILabel *)[self viewWithTag:TWCUserLabelTag];
  self.dateLabel = (UILabel *)[self viewWithTag:TWCDateLabelTag];
  self.messageLabel = (UILabel *)[self viewWithTag:TWCMessageLabelTag];
    self.usernameView = (UIView *)[self viewWithTag:TWCUsernameViewTag];
    self.messageView = (UIView *)[self viewWithTag:TWCMessageViewTag];
    
    self.usernameView.layer.cornerRadius = 4.0f;
    self.messageView.layer.cornerRadius = 4.0f;
    
  [super awakeFromNib];
}

@end
