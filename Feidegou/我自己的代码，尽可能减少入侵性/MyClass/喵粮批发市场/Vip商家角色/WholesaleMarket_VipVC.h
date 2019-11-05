//
//  WholesaleMarket_VipVC.h
//  Feidegou
//
//  Created by Kite on 2019/10/29.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface WholesaleMarket_VipVC : BaseVC

@property(nonatomic,weak)JJStockView *stockView;
@property(nonatomic,assign)long currentPage;
@property(nonatomic,strong)__block NSMutableArray <WholesaleMarket_VipModel *>*dataMutArr;

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
