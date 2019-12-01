//
//  ModelLogin.h
//  JiandaobaoVendor
//
//  Created by 谭自强 on 15/7/20.
//  Copyright (c) 2015年 朝花夕拾. All rights reserved.
//

#import "JJBaseModel.h"

@interface ModelLogin : JJBaseModel
 
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *trueName;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *head;
@property(nonatomic,copy)NSString *token;
@property(nonatomic,strong)NSNumber *grade_id;//0、普通用户;1、普通商家;2、高级商家;3、vip商家
@property(nonatomic,strong)NSNumber *platform_id;//客服ID


@end
