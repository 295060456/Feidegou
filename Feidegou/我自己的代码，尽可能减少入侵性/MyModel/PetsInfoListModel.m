//
//  PetsInfoListModel.m
//  Feidegou
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "PetsInfoListModel.h"

@implementation PetsInfoListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
    return @{
             @"ID" : @"id",
             };
}

@end
