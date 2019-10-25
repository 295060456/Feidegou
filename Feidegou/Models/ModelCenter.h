//
//  ModelCenter.h
//  Vendor
//
//  Created by 谭自强 on 2017/4/12.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJBaseModel.h"

@interface ModelCenter : JJBaseModel
/**
 *头像
 */
@property (nonatomic,copy) NSString *head;
/**
 *
 */
@property (nonatomic,copy) NSString *userName;
/**
 *邀请人ID
 */
@property (nonatomic,copy) NSString *inviter_id;
/**
 *累计收益
 */
@property (nonatomic,copy) NSString *availableBalance;
/**
 *签到送余额
 */
@property (nonatomic,copy) NSString *redbags;
/**
 *我的积分
 */
@property (nonatomic,copy) NSString *integral;
/**
 *我的团队
 */
@property (nonatomic,copy) NSString *inviterSize;
/**
 *商家ID
 */
@property (nonatomic,copy) NSString *store_id;
/**
 -1审核失败,点击重新申请
 1审核中
 2店铺已开通
 3店铺已关闭,点击联系客服
 */
@property (nonatomic,copy) NSString *store_status;
/**
 *
 */
@property (nonatomic,copy) NSString *waitPay;
/**
 *
 */
@property (nonatomic,copy) NSString *waitShip;
/**
 *
 */
@property (nonatomic,copy) NSString *waitConfirm;
/**
 *
 */
@property (nonatomic,copy) NSString *waitEvaluate;
/**
 *
 */
@property (nonatomic,copy) NSString *refundNo;
/**
 *
 */
@property (nonatomic,copy) NSString *alipayName;
/**
 *
 */
@property (nonatomic,copy) NSString *alipay;
/**
 *
 */
@property (nonatomic,copy) NSString *level;
/**
 *
 */
@property (nonatomic,copy) NSString *regional;
/**
 *
 */
@property (nonatomic,copy) NSString *corporate;

@end
