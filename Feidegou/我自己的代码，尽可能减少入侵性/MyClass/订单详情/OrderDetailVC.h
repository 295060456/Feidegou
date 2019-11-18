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

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

@end

@interface OrderDetailVC : BaseVC

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *sureBtn;
@property(nonatomic,strong)VerifyCodeButton *contactBuyer;
@property(nonatomic,strong)VerifyCodeButton *countDownCancelBtn;

@property(nonatomic,strong)__block UIImage *pic;
@property(nonatomic,copy)__block NSString *resultStr;
@property(nonatomic,copy)__block NSString *str;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,strong)NSMutableArray <NSString *>*dataMutArr;
@property(nonatomic,strong)OrderListModel *orderListModel;
@property(nonatomic,strong)CatFoodProducingAreaModel *catFoodProducingAreaModel;
@property(nonatomic,strong)StallListModel *stallListModel;
@property(nonatomic,assign)__block int time;

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
