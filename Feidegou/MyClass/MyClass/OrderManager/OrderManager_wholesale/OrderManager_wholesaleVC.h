//
//  OrderManager_wholesaleVC.h
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderManager_wholesaleVC : BaseVC

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)int page;//分页面
@property(nonatomic,strong)NSMutableArray <OrderListModel *>*dataMutArr;

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated;

+(instancetype)initWithrequestParams:(nullable id)requestParams
                             success:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
