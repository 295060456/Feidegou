//
//  CLCellTypeBig.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/6/22.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CLCellTypeBig.h"

@implementation CLCellTypeBig

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)drawRect:(CGRect)rect
{
    UIColor *color = ColorLine;
    CGContextRef context = UIGraphicsGetCurrentContext();
    //上分割线
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height-0.5, rect.size.width, 0.5));
    CGContextStrokeRect(context, CGRectMake(rect.size.width-0.5, 0, 0.5, rect.size.height));
}
@end
