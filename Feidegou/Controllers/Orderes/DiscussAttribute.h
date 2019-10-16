//
//  DiscussAttribute.h
//  Vendor
//
//  Created by 谭自强 on 2017/4/26.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiscussAttribute : NSObject

@property (copy, nonatomic) NSString *strGoodsName;
@property (copy, nonatomic) NSString *strIcon;
@property (copy, nonatomic) NSString *strUse_integral_value;
@property (copy, nonatomic) NSString *strGoodsId;
@property (copy, nonatomic) NSString *strUse_integral_set;
@property (copy, nonatomic) NSString *strContent;//评论内容
@property (copy, nonatomic) NSString *strGood;//好评中评差评
@property (copy, nonatomic) NSString *strMS;//描述相符
@property (copy, nonatomic) NSString *strFH;//发货速度
@property (copy, nonatomic) NSString *strFW;//服务态度

@end
