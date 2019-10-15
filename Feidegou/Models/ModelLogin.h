//
//  ModelLogin.h
//  JiandaobaoVendor
//
//  Created by 谭自强 on 15/7/20.
//  Copyright (c) 2015年 朝花夕拾. All rights reserved.
//

#import "JJBaseModel.h"

@interface ModelLogin : JJBaseModel
/**
 *
 */
@property (nonatomic,strong) NSString *userName;
/**
 *
 */
@property (nonatomic,strong) NSString *trueName;

/**
 *  
 */
@property (nonatomic,strong) NSString *password;
/**
 *
 */
@property (nonatomic,strong) NSString *userId;
/**
 *
 */
@property (nonatomic,strong) NSString *head;
@end
