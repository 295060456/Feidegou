
//
//  PersonalDataChangedListModel.m
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "PersonalDataChangedListModel.h"

@implementation PersonalDataChangedListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    /* 返回的字典，key为模型属性名，value为转化的字典的多级key */
    return @{
             @"after_number_new" : @"new_after_number",
             @"number_new":@"new_number"
             };
}

@end
