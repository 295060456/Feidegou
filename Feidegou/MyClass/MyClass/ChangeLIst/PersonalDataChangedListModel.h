//
//  PersonalDataChangedListModel.h
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PersonalDataChangedListModel : BaseModel

@property(nonatomic,strong)NSNumber *old_number;//原总数量
/*
 11、赠送增加;
 21、赠送减少;
 12、后台增加;
 22、后台减少;
 13、摊位购买;
 23、摊位出售;
 33、摊位发布;
 14、批发购买;
 24、批发出售;
 34、批发发布;
 44、批发下架;
 15、产地购买;
 25、产地出售;
 35、产地发布;
 16、结束直通车增加;
 26、开启直通车减少;
 27、喂食喵粮减少
 */
@property(nonatomic,strong)NSNumber *change_status;//状态
@property(nonatomic,copy)NSString *change_statusStr;//手动添加
@property(nonatomic,strong)NSNumber *sell_primary_number;//原出售中的数量
@property(nonatomic,copy)NSString *detailed;//变动详细
@property(nonatomic,strong)NSNumber *coutn_number;//变动后的总数量
@property(nonatomic,strong)NSNumber *deleteStatus;
@property(nonatomic,strong)NSNumber *after_number_new;//变动后的出售中数量
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *number;//变动数量
@property(nonatomic,copy)NSString *primary_number;//原可用数量
@property(nonatomic,strong)NSNumber *number_new;//变动后的可用数量
@property(nonatomic,strong)NSNumber *user;

@end

NS_ASSUME_NONNULL_END

