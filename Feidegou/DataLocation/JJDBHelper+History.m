//
//  JJDBHelper+History.m
//  guanggaobao
//
//  Created by 谭自强 on 16/8/9.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJDBHelper+History.h"
#define SearchHistory @"searchHistory"
#define SearchHot @"searchHot"
#define SearchHistoryVendor @"searchHistoryVendor"

@implementation JJDBHelper (History)

- (NSArray *)fetchSearchHistoryIsVendor:(BOOL)isVendor{
    NSData *data;
    if (isVendor) {
        data = [self queryCacheDataWithCacheId:SearchHistoryVendor];
    }else{
        data = [self queryCacheDataWithCacheId:SearchHistory];
    }
    
    NSArray *array = [self convertData:data];
    if (![array isKindOfClass:[NSArray class]]) {
        array = [NSArray array];
    }
    return array;
}

- (NSArray *)fetchSearchHot{
    
    NSData *data = [self queryCacheDataWithCacheId:SearchHot];
    
    NSArray *array = [self convertData:data];
    if (![array isKindOfClass:[NSArray class]]) {
        array = [NSArray array];
    }
    return array;
}

- (void)saveSearchHistory:(NSArray *)array
              andIsVendor:(BOOL)isVenor{
    if (isVenor) {
        [self updateCacheForId:SearchHistoryVendor cacheArray:array];
    }else{
        [self updateCacheForId:SearchHistory cacheArray:array];
    }
}

- (void)saveSearchHot:(NSArray *)array{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    [self updateCacheForId:SearchHot cacheData:jsonData];
}

@end
