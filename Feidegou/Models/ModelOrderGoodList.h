//
//  ModelOrderGoodList.h
//  guanggaobao
//
//  Created by 谭自强 on 2018/4/25.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "JJBaseModel.h"
#import "OrderAttribute.h"

@interface ModelOrderGoodList : JJBaseModel

/**
 *
 */
@property (nonatomic,strong) NSArray *goodsCart;
/**
 *
 */
@property (nonatomic,strong) NSDictionary *storeCart;
/**
 *
 */
@property (nonatomic,copy) NSString *isPackageMail;
/**
 *
 */
@property (nonatomic,copy) NSString *ems_trans_fee;
/**
 *
 */
@property (nonatomic,copy) NSString *express_trans_fee;
/**
 *
 */
@property (nonatomic,copy) NSString *mail_trans_fee;
//配送方式
@property (assign, nonatomic) enumSendWay sendWay;
//发票类型
@property (assign, nonatomic) enumBillType billType;
//公司发票公司名字
@property (nonatomic,copy) NSString *strCompanyName;
//商家留言
@property (nonatomic,copy) NSString *strMsg;
//支付方式，线上和线下
@property (nonatomic,copy) NSString *strPayway;
//InviteID
@property (nonatomic,copy) NSString *strInviter;
@end
