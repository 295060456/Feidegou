//
//  CatFoodsManagementVC.h
//  Feidegou
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"
#import "StallListVC.h"//喵粮转转

NS_ASSUME_NONNULL_BEGIN

@interface CatFoodsManagementVC : BaseVC

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataMutArr;

-(void)OK;//跳转二维码页面
-(void)Later;//稍后去上传

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
