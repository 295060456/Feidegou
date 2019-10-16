//
//  BaseTableView.h
//  jandaobao
//
//  Created by 谭自强 on 15/8/11.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableView : UITableView

/**
 *  检查数据有数据
 *
 *  @param count 数据条数
 */
-(void)checkNoData:(NSInteger)count;

@end
