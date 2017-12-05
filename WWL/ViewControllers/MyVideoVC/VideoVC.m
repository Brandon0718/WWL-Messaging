//
//  VideoVC.m
//  WWL
//
//  Created by Kristoffer Yap on 5/14/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "VideoVC.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+Date.h"

@interface VideoVC ()
{
    UIView* infoView;
}
@end

@implementation VideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.player = [[AVPlayer alloc] initWithURL:self.videoURL];
    [self.player play];
    
    if(self.isWebVideo) {
        [self initInfoView];
    }
}

- (void) initInfoView {
    infoView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 48.0f, [[UIScreen mainScreen] bounds].size.width, 120.0f)];
    [infoView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:infoView];
    
    UILabel* streamNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width / 2 - 16.0f, 30.0f)];
    streamNameLabel.numberOfLines = 0;
    streamNameLabel.textColor = [UIColor whiteColor];
    streamNameLabel.font = [UIFont systemFontOfSize:14.0f];
    streamNameLabel.text = [NSString stringWithFormat:@"Stream Name: %@", self.model.streamName];
    
    UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, 30.0f, [[UIScreen mainScreen] bounds].size.width / 2 - 16.0f, 30.0f)];
    dateLabel.numberOfLines = 0;
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.font = [UIFont systemFontOfSize:14.0f];
    dateLabel.text = [self.model.createdTime getDaysAgoString];
    dateLabel.text = [NSString stringWithFormat:@"Date: %@", [self.model.createdTime getDaysAgoString]];
    
    UILabel* durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, 60.0f, [[UIScreen mainScreen] bounds].size.width / 2 - 16.0f, 30.0f)];
    durationLabel.numberOfLines = 0;
    durationLabel.textColor = [UIColor whiteColor];
    durationLabel.font = [UIFont systemFontOfSize:14.0f];
    durationLabel.text = [NSString stringWithFormat:@"Duration: %@", self.model.duration];
    
    UILabel* locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, 90.0f, [[UIScreen mainScreen] bounds].size.width - 32.0f, 30.0f)];
    locationLabel.numberOfLines = 0;
    locationLabel.textColor = [UIColor whiteColor];
    locationLabel.font = [UIFont systemFontOfSize:12.0f];
    locationLabel.text = [NSString stringWithFormat:@"Address: %@", self.model.locationAddr];
    
    [infoView addSubview:streamNameLabel];
    [infoView addSubview:locationLabel];
    [infoView addSubview:dateLabel];
    [infoView addSubview:durationLabel];
    
    UIImageView* iv_newsType = [[UIImageView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width / 2, 10.0f, 35.0f, 35.0f)];
    iv_newsType.contentMode = UIViewContentModeScaleAspectFill;
    iv_newsType.image = [self.model.streamType.name getNewsTypeImage];
    [infoView addSubview:iv_newsType];
    
    UIView* view_channels = [[UIView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width / 2, 45.0f, [[UIScreen mainScreen] bounds].size.width / 2 - 16.0f, 45.0f)];
    
    
    int x = 0;
    float width = ([[UIScreen mainScreen] bounds].size.width / 2 - 16.0f - 32.0f) / 5;
    float height = 37.0f;
    
    for(ChannelModel* channel in self.model.channels) {
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, 4.0f, width, height)];
        [iv setContentMode:UIViewContentModeScaleAspectFit];
        x += width + 8;
        
        NSString* encodedString = [channel.thumbUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL* url = [NSURL URLWithString:encodedString];
        [iv sd_setImageWithURL:url
              placeholderImage:[UIImage imageNamed:@"img_default_channel"]
                       options:SDWebImageRefreshCached];
        
        [view_channels addSubview:iv];
    }
    [infoView addSubview:view_channels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(self.isWebVideo) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // unregister keyboard notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationMaskLandscapeLeft] forKey:@"orientation"];
}

-(void) onOrientationDidChange:(NSNotification*) notification {
    UIDevice * device = notification.object;
    
    switch (device.orientation) {
        case UIDeviceOrientationLandscapeRight:
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationFaceUp:
            [infoView setHidden:YES];
            break;
        default:
            [infoView setHidden:NO];
            break;
    }
}

@end
