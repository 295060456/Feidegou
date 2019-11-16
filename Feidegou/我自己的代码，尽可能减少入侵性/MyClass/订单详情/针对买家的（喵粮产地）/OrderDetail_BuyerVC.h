//
//  OrderDetail_BuyerVC.h
//  Feidegou
//
//  Created by Kite on 2019/10/23.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN
//承接订单详情
@interface OrderDetail_BuyerTBVCell_01 : TBVCell_style_01

@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;

+(instancetype)cellWith:(UITableView *)tableView;
-(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

@end

@interface OrderDetail_BuyerVC : BaseVC

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,strong)OrderDetail_BuyerModel *model;
@property(nonatomic,strong)NSMutableArray <NSString *>*dataMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
