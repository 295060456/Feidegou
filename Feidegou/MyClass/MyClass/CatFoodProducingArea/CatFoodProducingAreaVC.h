//
//  CatFoodProducingAreaVC.h
//  Feidegou
//
//  Created by Kite on 2019/10/22.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CatFoodProducingAreaTBVCell :TBVCell_style_01

+(instancetype)cellWith:(UITableView *)tableView;
-(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

@end

@interface CatFoodProducingAreaVC : BaseVC

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)long currentpage;
@property(nonatomic,strong)NSMutableArray <CatFoodProducingAreaModel *>*dataMutArr;
@property(nonatomic,strong)CatFoodProducingAreaModel *catFoodProducingAreaModel;

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                   withStyle:(ComingStyle)comingStyle
               requestParams:(nullable id)requestParams
                     success:(DataBlock)block
                    animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
