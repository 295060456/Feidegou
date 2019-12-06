//
//  CatFoodProducingAreaModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/6.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CatFoodProducingAreaModel : BaseModel

@property(nonatomic,strong)NSNumber *seller;
@property(nonatomic,strong)NSNumber *buyer;
@property(nonatomic,copy)NSString *group_img;
@property(nonatomic,copy)NSString *notifyurl;
@property(nonatomic,copy)NSString *updateTime;
@property(nonatomic,copy)NSString *delTime;
@property(nonatomic,copy)NSString *payment_print_img_name;
@property(nonatomic,copy)NSString *del_reason;
@property(nonatomic,copy)NSString *payment_print_img_path;
@property(nonatomic,copy)NSString *finishTime;
@property(nonatomic,copy)NSString *payment_print_id;
@property(nonatomic,strong)NSNumber *deleteStatus;
@property(nonatomic,strong)NSNumber *trade_no;
@property(nonatomic,strong)NSNumber *card_img;

@property(nonatomic,copy)NSString *bankCard;//银行卡号

@property(nonatomic,assign)bool isSelect;

@end

NS_ASSUME_NONNULL_END

//{
//    order_type = 3,
//    bankaddress = <null>,
//    seller = "135661",
//    payTime = <null>,
//    buyer = 1,
//    group_img = <null>,
//    notifyurl = <null>,
//    bankCard = <null>,
//    deleteStatus = 0,
//    order_status = 1,
//    updateTime = "2019-11-05 21:25:28",
//    delTime = <null>,
//    buyer_name = "admin",
//    del_check = <null>,
//    payment_print_img_name = <null>,
//    quantity = 311,
//    id = 1,
//    del_reason = <null>,
//    bankUser = <null>,
//    del_state = <null>,
//    addTime = "2019-11-03 21:28:24",
//    bankName = <null>,
//    payment_print = <null>,
//    payment_print_img_path = <null>,
//    trade_no = <null>,
//    card_img = <null>,
//    price = 2,
//    rental = 4000,
//    finishTime = <null>,
//    payment_print_id = <null>,
//    ordercode = <null>,
//}
