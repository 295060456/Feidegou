//
//  OrderLogisticsDetailController.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/19.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJBaseViewController.h"
#import "ModelOrderDtail.h"

@interface OrderLogisticsDetailController : JJBaseViewController
//商品图片
@property (copy, nonatomic) NSString *strPath;
//购买数量
@property (copy, nonatomic) NSString *strCount;

//承运公司名字
@property (copy, nonatomic) NSString *strCompanyName;
//运单编号
@property (copy, nonatomic) NSString *strGoodCode;
//承运公司拼音
@property (copy, nonatomic) NSString *strCompanyCode;

@end
