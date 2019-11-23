//
//  AbuStcokList.m
//  阿布搜索Demo
//
//  Created by 阿布 on 17/3/15.
//  Copyright © 2017年 阿布. All rights reserved.
//

#import "AbuStcokList.h"

@implementation AbuStcokList

static NSMutableArray * Data;

+ (NSMutableArray *)getStcokData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CDefaultNetworkingFile"
                                                      ofType: @"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSMutableArray *dataMutArr = NSMutableArray.array;
    NSArray *array = [AbuStcokModel mj_objectArrayWithKeyValuesArray:data];
    if (array) {
        @weakify(self)
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                            NSUInteger idx,
                                            BOOL * _Nonnull stop) {
            @strongify(self)
            AbuStcokModel *model = array[idx];
            [dataMutArr addObject:model];
        }];
    }
    NSLog(@"");
    return dataMutArr;
}

@end
