//
//  UpLoadCancelReasonVC.h
//  Feidegou
//
//  Created by Kite on 2019/10/22.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface UpLoadCancelReasonTBVCell : TBVCell_style_01

-(void)actionPicBtnBlock:(DataBlock)block;
-(void)actionUpLoadbtnBlock:(DataBlock)block;
-(void)reloadPicBtnIMG:(UIImage *)IMG;

@end

@interface UpLoadCancelReasonVC : BaseVC

@property(nonatomic,strong)__block UIImage *pic;
@property(nonatomic,strong)UpLoadCancelReasonTBVCell *cell;
@property(nonatomic,strong)NSNumber *Order_id;
@property(nonatomic,strong)NSNumber *Order_type;

@property(nonatomic,strong)id requestParams;
//外来数据层
@property(nonatomic,strong)SearchOrderListModel *orderListModel;//搜索
@property(nonatomic,strong)CatFoodProducingAreaModel *catFoodProducingAreaModel;//产地
@property(nonatomic,strong)JPushOrderDetailModel *jPushOrderDetailModel;//极光推送
@property(nonatomic,strong)OrderManager_producingAreaModel *orderManager_producingAreaModel;
@property(nonatomic,strong)OrderManager_panicBuyingModel *orderManager_panicBuyingModel;//直通车
@property(nonatomic,strong)OrderDetailModel *orderDetailModel;//订单详情

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                   withStyle:(ComingStyle)comingStyle
               requestParams:(nullable id)requestParams
                     success:(DataBlock)block
                    animated:(BOOL)animated;

-(void)upLoadbtnClickEvent:(UIButton *)sender;
-(void)backBtnClickEvent:(UIButton *)sender;
-(void)sorry;

-(void)chat;

@end

NS_ASSUME_NONNULL_END
