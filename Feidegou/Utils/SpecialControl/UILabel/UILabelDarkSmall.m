//
//  UILabelDarkSmall.m
//  Vendor
//
//  Created by 谭自强 on 2016/12/9.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "UILabelDarkSmall.h"

@implementation UILabelDarkSmall

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setAttribute];
    }return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setAttribute];
}

- (void)setAttribute{
    [self setTextColor:ColorGary];
    [self setFont:[UIFont systemFontOfSize:10.0]];
}

@end
