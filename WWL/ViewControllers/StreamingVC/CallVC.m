//
//  CallVC.m
//  WWL
//
//  Created by Kristoffer Yap on 5/30/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "CallVC.h"

@interface CallVC ()

@end

@implementation CallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view_call.layer.cornerRadius = 5.0f;
    
    self.btn_accept.layer.cornerRadius = 3.0f;
    self.btn_reject.layer.cornerRadius = 3.0f;
    
    self.lbl_username.text = self.userName;
    
    [self.img_avatar sd_setImageWithURL:[self.avatarLink getImageURL]
                     placeholderImage:[UIImage imageNamed:@"img_default_avatar"]
                              options:SDWebImageRefreshCached];
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
- (IBAction)onAccept:(id)sender {
    if(self.callDelegate) {
        [self.callDelegate callProecessed:YES];
    }
}

- (IBAction)onReject:(id)sender {
    if(self.callDelegate) {
        [self.callDelegate callProecessed:NO];
    }
}

@end
