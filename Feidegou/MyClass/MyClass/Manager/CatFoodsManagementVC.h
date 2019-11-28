//
//  CatFoodsManagementVC.h
//  Feidegou
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"
#import "ThroughTrainToPromoteVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CatFoodsManagementVC : BaseVC

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataMutArr;

-(void)OK;//跳转二维码页面
-(void)Later;//稍后去上传

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                   withStyle:(ComingStyle)comingStyle
               requestParams:(nullable id)requestParams
                     success:(DataBlock)block
                    animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
