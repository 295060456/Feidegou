//
//  OrderManager_panicBuying.h
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderManager_panicBuyingVC : BaseVC

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)__block int page;//分页面
@property(nonatomic,assign)__block long pageSize;//当前页多少条数据
@property(nonatomic,strong)MMButton *btn;
@property(nonatomic,strong)NSMutableArray <OrderManager_panicBuyingModel *>*dataMutArr;

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated;

+(instancetype)initWithrequestParams:(nullable id)requestParams
                             success:(DataBlock)block;
-(void)delay;

@end

NS_ASSUME_NONNULL_END
