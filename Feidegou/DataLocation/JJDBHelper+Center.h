//
//  JJDBHelper+Center.h
//  Vendor
//
//  Created by 谭自强 on 2017/4/11.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJDBHelper.h"
#import "ModelCenter.h"
#import "ModelInfo.h"

@interface JJDBHelper (Center)

/**
 *  查询个人中心
 *
 *  @return NSDictionary
 */
- (ModelCenter *)fetchCenterMsg;


/**
 *  保存个人中心数据
 *
 */
- (void)saveCenterMsg:(ModelCenter *)model;


/**
 *  查询支付宝名字
 *
 *  @return NSString
 */
- (NSString *)fetchAlipayName;
/**
 *  查询支付宝账户
 *
 *  @return NSString
 */
- (NSString *)fetchAlipayAccount;


/**
 *  保存支付宝信息
 *
 */
- (void)saveAlipayName:(NSString *)strName andAccount:(NSString *)strAccount;


/**
 *  查询个人资料
 *
 *  @return NSDictionary
 */
- (ModelInfo *)fetchPersonalInfo;


/**
 *  保存个人资料
 *
 */
- (void)savePersonalInfo:(ModelInfo *)model;
@end
