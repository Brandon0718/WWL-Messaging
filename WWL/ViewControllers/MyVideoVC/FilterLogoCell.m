//
//  FilterLogoCell.m
//  WWL
//
//  Created by Kristoffer Yap on 5/11/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "FilterLogoCell.h"
#import "FontAwesomeKit.h"

@implementation FilterLogoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureCell:(ChannelModel*) model {
    self.isChannel = YES;
    self.channel = model;
    
    NSString* encodedString = [model.thumbUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL* url = [NSURL URLWithString:encodedString];
    
    [self.iv_logo sd_setImageWithURL:url
                    placeholderImage:[UIImage imageNamed:@"img_default_channel"]
                             options:SDWebImageRefreshCached];
    
    self.lbl_title.text = model.name;
}

- (void) configureCellForNews:(StreamTypeModel*) model {
    self.isChannel = NO;
    self.newsType = model;
    
    self.lbl_title.text = model.name;
    
    NSError* error;
    self.iv_logo.image = [[FAKFontAwesome iconWithIdentifier:[NSString stringWithFormat:@"fa-%@", model.icon] size:30.0f error:&error] imageWithSize:self.iv_logo.frame.size];
}

@end
