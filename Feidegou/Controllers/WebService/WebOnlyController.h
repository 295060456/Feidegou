//
//  WebOnlyController.h
//  JiandaobaoVendor
//
//  Created by 谭自强 on 15/8/26.
//  Copyright (c) 2015年 朝花夕拾. All rights reserved.
//

#import "JJBaseViewController.h"
typedef enum {
    //    公司资质
    enum_web_companyqualification = 1,
    //    收益说明
    enum_web_incomeInstruction,
    //    广告详情
    enum_web_advertisementDetail,
    //    广告计费说明
    enum_web_advertisementOfMoney,
    //    首页公告
    enum_web_notice,
    //    收益说明
    enum_web_EarnMore,
    //    看广告赚钱打开网页
    enum_web_adverUrl,
    //    排行榜规则
    enum_web_rankingList,
    //    达人榜详情
    enum_web_rankingDetail,
    //    快速升级
    enum_web_shengji,
    //    注册协议
    enum_web_regDelegete,
    //    广告商特权
    enum_web_vendorPrivilege,
    //    setName
    enum_web_setName,
}webType;
@interface WebOnlyController : JJBaseViewController

@property (assign, nonatomic) webType type;
@property (strong, nonatomic) NSString *strWebUrl;
@end
