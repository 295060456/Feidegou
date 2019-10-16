//
//  MoneyDetailListController.h
//  Vendor
//
//  Created by 谭自强 on 2017/4/12.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJBaseViewController.h"
typedef enum {
    enum_numDetail_ljsy,//累计收益
    enum_numDetail_qdsye,//签到送余额
    enum_numDetail_wdjf,//我的积分
    enum_numDetail_wdtd//我的团队
}enumNumDetail;
@interface MoneyDetailListController : JJBaseViewController
@property (assign,nonatomic) enumNumDetail numDetail;
@property (nonatomic,strong) NSString *strMoneyAll;
@property (nonatomic,strong) NSString *strGrouId;
@end
