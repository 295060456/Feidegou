//
//  ButtonImgLbl.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/8.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "ButtonImgLbl.h"

@implementation ButtonImgLbl
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAttribute];
    }
    return self;
}
- (void)awakeFromNib{
    [self setAttribute];
}
- (void)setAttribute{
    [self.titleLabel setTextAlignment:NSTextAlignmentRight];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat fHeight =CGRectGetHeight(self.frame);
    return CGRectMake(CGRectGetWidth(self.frame)-10-8, 0, 8, fHeight);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat fHeight =CGRectGetHeight(self.frame);
    return CGRectMake(0, 0, CGRectGetWidth(self.frame)-10-8, fHeight);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
