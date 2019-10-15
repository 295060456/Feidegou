//
//  JJBaseModel.m
//  JiandaobaoVendor
//
//  Created by 谭自强 on 15/7/20.
//  Copyright (c) 2015年 朝花夕拾. All rights reserved.
//

#import "JJBaseModel.h"

@implementation JJBaseModel

-(NSDictionary*)toDictionary{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSSet *set = [self.class propertyKeys];
    //迭代遍历
    NSEnumerator *enumerator = [set objectEnumerator];
    for (NSString *key in enumerator) {
        
        id value = [self valueForKey:key];
        if(value){
            [dic setObject:value forKey:key];
        }else{
            [dic setObject:@"" forKey:key];
        }
    }return dic;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{};
}

@end
