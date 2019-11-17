//
//  WholesaleOrders_VipVC.h
//  Feidegou
//
//  Created by Kite on 2019/11/13.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface WholesaleOrders_VipVC : BaseVC

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *paidBtn;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,strong)WholesaleOrders_AdvanceModel *model;
@property(nonatomic,strong)NSMutableArray <NSString *>*dataArr;

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
