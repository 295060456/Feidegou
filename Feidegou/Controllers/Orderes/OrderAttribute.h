//
//  OrderAttribute.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/22.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    enum_billType_personal = 0,//个人发票
    enum_billType_company = 1,//公司发票
    enum_billType_no = 2,//不开发票
}enumBillType;

typedef enum {
    enum_sendWay_no,//商家承担
    enum_sendWay_mail,//买家承担平邮
    enum_sendWay_express,//买家承担快递
    enum_sendWay_ems//买家承担ems
}enumSendWay;

@interface OrderAttribute : NSObject

@property (assign, nonatomic) enumBillType billType;//发票类型
@property (assign, nonatomic) enumSendWay sendWay;//配送方式
@property (copy, nonatomic) NSString *strCompanyName;//公司发票公司名字
@property (copy, nonatomic) NSString *strMsg;//商家留言
@property (copy, nonatomic) NSString *strInviter;//邀请码
@property (copy, nonatomic) NSString *strAddressId;//地址ID
@property (copy, nonatomic) NSString *strAddressErea;//地址详细地址
@property (copy, nonatomic) NSString *strAddressDetail;//地址详细地址
@property (copy, nonatomic) NSString *strAddressName;//收货人姓名
@property (copy, nonatomic) NSString *strAddressPhone;//收货人电话

@end
