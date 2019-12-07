//
//  OrderDetailVC.h
//  Feidegou
//
//  Created by Kite on 2019/11/17.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

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
@property(nonatomic,strong)VerifyCodeButton *contactBuyer;//???
@property(nonatomic,strong)VerifyCodeButton *countDownCancelBtn;

@property(nonatomic,strong)__block UIImage *pic;
@property(nonatomic,copy)__block NSString *resultStr;
@property(nonatomic,copy)__block NSString *str;
@property(nonatomic,copy)__block NSString *titleEndStr;
@property(nonatomic,copy)__block NSString *titleBeginStr;
@property(nonatomic,assign)__block int time;
@property(nonatomic,strong)NSNumber *Order_id;
@property(nonatomic,strong)NSMutableArray <NSString *>*dataMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,strong)OrderListModel *orderListModel;
@property(nonatomic,strong)CatFoodProducingAreaModel *catFoodProducingAreaModel;
@property(nonatomic,strong)OrderDetailModel *orderDetailModel;
@property(nonatomic,strong)OrderManager_producingAreaModel *orderManager_producingAreaModel;
@property(nonatomic,strong)OrderManager_panicBuyingModel *orderManager_panicBuyingModel;
//@property(nonatomic,strong)StallListModel *stallListModel;

-(void)chat;

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                   withStyle:(ComingStyle)comingStyle
               requestParams:(nullable id)requestParams
                     success:(DataBlock)block
                    animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
