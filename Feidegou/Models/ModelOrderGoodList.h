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
@property (nonatomic,strong) NSString *isPackageMail;
/**
 *
 */
@property (nonatomic,strong) NSString *ems_trans_fee;

/**
 *
 */
@property (nonatomic,strong) NSString *express_trans_fee;
/**
 *
 */
@property (nonatomic,strong) NSString *mail_trans_fee;


//配送方式
@property (assign, nonatomic) enumSendWay sendWay;
//发票类型
@property (assign, nonatomic) enumBillType billType;
//公司发票公司名字
@property (strong, nonatomic) NSString *strCompanyName;

//商家留言
@property (strong, nonatomic) NSString *strMsg;
//支付方式，线上和线下
@property (strong, nonatomic) NSString *strPayway;
//InviteID
@property (strong, nonatomic) NSString *strInviter;
@end
