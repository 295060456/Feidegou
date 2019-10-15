//
//  JJBaseModel.h
//  JiandaobaoVendor
//
//  Created by 谭自强 on 15/7/20.
//  Copyright (c) 2015年 朝花夕拾. All rights reserved.
//

#import <Mantle.h>

@interface JJBaseModel : MTLModel<MTLJSONSerializing>

/**
 *  MTLModel转化为Dictionary
 *
 *  @return Dictionary,当属性为nil时,为属性赋值为""
 */
-(NSDictionary*)toDictionary;

+ (NSDictionary *)JSONKeyPathsByPropertyKey;

@end
