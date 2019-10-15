//
//  ButtonShare.m
//  jandaobao
//
//  Created by 谭自强 on 15/8/25.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ButtonShare.h"

@implementation ButtonShare
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAttribute];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setAttribute];
}
- (void)setAttribute{
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat fHeight =CGRectGetHeight(self.frame);
    return CGRectMake(0, 0.1*fHeight, CGRectGetWidth(self.frame), fHeight*0.5);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat fHeight =CGRectGetHeight(self.frame);
    return CGRectMake(0, fHeight*0.7, CGRectGetWidth(self.frame), fHeight*0.2);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
