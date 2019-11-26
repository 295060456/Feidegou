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
@property(nonatomic,strong)OrderListModel *orderListModel;
@property(nonatomic,strong)CatFoodProducingAreaModel *catFoodProducingAreaModel;
@property(nonatomic,strong)WholesaleMarket_Advance_purchaseModel *wholesaleMarket_Advance_purchaseModel;

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated;

-(void)upLoadbtnClickEvent:(UIButton *)sender;
-(void)backBtnClickEvent:(UIButton *)sender;
-(void)sorry;

@end

NS_ASSUME_NONNULL_END