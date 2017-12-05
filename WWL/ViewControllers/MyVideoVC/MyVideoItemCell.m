//
//  MyVideoItemCell.m
//  WWL
//
//  Created by Kristoffer Yap on 5/10/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "MyVideoItemCell.h"
#import "ChannelModel.h"
#import "UIColor+WWLColor.h"
#import "FontAwesomeKit.h"
#import "NSString+Date.h"
#import "UIView+Subview.h"

@implementation MyVideoItemCell

-(void) configureCell:(OwnStreamModel*) item {

    CALayer* shouldRemoveLayer;
    for(CALayer* layer in self.view_gradient.layer.sublayers) {
        if([layer isKindOfClass:[CAGradientLayer class]]) {
            shouldRemoveLayer = layer;
            break;
        }
    }
    
    if(shouldRemoveLayer) {
        [shouldRemoveLayer removeFromSuperlayer];
    }
    
    CAGradientLayer* gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor whiteColor].CGColor];
    gradient.locations = @[[NSNumber numberWithFloat:0.2], [NSNumber numberWithFloat:0.5]];
    
    [self.view_gradient.layer insertSublayer:gradient atIndex:0];
    
    self.view_background.layer.cornerRadius = 4.0f;
    self.view_gradient.layer.cornerRadius = 4.0f;
    self.view_gradient.layer.borderColor = [[UIColor barTintColor] CGColor];
    self.view_gradient.layer.borderWidth = 1.0f;
    
    self.iv_thumb.layer.cornerRadius = 4.0f;
    
    
    NSString* encodedString = [item.thumbUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL* url = [NSURL URLWithString:encodedString];
    [self.iv_thumb sd_setImageWithURL:url
                     placeholderImage:[UIImage imageNamed:@"img_default_channel"]];
    
    self.lbl_date.text = [item.createdTime getDaysAgoString];
    self.lbl_location.text = item.locationAddr;
    self.lbl_duration.text = item.duration;
    
    NSError* error;
    self.img_newsType.image = [[FAKFontAwesome iconWithIdentifier:[NSString stringWithFormat:@"fa-%@", item.streamType.icon] size:20.0f error:&error] imageWithSize:self.img_newsType.frame.size];
    
    [self.view_channels removeAllSubviews];
    
    int x = 0;
    for(ChannelModel* channel in item.channels) {
        UIImageView* iv = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, self.view_channels.frame.size.height, self.view_channels.frame.size.height)];
        [iv setContentMode:UIViewContentModeScaleAspectFit];
        x += self.view_channels.frame.size.height + 8;
        
        NSString* encodedString = [channel.thumbUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL* url = [NSURL URLWithString:encodedString];
        [iv sd_setImageWithURL:url
                         placeholderImage:[UIImage imageNamed:@"img_default_channel"]
                                  options:SDWebImageRefreshCached];
        
        [self.view_channels addSubview:iv];
    }
}

@end
