//
//  WholesaleMarket_VipVC.h
//  Feidegou
//
//  Created by Kite on 2019/11/13.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface WholesaleMarket_VipTBVCell : TBVCell_style_01

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

@end

@interface WholesaleMarket_VipVC : BaseVC

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)long currentPage;
@property(nonatomic,strong)NSMutableArray <WholesaleMarket_VipModel *>*dataMutArr;
@property(nonatomic,strong)WholesaleMarket_VipModel *wholesaleMarket_VipModel;

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
