//
//  OrderListVC.h
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

typedef enum : NSUInteger {
    BusinessType_HadPaid = 0,//已支付
    BusinessType_HadBilled,//已发单
    BusinessType_HadOrdered,//已接单
    BusinessType_HadCanceled,//已作废
    BusinessType_HadConsigned,//已发货
    BusinessType_HadCompleted,//已完成
} BusinessType;

typedef enum : NSUInteger {//1、摊位;2、批发;3、厂家
    PlatformType_NUll = 0,
    PlatformType_Stall,//摊位
    PlatformType_Wholesale,//批发
    PlatformType_ProducingArea//产地 厂家
} PlatformType;

typedef enum : NSUInteger {//按钮状态，下拉刷新的时候，按照谁进行刷新？
    NetworkingTpye_default,//默认
    NetworkingTpye_time,//时间
    NetworkingTpye_tradeType,//买/卖
    NetworkingTpye_businessType,//交易状态
    NetworkingTpye_ID,//ID
    NetworkingTpye_ProducingArea,//产地
} Networking_tpye;

NS_ASSUME_NONNULL_BEGIN

@interface OrderListVC : BaseVC

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)int page;//分页面
@property(nonatomic,strong)NSMutableArray <PersonalDataChangedListModel *>*dataMutArr;

+ (instancetype)CominngFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
