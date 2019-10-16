//
//  ModelInfo.h
//  ZhongZhi
//
//  Created by 谭自强 on 2017/7/4.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "JJBaseModel.h"

@interface ModelInfo : JJBaseModel

/**
 *
 */
@property (nonatomic,copy) NSString *region;
/**
 *
 */
@property (nonatomic,copy) NSString *mobile;
/**
 *
 */
@property (nonatomic,copy) NSString *area_id;
/**
 *
 */
@property (nonatomic,copy) NSString *userName;
/**
 *
 */
@property (nonatomic,copy) NSString *birthday;
/**
 *
 */
@property (nonatomic,copy) NSString *email;
/**
 *
 */
@property (nonatomic,strong) NSString *trueName;
/**
 *
 */
@property (nonatomic,copy) NSString *photoUrl;
/**
 *
 */
@property (nonatomic,copy) NSString *birthday_gai;
/**
 *sex：0女1男
 */
@property (nonatomic,copy) NSString *sex;

@end
