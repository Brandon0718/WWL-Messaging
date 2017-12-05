//
//  SettingsVC.h
//  WWL
//
//  Created by Kristoffer Yap on 6/1/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsVC : UITableViewController
@property (weak, nonatomic) IBOutlet UITableViewCell *cell_video_288p;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell_video_480p;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell_video_720p;
@property (weak, nonatomic) IBOutlet UITableViewCell *cell_video_1080p;

@end
