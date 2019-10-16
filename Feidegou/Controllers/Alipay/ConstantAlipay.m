//
//  ConstantAlipay.m
//  SobForIOS
//
//  Created by pengshuai on 15/4/21.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import "ConstantAlipay.h"
#import "Order.h"
#import "DataSigner.h"

//NSString * const ALIPAY_PARTNER = @"2088522040796128";
//NSString * const ALIPAY_SELLER = @"13996278777@139.com";
//NSString * const ALIPAY_PRIVATE_KEY = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMcLokzHmRAi+wbUAYaXS+c8ylgUiVBUUDH+h9BguFigfpU3nzfrgQ8++toaRKM6B0JsZ1O8guuGSwlsx6ICjxJ7BHxjGQn0GaBX9SOaVd0zsk8Hxh/6bjPCFuaOds/FmvdQOt6zWpe9F03lNUbOFUuVa+ZQ4yQqPIgObrD0vgLxAgMBAAECgYEAmq9U4xxevGai9Ox/fwxHRZ49lfPnvpC3fhLTk0IHIYEgvm/qgXe45ZNJOYQegUdQavN53V5r1AOafumVvzcD3bReRorCOeNkkRgldslYuXZ0zg8sQyBMndXSsYpwYwivjFCBpLof6MKp6KvJcdlXqyRlNP61Gz7r7rmY/195rdECQQD+7gTW7QpSM8SZ6SmOkqZwSy3/sxrCNh12AfpiN9ICPv0l3DnJHfnCRgPpv42N8/N1kVQTaL/hopHAwSVmDn+lAkEAx+GN71vxNWKv0CEFzHPOxBhbi0g0DD6M5erVqKzXTkLa76gMdxawO5gyhoo8/RxM4UnQUl4JukmunoEC5aHUXQJAIFUf2AKIZJScQskHtEV1RpjCZMPaiPdEFUt67ioWQKKsiLi9u3xJyRIIPQVGdtKR9j9QYoXOkFeGFORqUd9U4QJAHzf/by8xEWGEjEFcIn7EAKS9R5fTaUYrw41WKa41Qqf2ghABQmhsxiITYigdNntBFr7sprDBXDM97su/pBYOkQJAOiQ2Wh8f07Eeq0lFueVb27uktLh0e2dx6o0W6VuzxCPc4K+4iaOTQs5PqYENbSar6gQGRJRlxUKSO0FI2prfHA==";

@implementation ConstantAlipay

+(NSString*)FetchOrderStringWithTradeNO:(NSString*)tradeNO
                            productName:(NSString*)productName
                     productDescription:(NSString*)productDescription
                                 amount:(CGFloat)amount
                          andPayForType:(enumPayType)payType
                                 andUrl:(NSString *)strUrl
                      andALIPAY_PARTNER:(NSString *)ALIPAY_PARTNER
                       andALIPAY_SELLER:(NSString *)ALIPAY_SELLER
                  andALIPAY_PRIVATE_KEY:(NSString *)ALIPAY_PRIVATE_KEY{
    Order *order = [[Order alloc] init];
    order.partner = ALIPAY_PARTNER;
    order.seller = ALIPAY_SELLER;
    order.tradeNO = tradeNO; //订单ID
    order.productName = productName; //商品标题
    order.productDescription = productDescription; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",amount]; //商品价格
//    YES表示增加余额，NO表示会员续费
    if (payType == payType_otherHaveAddress) {
        order.notifyURL =  strUrl;//回调URL
    }

    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";

    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);

    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(ALIPAY_PRIVATE_KEY);
    NSString *signedString = [signer signString:orderSpec];

    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        return orderString;
    }
    return nil;
}

@end




