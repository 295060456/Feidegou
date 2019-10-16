//
//  ConstantAlipay.h
//  SobForIOS
//
//  Created by pengshuai on 15/4/21.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    payType_otherHaveAddress
}enumPayType;
/**
 *  合作身份者ID
 */
extern NSString * const ALIPAY_PARTNER;
/**
 *  支付宝收款账号
 */
extern NSString * const ALIPAY_SELLER;
/**
 *  商户方的私钥
 */
extern NSString * const ALIPAY_PRIVATE_KEY;
///**
// *  回调地址
// */
//extern NSString * const ALIPAY_NOTIFY_URL;
/**
 *  支付宝相关常量
 */
@interface ConstantAlipay : NSObject
/**
 *  生成订单字符串
 *
 *  @param tradeNO            //订单ID
 *  @param productName        //商品名称
 *  @param productDescription //商品描述
 *  @param amount             //商品价格
 *
 *  @return 订单字符串
 */
+(NSString*)FetchOrderStringWithTradeNO:(NSString*)tradeNO
                            productName:(NSString*)productName
                     productDescription:(NSString*)productDescription
                                 amount:(CGFloat)amount
                          andPayForType:(enumPayType)payType
                                 andUrl:(NSString *)strUrl
                      andALIPAY_PARTNER:(NSString *)ALIPAY_PARTNER
                       andALIPAY_SELLER:(NSString *)ALIPAY_SELLER
                  andALIPAY_PRIVATE_KEY:(NSString *)ALIPAY_PRIVATE_KEY;
@end
