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
@property (nonatomic,strong) NSString *head;
/**
 *
 */
@property (nonatomic,strong) NSString *userName;
/**
 *邀请人ID
 */
@property (nonatomic,strong) NSString *inviter_id;
/**
 *累计收益
 */
@property (nonatomic,strong) NSString *availableBalance;
/**
 *签到送余额
 */
@property (nonatomic,strong) NSString *redbags;
/**
 *我的积分
 */
@property (nonatomic,strong) NSString *integral;
/**
 *我的团队
 */
@property (nonatomic,strong) NSString *inviterSize;
/**
 *商家ID
 */
@property (nonatomic,strong) NSString *store_id;
/**
 -1审核失败,点击重新申请
 1审核中
 2店铺已开通
 3店铺已关闭,点击联系客服
 */
@property (nonatomic,strong) NSString *store_status;
/**
 *
 */
@property (nonatomic,strong) NSString *waitPay;
/**
 *
 */
@property (nonatomic,strong) NSString *waitShip;
/**
 *
 */
@property (nonatomic,strong) NSString *waitConfirm;
/**
 *
 */
@property (nonatomic,strong) NSString *waitEvaluate;
/**
 *
 */
@property (nonatomic,strong) NSString *refundNo;
/**
 *
 */
@property (nonatomic,strong) NSString *alipayName;
/**
 *
 */
@property (nonatomic,strong) NSString *alipay;
/**
 *
 */
@property (nonatomic,strong) NSString *level;
/**
 *
 */
@property (nonatomic,strong) NSString *regional;
/**
 *
 */
@property (nonatomic,strong) NSString *corporate;
@end
