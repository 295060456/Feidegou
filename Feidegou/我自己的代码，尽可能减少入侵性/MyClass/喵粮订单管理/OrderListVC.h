//
//  OrderListVC.h
//  My_BaseProj
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 Corp. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderTBVCell : TBVCell_style_01

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

@end

@interface SearchView :UIView

@property(nonatomic,strong)NSMutableArray <NSString *>*btnTitleMutArr;

-(void)conditionalQueryBlock:(DataBlock)block;

@end

@interface OrderListVC : BaseVC

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)int page;//分页面
@property(nonatomic,strong)NSMutableArray <OrderListModel *>*dataMutArr;

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
