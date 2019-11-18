//
//  OrderDetailVC.h
//  Feidegou
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark —— 各种UITableViewCell
//装表格的，UITableViewCell嵌套UITableView
@interface OrderDetailTBVCell_02 : TBVCell_style_01

+(instancetype)cellWith:(UITableView *)tableView;
-(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

@end
//订单、单价、总价、账号、支付方式、参考号、下单时间
@interface OrderDetailTBVCell_03 : TBVCell_style_01

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

@end

@interface OrderDetailTBVCell_04 : TBVCell_style_01

+(instancetype)cellWith:(UITableView *)tableView;
-(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

@end

@interface OrderDetailTBVCell_05 : TBVCell_style_01

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

@end

@interface OrderDetailTBVCell_06 : TBVCell_style_01

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

-(void)actionDeliverBlock:(DataBlock)block;
-(void)actionCancelBlock:(DataBlock)block;

@end

@interface OrderDetail_SellerVC : BaseVC

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,strong)OrderDetail_SellerModel *orderDetail_SellerModel;
@property(nonatomic,copy)__block NSString *resultStr;

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
