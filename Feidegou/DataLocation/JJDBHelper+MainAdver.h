//
//  JJDBHelper+MainAdver.h
//  guanggaobao
//
//  Created by 谭自强 on 2018/5/3.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "JJDBHelper.h"

@interface JJDBHelper (MainAdver)
/**
 *  查询首页广告数据
 *
 *  @return NSDictionary
 */
- (NSArray *)fetchMainAdver;
/**
 *  记录每个ID
 *
 *  @return NSDictionary
 */
- (void)saveAdverId:(NSString *)strId;

@end
