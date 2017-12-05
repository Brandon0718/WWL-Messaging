//
//  TagView.h
//  TagObjc
//
//  Created by Javi Pulido on 16/7/15.
//  Copyright (c) 2015 Javi Pulido. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@protocol TagViewDelegate <NSObject>

- (void) tagDeleteReceived:(long) identifier;

@end

@interface TagView : UIButton

- (instancetype) initWithTitle:(long) identifier title:(NSString *)title imageUrl:(NSString*) imageURL;

@property (weak, nonatomic) id<TagViewDelegate> tagViewDelegate;

@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat paddingY;
@property (nonatomic) IBInspectable CGPoint paddingX;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, strong) IBInspectable UIColor *textColor;
@property (nonatomic, strong) IBInspectable UIColor *selectedTextColor;
@property (nonatomic, strong) IBInspectable UIColor *tagBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *highlightedBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *selectedBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *selectedBorderColor;
@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, assign) long identifier;
@property (nonatomic, strong) UIImageView* imgView;
@property (nonatomic, strong) UIImageView* closeView;

@property (nonatomic, copy) void (^onTap)(TagView *);

@end
