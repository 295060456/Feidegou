//
//  UILabelDarkGaryMiddle.m
//  Vendor
//
//  Created by 谭自强 on 2016/12/9.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "UILabelDarkGaryMiddle.h"

@implementation UILabelDarkGaryMiddle

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
    [self setTextColor:ColorGaryDark];
    [self setFont:[UIFont systemFontOfSize:13.0]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
