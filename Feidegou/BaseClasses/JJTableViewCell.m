//
//  JJTableViewCell.m
//  JiandaobaoVendor
//
//  Created by 谭自强 on 15/7/17.
//  Copyright (c) 2015年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"

@implementation JJTableViewCell

- (void)drawRect:(CGRect)rect{
    UIColor *color = ColorLine;
    if (self.colorLine) {
        color = self.colorLine;
    }
    if (self.isHidden) {
        color = [UIColor clearColor];
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    //下分割线
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context, CGRectMake(self.fWidthPre,
                                            rect.size.height,
                                            rect.size.width-self.fWidthPre-self.fWidthEnd,
                                            0.5));
}

@end
