//
//  UIButton+Joker.m
//  Additions_PS
//
//  Created by pengshuai on 15/1/4.
//  Copyright (c) 2015年 pengshuai. All rights reserved.
//

#import "UIButton+Joker.h"
static char overviewKey;

@implementation UIButton (Joker)

static char overviewKey;

- (void)handleControlEvent:(UIControlEvents)event
                 withBlock:(ActionBlock)block {
    objc_setAssociatedObject(self,
                             &overviewKey,
                             block,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self
             action:@selector(callActionBlock:)
   forControlEvents:event];
}

- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}

-(void)setNormalTitle:(NSString *)title{
    [self setTitle:title forState:UIControlStateNormal];
}

-(void)sethighlightedTitle:(NSString *)title{

    [self setTitle:title forState:UIControlStateHighlighted];
}

-(void)setSelectedTitle:(NSString *)title{
    
    [self setTitle:title forState:UIControlStateSelected];
}

-(void)setDisabledTitle:(NSString *)title{
    
    [self setTitle:title forState:UIControlStateDisabled];
}

-(void)setNormalTitleColor:(UIColor *)color{
    [self setTitleColor:color forState:UIControlStateNormal];
}

-(void)sethighlightedTitleColor:(UIColor *)color{
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

-(void)setSelectedTitleColor:(UIColor *)color{
    [self setTitleColor:color forState:UIControlStateSelected];
}

-(void)setDisabledTitleColor:(UIColor *)color{
    [self setTitleColor:color forState:UIControlStateDisabled];
}

-(void)setNormalBackgroundImage:(UIImage *)image{
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

-(void)sethighlightedBackgroundImage:(UIImage *)image{
    [self setBackgroundImage:image forState:UIControlStateHighlighted];
}

-(void)setSelectedBackgroundImage:(UIImage *)image{
    [self setBackgroundImage:image forState:UIControlStateSelected];
}

-(void)setDisabledBackgroundImage:(UIImage *)image{
    [self setBackgroundImage:image forState:UIControlStateDisabled];
}

- (void)setNormalImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setHightlightedImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateHighlighted];
}

- (void)setSelectedImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateSelected];
}

- (void)setDisabledImage:(UIImage *)image{
    [self setImage:image forState:UIControlStateDisabled];
}



@end




