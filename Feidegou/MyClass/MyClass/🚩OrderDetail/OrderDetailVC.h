//
//  OrderDetailVC.h
//  Feidegou
//
//  Created by Kite on 2019/11/17.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"
#import "OrderDetailTBViewForHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetailTBVCell : TBVCell_style_01

@property(nonatomic,strong)VerifyCodeButton *timeBtn;

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

@end

@interface OrderDetailTBVIMGCell : TBVCell_style_01

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

@end

@interface OrderDetailVC : BaseVC

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *sureBtn;
@property(nonatomic,strong)UIButton *reloadPicBtn;
@property(nonatomic,strong)UIButton *normalCancelBtn;
@property(nonatomic,strong)VerifyCodeButton *countDownCancelBtn;

@property(nonatomic,strong)__block UIImage *pic;
@property(nonatomic,copy)__block NSString *resultStr;
@property(nonatomic,copy)__block NSString *str;
@property(nonatomic,copy)__block NSString *titleEndStr;
@property(nonatomic,copy)__block NSString *titleBeginStr;
@property(nonatomic,assign)__block int time;
@property(nonatomic,strong)NSNumber *Order_id;
@property(nonatomic,strong)NSNumber *Order_type;//订单类型 1、直通车;2、批发;3、平台

@property(nonatomic,strong)NSMutableArray <NSString *>*dataMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;

@property(nonatomic,strong)id requestParams;
//外来数据层
@property(nonatomic,strong)SearchOrderListModel *orderListModel;//搜索
@property(nonatomic,strong)CatFoodProducingAreaModel *catFoodProducingAreaModel;//产地
@property(nonatomic,strong)JPushOrderDetailModel *jPushOrderDetailModel;//极光推送
@property(nonatomic,strong)OrderManager_producingAreaModel *orderManager_producingAreaModel;
@property(nonatomic,strong)OrderManager_panicBuyingModel *orderManager_panicBuyingModel;//直通车
//自身的数据层
@property(nonatomic,strong)OrderDetailModel *orderDetailModel;//订单详情

-(void)chat;
-(void)cancdel;
-(void)Later;
-(void)pullToRefresh;

//上传支付凭证
-(void)getPrintPic:(UIButton *)sender;

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                   withStyle:(ComingStyle)comingStyle
               requestParams:(nullable id)requestParams
                     success:(DataBlock)block
                    animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
