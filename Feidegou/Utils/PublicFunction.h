//
//  PublicFunction.h
//  Vendor
//
//  Created by 谭自强 on 2016/12/13.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    //    are.put("0","已取消");
    //    are.put("10","待付款");
    //    are.put("15","线下支付待审核");
    //    are.put("16","货到付款待发货");
    //    are.put("20","已付款即线上支付待发货");
    //    are.put("30","已发货");
    //    are.put("40","已收货");
    //    are.put("50","已完成,已评价");
    //    are.put("60","已结束");
    enumOrder_yqx = 0,//已取消
    enumOrder_dfk = 10,//待付款
    enumOrder_xxzfdsh = 15,//线下支付待审核
    enumOrder_hdfkdfh = 16,//货到付款待发货
    enumOrder_yfk = 20,//已付款
    enumOrder_yfh = 30,//已发货
    enumOrder_ysh = 40,//已收货
    enumOrder_ywc = 50,//已完成,已评价
    enumOrder_yjs = 60,//已结束
    enumOrder_tksh = 100,//退款售后
    enumOrder_quanbu = 1000,//全部
}enumOrderState;

typedef enum {
    enumColorDirectionFrom_up,
    enumColorDirectionFrom_down,
    enumColorDirectionFrom_left,
    enumColorDirectionFrom_right
}enumColorDirectionFrom;
@interface PublicFunction : NSObject

/*
 根据传入的字符串数字转为状态
 */
+ (enumOrderState)returnStateByNum:(NSString *)strState;
/**
 *  转换时间戳
 */
+ (NSString *)translateTime:(NSString *)strTime;
/**
 *  转换时间戳齐全
 */
+ (NSString *)translateTimeHMS:(NSString *)strTime;
/**
 *  获取渐变颜色的图片
 *  enumColorDirectionFrom方向为起点的位置
 */
+ (UIImage *)getImageWithRect:(CGRect)rectBegin andColorBegin:(UIColor *)colorBegin andColorEnd:(UIColor *)colorEnd andDerection:(enumColorDirectionFrom)derection;
+ (NSInteger)heightByInfo:(NSDictionary *)dicInfo;

/*
 根据传入的字符串数字转为按钮
 */

+ (NSMutableArray *)returnButtonNameByNum:(NSString *)strState andIsNeedDetail:(BOOL)isDetail andcourierCode:(NSString *)courierCode;

//获取分享的图片
+ (UIImage *)fetchImageForShareAchievement:(NSDictionary *)dicInfo;
@end
