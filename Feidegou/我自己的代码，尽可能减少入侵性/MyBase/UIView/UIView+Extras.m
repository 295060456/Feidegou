//
//  UIView+Extension.m
//  MJRefreshExample
//
//  Created by Aalto on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIView+Extras.h"

@implementation UIView (Extras)
/**
 切角
 
 @param view TargetView
 @param cornerRadiusValue 切角参数
 */
+(void)cornerCutToCircleWithView:(UIView *)view
                 AndCornerRadius:(CGFloat)cornerRadiusValue{
    view.layer.cornerRadius = cornerRadiusValue;
    view.layer.masksToBounds = YES;
}
/**
 描边
 
 @param view TargetView
 @param colour 颜色
 @param WidthOfBorder 边线宽度
 */
+(void)colourToLayerOfView:(UIView *)view
                WithColour:(UIColor *)colour
            AndBorderWidth:(CGFloat)WidthOfBorder{
    view.layer.borderColor = colour.CGColor;
    view.layer.borderWidth = WidthOfBorder;
}
/**
 *  指定圆切角
 */
+(void)appointCornerCutToCircleWithTargetView:(UIView *)targetView
                                  cornerRadii:(CGSize)cornerRadii
                         TargetCorner_TopLeft:(UIRectCorner)targetCorner_TopLeft
                        TargetCorner_TopRight:(UIRectCorner)targetCorner_TopRight
                      TargetCorner_BottomLeft:(UIRectCorner)targetCorner_BottomLeft
                     TargetCorner_BottomRight:(UIRectCorner)targetCorner_BottomRight{
    
    //设置切哪个直角
    //    UIRectCornerTopLeft     = 1 << 0,  左上角
    //    UIRectCornerTopRight    = 1 << 1,  右上角
    //    UIRectCornerBottomLeft  = 1 << 2,  左下角
    //    UIRectCornerBottomRight = 1 << 3,  右下角
    //    UIRectCornerAllCorners  = ~0UL     全部角
    
    //得到view的遮罩路径
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:targetView.bounds
                                                   byRoundingCorners:targetCorner_TopLeft | targetCorner_TopRight | targetCorner_BottomLeft | targetCorner_BottomRight
                                                         cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [CAShapeLayer new];//创建 layer
    maskLayer.frame = targetView.bounds;
    maskLayer.path = maskPath.CGPath;//赋值
    targetView.layer.mask = maskLayer;
}

+(void)setTransform:(float)radians
            forView:(UIView *)view{
    view.transform = CGAffineTransformMakeRotation(M_PI * radians);
    
    //    使用:例如逆时针旋转40度
    //    [setTransform:40/180 forLable:label]
}

+ (UIImage *)getImageFromView:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size,
                                           NO,
                                           [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

