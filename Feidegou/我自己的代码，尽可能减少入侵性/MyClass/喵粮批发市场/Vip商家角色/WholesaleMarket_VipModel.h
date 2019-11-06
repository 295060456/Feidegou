//
//  WholesaleMarket_VipModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WholesaleMarket_VipModel : BaseModel

@property(nonatomic,copy)NSString *payment_print_img_name;
@property(nonatomic,copy)NSString *finishTime;
@property(nonatomic,copy)NSString *payment_weixin_img_name;
@property(nonatomic,copy)NSString *payment_alipay_img_name;
@property(nonatomic,copy)NSString *payment_alipay_img;
@property(nonatomic,copy)NSString *seller_name;
@property(nonatomic,copy)NSString *payment_alipay_id;
@property(nonatomic,copy)NSString *deleteStatus;
@property(nonatomic,copy)NSString *del_print_name;
@property(nonatomic,strong)NSNumber *order_status;
@property(nonatomic,copy)NSString *payment_weixin_img;
@property(nonatomic,copy)NSString *del_print_path;
@property(nonatomic,copy)NSString *payment_print_img_path;
@property(nonatomic,copy)NSString *updateTime;
@property(nonatomic,copy)NSString *seller;
@property(nonatomic,copy)NSString *buyer;
@property(nonatomic,copy)NSString *payment_weixin_id;
@property(nonatomic,copy)NSString *delTime;
@property(nonatomic,copy)NSString *buyer_name;
@property(nonatomic,copy)NSString *bankUser;
@property(nonatomic,copy)NSString *catfoodsale_id;
@property(nonatomic,copy)NSString *payment_weixin_img_path;
@property(nonatomic,copy)NSString *payment_alipay_img_path;

@end

NS_ASSUME_NONNULL_END
