//
//  OrderListVC.h
//  My_BaseProj
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 Corp. All rights reserved.
//

#import "BaseVC.h"

typedef enum : NSUInteger {
    BusinessType_HadPaid = 0,//已支付
    BusinessType_HadBilled,//已发单
    BusinessType_HadOrdered,//已接单
    BusinessType_HadCanceled,//已作废
    BusinessType_HadConsigned,//已发货
    BusinessType_HadCompleted,//已完成
} BusinessType;

typedef enum : NSUInteger {
    NetworkingTpye_default,//默认
    NetworkingTpye_time,//时间
    NetworkingTpye_tradeType,//买/卖
    NetworkingTpye_businessType,//交易状态
    NetworkingTpye_ID,//ID
} Networking_tpye;

NS_ASSUME_NONNULL_BEGIN

@interface OrderTBVCell : TBVCell_style_01

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

@end

@interface SearchView :UIView

@property(nonatomic,strong)NSMutableArray <NSString *>*btnTitleMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*listTitleDataMutArr;

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
