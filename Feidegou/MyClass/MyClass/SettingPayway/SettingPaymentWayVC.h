//
//  SettingPaymentWayVC.h
//  Feidegou
//
//  Created by Kite on 2019/11/7.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"
#import "XDMultTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingPaymentWayTBVCell : TBVCell_style_01

+(instancetype)cellWith:(XDMultTableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;
-(void)actionBlock:(TwoDataBlock)block;

@end

@interface SettingPaymentWayVC : BaseVC

@property(nonatomic,weak)XDMultTableView *tableView;
@property(nonatomic,copy)NSString *wechatAccStr;//微信账号
@property(nonatomic,copy)NSString *aliPayAccStr;//支付宝账号
@property(nonatomic,copy)NSString *bankCardNameStr;//银行卡名字
@property(nonatomic,copy)NSString *bankAccStr;//银行卡账号
@property(nonatomic,copy)NSString *bankNameStr;//开户行
@property(nonatomic,copy)NSString *branchInfoStr;//支行信息
@property(nonatomic,strong)__block SettingPaymentWayModel *settingPaymentWayModel;

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                   withStyle:(ComingStyle)comingStyle
               requestParams:(nullable id)requestParams
                     success:(DataBlock)block
                    animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
