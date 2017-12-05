//
//  TagListView.h
//  TagObjc
//
//  Created by Javi Pulido on 16/7/15.
//  Copyright (c) 2015 Javi Pulido. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagView.h"

IB_DESIGNABLE

@interface TagListView : UIView

typedef NS_ENUM(NSUInteger, TagListAlignment) {
    alignLeft = 0,
    alignCenter,
    alignRight
};

@property (weak, nonatomic) id<TagViewDelegate> tagViewDelegate;

@property (nonatomic) IBInspectable UIColor *textColor;
@property (nonatomic) IBInspectable UIColor *tagBackgroundColor;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat paddingY;
@property (nonatomic) IBInspectable CGPoint paddingX;
@property (nonatomic) IBInspectable CGFloat marginY;
@property (nonatomic) IBInspectable CGFloat marginX;
@property (nonatomic) TagListAlignment alignment;
@property (nonatomic) UIFont *textFont;

// Delegate variables
@property (nonatomic) CGFloat tagViewHeight;
@property (nonatomic) NSMutableArray *tagViews;
@property (nonatomic) NSInteger rows;

- (void)addTagsAccordingToDataSourceArray:(NSArray<NSString *> *)dataSourceArray withOnTapForEach:(void(^)(TagView *tagView))onTapBlock;
- (TagView *)addTag:(long) identifier title:(NSString *)title imageUrl:(NSString*) imageUrl;
- (void)removeTag:(long)identifier;
- (void)removeAllTags;

@end
