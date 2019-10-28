//
//  DiscussAttribute.h
//  Vendor
//
//  Created by 谭自强 on 2017/4/26.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscussAttribute : NSObject

@property (strong, nonatomic) NSString *strGoodsName;
@property (strong, nonatomic) NSString *strIcon;
@property (strong, nonatomic) NSString *strUse_integral_value;
@property (strong, nonatomic) NSString *strGoodsId;
@property (strong, nonatomic) NSString *strUse_integral_set;
//评论内容
@property (strong, nonatomic) NSString *strContent;
//好评中评差评
@property (strong, nonatomic) NSString *strGood;
//描述相符
@property (strong, nonatomic) NSString *strMS;
//发货速度
@property (strong, nonatomic) NSString *strFH;
//服务态度
@property (strong, nonatomic) NSString *strFW;
@end
