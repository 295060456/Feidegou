//
//  OrderListModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/4.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderListModel : BaseModel

//父类存在的
//@property(nonatomic,copy)NSString *rental;
//@property(nonatomic,copy)NSString *ordercode;
//@property(nonatomic,copy)NSString *addTime;
//@property(nonatomic,copy)NSString *refer;
//@property(nonatomic,copy)NSString *bankName;
//@property(nonatomic,copy)NSString *quantity;
//@property(nonatomic,copy)NSString *price;
//@property(nonatomic,copy)NSString *del_print;
//@property(nonatomic,copy)NSString *trueName;
//@property(nonatomic,copy)NSString *reason;
//@property(nonatomic,copy)NSString *bankaddress;
//@property(nonatomic,copy)NSString *del_check;
//@property(nonatomic,assign)int Order_type;//订单类型 1、普通;2、批发;3、平台

@property(nonatomic,copy)NSString *payment_print_img_name;
@property(nonatomic,copy)NSString *finishTime;
@property(nonatomic,copy)NSString *payment_weixin_img_name;
@property(nonatomic,copy)NSString *payment_alipay_img_name;
@property(nonatomic,copy)NSString *payment_alipay_img;
@property(nonatomic,copy)NSString *bankCard;
@property(nonatomic,copy)NSString *payTime;
@property(nonatomic,copy)NSString *payment_alipay_id;
@property(nonatomic,assign)int deleteStatus;
@property(nonatomic,assign)int order_status;
@property(nonatomic,copy)NSString *del_state;
@property(nonatomic,copy)NSString *payment_weixin_img;
@property(nonatomic,copy)NSString *payment_print_img_path;
@property(nonatomic,copy)NSString *updateTime;
@property(nonatomic,copy)NSString *payment_status;
@property(nonatomic,assign)int seller;
@property(nonatomic,copy)NSString *buyer;
@property(nonatomic,copy)NSString *payment_weixin_id;
@property(nonatomic,copy)NSString *delTime;
@property(nonatomic,copy)NSString *payment_print;
@property(nonatomic,copy)NSString *bankUser;
@property(nonatomic,assign)int catfoodsale_id;
@property(nonatomic,copy)NSString *payment_weixin_img_path;
@property(nonatomic,copy)NSString *payment_alipay_img_path;

@end

NS_ASSUME_NONNULL_END

//@property(nonatomic,copy)NSString *booth_id;//摊位id
//@property(nonatomic,copy)NSString *order_id;//订单id
//@property(nonatomic,copy)NSString *addTime;//添加时间
//@property(nonatomic,copy)NSString *Seller_id;//卖家id
//@property(nonatomic,copy)NSString *update;//下单时间
//@property(nonatomic,copy)NSString *order_state;//订单状态
//@property(nonatomic,copy)NSString *Payment_status;//支付类型
//@property(nonatomic,copy)NSString *Payment_print;//支付凭证
//@property(nonatomic,copy)NSString *ordercode;//订单号
//@property(nonatomic,copy)NSString *quantity;//喵粮数量
//@property(nonatomic,copy)NSString *price;//喵粮单价
//@property(nonatomic,copy)NSString *rental;//成交价格
//@property(nonatomic,copy)NSString *paytime;//支付时间
//@property(nonatomic,copy)NSString *finshtime;//完成时间
//@property(nonatomic,assign)int Order_type;//订单类型 1、普通;2、批发;3、平台
//@property(nonatomic,copy)NSString *reason;//撤销理由
//@property(nonatomic,copy)NSString *del_check;//审核理由
//@property(nonatomic,copy)NSString *Del_state;//撤销状态
//@property(nonatomic,copy)NSString *refer;//参考号
//@property(nonatomic,copy)NSString *del_print;//取消凭证
//@property(nonatomic,copy)NSString *trueName;//真实姓名
//@property(nonatomic,copy)NSString *bankcard;//银行卡号
//@property(nonatomic,copy)NSString *bankName;//银行名称
//@property(nonatomic,copy)NSString *bankaddress;//支行


