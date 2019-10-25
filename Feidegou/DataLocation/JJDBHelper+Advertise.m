//
//  JJDBHelper+Advertise.m
//  guanggaobao
//
//  Created by 谭自强 on 15/12/16.
//  Copyright © 2015年 朝花夕拾. All rights reserved.
//

#import "JJDBHelper+Advertise.h"

@implementation JJDBHelper (Advertise)

- (NSArray *)fetchCacheForAdvertisementStart{
    NSData *data = [self queryCacheDataWithCacheId:@"3027"];
    NSArray *array = [self convertData:data];
    return array;
}
@end
