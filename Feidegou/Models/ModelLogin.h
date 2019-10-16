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
@property (nonatomic,copy) NSString *userName;
/**
 *
 */
@property (nonatomic,copy) NSString *trueName;

/**
 *  
 */
@property (nonatomic,copy) NSString *password;
/**
 *
 */
@property (nonatomic,copy) NSString *userId;
/**
 *
 */
@property (nonatomic,copy) NSString *head;
@end
