//
//  ThroughTrainListVC.h
//  Feidegou
//
//  Created by Kite on 2019/11/28.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThroughTrainListVC : BaseVC

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,assign)int page;
@property(nonatomic,strong)NSMutableArray <ThroughTrainListModel *>*dataMutArr;

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                   withStyle:(ComingStyle)comingStyle
               requestParams:(nullable id)requestParams
                     success:(DataBlock)block
                    animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
