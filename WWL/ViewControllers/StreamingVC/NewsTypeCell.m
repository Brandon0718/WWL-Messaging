//
//  NewsTypeCell.m
//  8a-ios
//
//  Created by Kristoffer Yap on 5/2/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "NewsTypeCell.h"
#import "UIColor+WWLColor.h"
#import "FontAwesomeKit.h"

@interface NewsTypeCell()
{
    StreamTypeModel* itemData;
}
@end

@implementation NewsTypeCell

-(void) configureCell:(StreamTypeModel*) data {
    itemData = data;
    
    if([data.name isEqualToString:@"Fire"]) {
        self.img_back.image = [UIImage imageNamed:@"icon_type_fire"];
    } else if([data.name isEqualToString:@"Accident"]) {
        self.img_back.image = [UIImage imageNamed:@"icon_type_accident"];
    } else if([data.name isEqualToString:@"Crime"]) {
        self.img_back.image = [UIImage imageNamed:@"icon_type_crime"];
    } else if([data.name isEqualToString:@"War"]) {
        self.img_back.image = [UIImage imageNamed:@"icon_type_war"];
    } else if([data.name isEqualToString:@"Politics"]) {
        self.img_back.image = [UIImage imageNamed:@"icon_type_politics"];
    } else if([data.name isEqualToString:@"Weather"]) {
        self.img_back.image = [UIImage imageNamed:@"icon_type_weather"];
    } else if([data.name isEqualToString:@"Celebrities"]) {
        self.img_back.image = [UIImage imageNamed:@"icon_type_celebrities"];
    } else if([data.name isEqualToString:@"Sports"]) {
        self.img_back.image = [UIImage imageNamed:@"icon_type_sports"];
    } else if([data.name isEqualToString:@"Other"]) {
        self.img_back.image = [UIImage imageNamed:@"icon_type_other"];
    }
}

-(void) selectCell:(BOOL) isSelect {
    if(isSelect) {
        self.backgroundView.backgroundColor = [UIColor defaultColor];
    } else {
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
}

@end
