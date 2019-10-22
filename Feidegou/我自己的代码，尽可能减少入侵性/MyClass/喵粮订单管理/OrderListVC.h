//
//  OrderListVC.h
//  My_BaseProj
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 Corp. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchView :UIView

@end

@interface OrderListVC : BaseVC

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
