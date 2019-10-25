//
//  JJDBHelper+MainAdver.m
//  guanggaobao
//
//  Created by 谭自强 on 2018/5/3.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "JJDBHelper+MainAdver.h"
#define MainAdverId @"mainAdverId"

@implementation JJDBHelper (MainAdver)
- (NSArray *)fetchMainAdver{
    NSData *data = [self queryCacheDataWithCacheId:@"3059"];
    NSArray *array = [self convertData:data];
//    如果存在了，那么就不添加了
    NSMutableArray *arrAdver = [NSMutableArray array];
    NSMutableArray *arrayId = [NSMutableArray arrayWithArray:[self fetchCacheForMainAdverId]];
    for (int i = 0; i<array.count; i++) {
        BOOL isHad = NO;
        NSString *strId = TransformString(array[i][@"orderId"]);
        for (int j = 0; j<arrayId.count; j++) {
            NSString *strIdMiddle = TransformString(arrayId[j]);
            if ([strId isEqualToString:strIdMiddle]) {
                isHad = YES;
            }
        }
        if (!isHad) {
            [arrAdver addObject:array[i]];
        }
    }return arrAdver;
}

- (void)saveAdverId:(NSString *)strId{
    NSMutableArray *array = [NSMutableArray arrayWithArray:[self fetchCacheForMainAdverId]];
//    如果数量大于100，则删除前面的50个
    if (array.count > 100) {
        [array removeObjectsInRange:NSMakeRange(0, 50)];
    }
    D_NSLog(@"%@",array);
    [array addObject:strId];
    [self updateCacheForId:MainAdverId cacheArray:array];
}

- (NSArray *)fetchCacheForMainAdverId{
    NSData *data = [self queryCacheDataWithCacheId:MainAdverId];
    NSArray *array = [self convertData:data];
    if (![array isKindOfClass:[NSArray class]]) {
        array = [NSArray array];
    }return array;
}

@end
