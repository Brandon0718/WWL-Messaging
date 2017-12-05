//
//  ChannelCell.m
//  8a-ios
//
//  Created by Kristoffer Yap on 4/28/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "ChannelCell.h"
#import "UIColor+WWLColor.h"
//#import "UIImageView+AFNetworking.h"

@implementation ChannelCell

- (void) configureCell:(ChannelModel*) data {
    self.lbl_title.text = data.name;
    
    if(data.thumbUrl && (NSNull*)data.thumbUrl != [NSNull null]) {
        NSString* encodedString = [data.thumbUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL* url = [NSURL URLWithString:encodedString];
        
        
        [self.iv_logo sd_setImageWithURL:url
                        placeholderImage:[UIImage imageNamed:@"img_default_channel"]
                                 options:SDWebImageRefreshCached];
    }
    
    self.view_fore.layer.cornerRadius = 3;
    self.view_fore.layer.borderColor = [[UIColor clearColor] CGColor];
    self.view_fore.layer.borderWidth = 5.0f;
}

- (void) selectCell:(BOOL) isSelected {
    if(isSelected) {
        self.view_fore.layer.borderColor = [[UIColor orangeColor] CGColor];
        self.lbl_title.textColor = [UIColor defaultColor];
    } else {
        self.view_fore.layer.borderColor = [[UIColor clearColor] CGColor];
        self.lbl_title.textColor = [UIColor blackColor];
    }
}

@end
