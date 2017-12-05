//
//  TagView.m
//  TagObjc
//
//  Created by Javi Pulido on 16/7/15.
//  Copyright (c) 2015 Javi Pulido. All rights reserved.
//

#import "TagView.h"

@implementation TagView

@synthesize textColor =_textColor;
@synthesize textFont = _textFont;

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self setupView];
    }
    return self;
}

- (instancetype) initWithTitle:(long) identifier title:(NSString *)title imageUrl:(NSString*) imageURL {
    self = [super init];
    if(self) {
        self.identifier = identifier;
        self.imgView = [[UIImageView alloc] init];
        [self.imgView sd_setImageWithURL:[imageURL getImageURL] placeholderImage:[UIImage imageNamed:@"img_channel_default"]];
        [self addSubview:self.imgView];
        
        self.closeView = [[UIImageView alloc] init];
        [self.closeView setImage:[UIImage imageNamed:@"icon_red_close"]];
        [self.closeView setUserInteractionEnabled:YES];
        [self addSubview:self.closeView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeTag)];
        tapGesture.cancelsTouchesInView = NO;
        [self.closeView addGestureRecognizer:tapGesture];
        
        [self setTitle:title forState:UIControlStateNormal];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    CGSize intrinsicSize = [self intrinsicContentSize];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, intrinsicSize.width, intrinsicSize.height);
}

- (void) removeTag {
    if(self.tagViewDelegate) {
        [self.tagViewDelegate tagDeleteReceived:self.identifier];
    }   
}

# pragma mark - Getters (default values)

- (UIColor *)textColor {
    if(!_textColor) {
        _textColor = [UIColor whiteColor];
    }
    return _textColor;
}

- (UIFont *)textFont {
    if(!_textFont) {
        _textFont = [UIFont systemFontOfSize:12];
    }
    return _textFont;
}

# pragma mark - Setters

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = self.cornerRadius > 0;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
    [self reloadStyles];
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    [self setTitleColor:textColor forState:UIControlStateNormal];
    [self reloadStyles];
}

- (void)selectedTextColor:(UIColor *)selectedTextColor {
    _selectedTextColor = selectedTextColor;
    [self setTitleColor:selectedTextColor forState:UIControlStateSelected];
    [self reloadStyles];
}

- (void)setPaddingY:(CGFloat)paddingY {
    _paddingY = paddingY;
    UIEdgeInsets insets = [self titleEdgeInsets];
    insets.top = paddingY;
    insets.bottom = paddingY;
    [self setTitleEdgeInsets:insets];
}

- (void)setPaddingX:(CGPoint)paddingX {
    _paddingX = paddingX;
    UIEdgeInsets insets = [self titleEdgeInsets];
    insets.left = paddingX.x;
    insets.right = paddingX.y;
    [self setTitleEdgeInsets:insets];
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    [self.titleLabel setFont:textFont];
}

- (void)setTagBackgroundColor:(UIColor *)tagBackgroundColor {
    _tagBackgroundColor = tagBackgroundColor;
    [self setBackgroundColor:tagBackgroundColor];
    [self reloadStyles];
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    _highlightedBackgroundColor = highlightedBackgroundColor;
    [self reloadStyles];
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor {
    _selectedBackgroundColor = selectedBackgroundColor;
    [self reloadStyles];
}

- (void)setSelectedBorderColor:(UIColor *)selectedBorderColor {
    _selectedBorderColor = selectedBorderColor;
    [self reloadStyles];
}

//- (BOOL)isHighlighted {
////    [self reloadStyles];
//    return [super isHighlighted];
//}

//- (BOOL)isSelected {
//    [self reloadStyles];
//    return [super isSelected];
//}

# pragma mark - Methods

- (CGSize) intrinsicContentSize {
    CGSize size = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    
    size.height = self.titleLabel.font.pointSize + self.paddingY * 2;
    size.width += self.paddingX.x + self.paddingX.y;
    
    self.imgView.frame = CGRectMake(4.0f, (size.height - 18.0f) / 2, 32.0f, 18.0f);
    
    int closeSize = self.paddingX.y - 8.0f;
    self.closeView.frame = CGRectMake(size.width - closeSize - 4.0f, (size.height - closeSize) / 2, closeSize, closeSize);
    
    if(size.width < size.height) {
        size.width = size.height;
    }
    
    return size;
}

- (void)reloadStyles {
    if([self isHighlighted]) {
        if([self highlightedBackgroundColor]) {
            [self setBackgroundColor:[self highlightedBackgroundColor]];
        }
    } else if ([self isSelected]) {
        if([self selectedBackgroundColor]) {
            [self setBackgroundColor:[self selectedBackgroundColor]];
        } else {
            [self setTagBackgroundColor:[self tagBackgroundColor]];
        }
        if([self selectedBorderColor]) {
            [[self layer] setBorderColor:[[self selectedBorderColor] CGColor]];
        } else {
            [[self layer] setBorderColor:[[self borderColor] CGColor]];
        }
        [self setTitleColor:[self selectedTextColor] forState:UIControlStateNormal];
    } else {
        [self setBackgroundColor:[self tagBackgroundColor]];
        [[self layer] setBorderColor:[[self borderColor] CGColor]];
        [self setTitleColor:[self textColor] forState:UIControlStateNormal];
    }
}

@end
