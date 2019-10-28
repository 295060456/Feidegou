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
@property (nonatomic,strong) NSString *region;
/**
 *
 */
@property (nonatomic,strong) NSString *mobile;
/**
 *
 */
@property (nonatomic,strong) NSString *area_id;
/**
 *
 */
@property (nonatomic,strong) NSString *userName;
/**
 *
 */
@property (nonatomic,strong) NSString *birthday;
/**
 *
 */
@property (nonatomic,strong) NSString *email;
/**
 *
 */
@property (nonatomic,strong) NSString *trueName;
/**
 *
 */
@property (nonatomic,strong) NSString *photoUrl;
/**
 *
 */
@property (nonatomic,strong) NSString *birthday_gai;
/**
 *sex：0女1男
 */
@property (nonatomic,strong) NSString *sex;
@end
