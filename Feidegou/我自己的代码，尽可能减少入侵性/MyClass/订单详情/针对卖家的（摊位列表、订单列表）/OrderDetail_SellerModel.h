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

//父类存在的
//@property(nonatomic,assign)int rental;
//@property(nonatomic,copy)NSString *ordercode;
//@property(nonatomic,copy)NSString *addTime;
//@property(nonatomic,copy)NSString *refer;
//@property(nonatomic,copy)NSString *bankName;
//@property(nonatomic,assign)int quantity;
//@property(nonatomic,assign)int price;
//@property(nonatomic,copy)NSString *del_print;
//@property(nonatomic,assign)int order_type;
//@property(nonatomic,copy)NSString *trueName;
//@property(nonatomic,copy)NSString *reason;
//@property(nonatomic,copy)NSString *bankaddress;
//@property(nonatomic,copy)NSString *del_check;
//@property(nonatomic,strong)NSNumber *del_state;
//@property(nonatomic,copy)NSString *payment_status;
//@property(nonatomic,strong)NSNumber *payment_print;
//@property(nonatomic,strong)NSNumber *deal;
//@property(nonatomic,copy)NSString *seller_name;
//@property(nonatomic,copy)NSString *payment_alipay_id;
//@property(nonatomic,copy)NSString *del_print_name;
//@property(nonatomic,copy)NSString *del_print_path;
//@property(nonatomic,copy)NSString *payment_weixin_id;
//@property(nonatomic,copy)NSString *buyer_name;

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
