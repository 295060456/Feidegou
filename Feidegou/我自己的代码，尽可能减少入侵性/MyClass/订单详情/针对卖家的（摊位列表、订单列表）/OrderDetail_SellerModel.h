//
//  OrderDetail_SellerModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/4.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetail_SellerModel : BaseModel

@property(nonatomic,strong)NSNumber *seller;
@property(nonatomic,strong)NSNumber *buyer;
@property(nonatomic,copy)NSString *payment_print_img_name;
@property(nonatomic,copy)NSString *finishTime;
@property(nonatomic,copy)NSString *payment_weixin_img_name;
@property(nonatomic,copy)NSString *payment_alipay_img_name;
@property(nonatomic,copy)NSString *payment_alipay_img;
@property(nonatomic,copy)NSString *bankCard;
@property(nonatomic,copy)NSString *payTime;
@property(nonatomic,strong)NSNumber *deleteStatus;
@property(nonatomic,strong)NSNumber *order_status;
@property(nonatomic,copy)NSString *payment_weixin_img;
@property(nonatomic,copy)NSString *payment_print_img_path;
@property(nonatomic,copy)NSString *updateTime;
@property(nonatomic,copy)NSString *delTime;
@property(nonatomic,copy)NSString *bankUser;
@property(nonatomic,copy)NSString *payment_weixin_img_path;
@property(nonatomic,copy)NSString *payment_alipay_img_path;



@end

NS_ASSUME_NONNULL_END
