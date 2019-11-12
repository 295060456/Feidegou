//
//  BaseModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/4.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject

@property(nonatomic,strong)NSNumber *booth_id;//摊位id
@property(nonatomic,strong)NSNumber *order_id;//订单id
@property(nonatomic,copy)NSString *addTime;//添加时间
@property(nonatomic,strong)NSNumber *seller_id;//卖家id
@property(nonatomic,copy)NSString *seller_name;//卖家名字
@property(nonatomic,strong)NSNumber *buyer_id;//买家id
@property(nonatomic,copy)NSString *buyer_name;//买家名字
@property(nonatomic,copy)NSString *update;//下单时间
@property(nonatomic,strong)NSNumber *order_state;//订单状态
@property(nonatomic,strong)NSNumber *payment_status;//支付类型:1、支付宝;2、微信;3、银行卡
@property(nonatomic,copy)NSString *payment_print;//支付凭证
@property(nonatomic,copy)NSString *payment_print_path;//?
@property(nonatomic,copy)NSString *payment_print_name;//?
@property(nonatomic,copy)NSString *ordercode;//订单号
@property(nonatomic,strong)NSNumber *quantity;//喵粮数量
@property(nonatomic,strong)NSNumber *price;//喵粮单价
@property(nonatomic,strong)NSNumber *rental;//成交价格
@property(nonatomic,copy)NSString *paytime;//支付时间
@property(nonatomic,copy)NSString *finshtime;//完成时间
@property(nonatomic,strong)NSNumber *order_type;//订单类型 1、普通;2、批发;3、平台
@property(nonatomic,copy)NSString *reason;//撤销理由
@property(nonatomic,copy)NSString *del_check;//审核理由
@property(nonatomic,copy)NSString *del_state;//撤销状态
@property(nonatomic,copy)NSString *refer;//参考号
@property(nonatomic,strong)NSNumber *del_print;//取消凭证
@property(nonatomic,copy)NSString *del_print_path;//?
@property(nonatomic,copy)NSString *del_print_name;//?
@property(nonatomic,copy)NSString *trueName;//真实姓名
@property(nonatomic,copy)NSString *bankcard;//银行卡号
@property(nonatomic,copy)NSString *bankName;//银行名称
@property(nonatomic,copy)NSString *bankaddress;//支行
@property(nonatomic,copy)NSString *bankuser;//持卡人
@property(nonatomic,copy)NSString *payment_weixin_id;//微信账号
//@property(nonatomic,strong)NSNumber *Payment_weixin_id;//??
@property(nonatomic,copy)NSString *payment_weixin_path;
@property(nonatomic,copy)NSString *payment_weixin_name;
@property(nonatomic,copy)NSString *payment_alipay_id;//支付宝账号
//@property(nonatomic,strong)NSNumber *payment_alipay_id;//支付宝账号
@property(nonatomic,copy)NSString *payment_alipay_path;//支付宝二维码
@property(nonatomic,copy)NSString *payment_alipay_name;
@property(nonatomic,strong)NSNumber *deal;//1、买家 2、卖家 卖家才有 发货&撤销

@property(nonatomic,strong)NSNumber *ID;

@end

NS_ASSUME_NONNULL_END


