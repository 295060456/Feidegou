//
//  OrderDetail_BuyerModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/8.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetail_BuyerModel : BaseModel

@property(nonatomic,strong)NSNumber *seller;
@property(nonatomic,strong)NSNumber *buyer;
@property(nonatomic,strong)NSNumber *deleteStatus;
@property(nonatomic,strong)NSNumber *order_status;//0、已支付;1、已发单;2、已接单;3、已作废;4、已发货;5、已完成
@property(nonatomic,strong)NSNumber *payment_print_id;
@property(nonatomic,copy)NSString *group_img;
@property(nonatomic,copy)NSString *notifyurl;
@property(nonatomic,copy)NSString *updateTime;
@property(nonatomic,copy)NSString *delTime;
@property(nonatomic,copy)NSString *payment_print_img_path;
@property(nonatomic,copy)NSString *trade_no;
@property(nonatomic,copy)NSString *card_img;
@property(nonatomic,copy)NSString *finishTime;

@end

NS_ASSUME_NONNULL_END

