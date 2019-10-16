//
//  JJDBHelper+History.h
//  guanggaobao
//
//  Created by 谭自强 on 16/8/9.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJDBHelper.h"

@interface JJDBHelper (History)
/**
 *  查询搜索历史记录
 *
 *  @return NSDictionary
 */
- (NSArray *)fetchSearchHistoryIsVendor:(BOOL)isVenor;
/**
 *  查询搜索热词
 *
 *  @return NSDictionary
 */
- (NSArray *)fetchSearchHot;
/**
 *  保存搜索历史记录
 *
 *  @return NSDictionary
 */
- (void)saveSearchHistory:(NSArray *)array
              andIsVendor:(BOOL)isVenor;
/**
 *  保存搜索热词
 *
 *  @return NSDictionary
 */
- (void)saveSearchHot:(NSArray *)array;

@end
