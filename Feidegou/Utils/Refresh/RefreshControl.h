//
//  RefreshControl.h
//  Refresh_Joker
//
//  Created by pengshuai on 15/2/12.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RefreshControlDelegate.h"

@interface RefreshControl : NSObject

/**
当前RefreshControl状态
*/
typedef enum {
    /**
     *  无状态
     */
    RefreshStateNone = 0,
    /**
     *  正在刷新
     */
    RefreshStateRefreshing  = 1,
    /**
     *  正在加载
     */
    RefreshStateLoadMoreing  = 2,
    /**
     *  数据加载完成
     */
    RefreshStateFinished  = 3
    
} RefreshState;

/**
 *  创建RefreshControl
 *
 *  @param scrollView 要添加到的scrollView
 *  @param delegate   代理类
 *
 *  @return RefreshControl对象
 */
- (instancetype)initRefreshControlWithScrollView:(UIScrollView*)scrollView
                                        delegate:(id<RefreshControlDelegate>)delegate;

/**
 *  开始刷新
 */
-(void)beginRefreshingMethod;
/**
 *  开始加载
 */
-(void)beginLoadMoreingMethod;
/**
 *  结束刷新/加载
 */
-(void)endRefreshing;

@end













