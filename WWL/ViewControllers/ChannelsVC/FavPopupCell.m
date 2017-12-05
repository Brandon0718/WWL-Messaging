//
//  FavPopupCell.m
//  WWL
//
//  Created by Kristoffer Yap on 6/2/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "FavPopupCell.h"

@implementation FavPopupCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCell:(ChannelModel*) data {
    self.lbl_name.text = data.name;
    self.img_logo.layer.borderColor = [[UIColor barTintColor] CGColor];
    self.img_logo.layer.borderWidth = 1.0f;
    
    if(data.thumbUrl && (NSNull*)data.thumbUrl != [NSNull null]) {
        NSString* encodedString = [data.thumbUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL* url = [NSURL URLWithString:encodedString];
        
        
        [self.img_logo sd_setImageWithURL:url
                        placeholderImage:[UIImage imageNamed:@"img_default_channel"]
                                 options:SDWebImageRefreshCached];
    }
}

@end
