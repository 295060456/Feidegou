//
//  RefreshControlDelegate.h
//  Refresh_Joker
//
//  Created by pengshuai on 15/2/12.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RefreshViewDelegate.h"

@protocol RefreshControlDelegate <NSObject>

@optional
/*!
 * 是否启用下拉刷新
 * @return YES:启用;NO:不启用
 */
-(BOOL)refreshControlEnableRefresh;

/*! 
 * 是否启用上拉加载
 * @return YES:启用;NO:不启用
 */
-(BOOL)refreshControlEnableLoadMore;

/*!
 * 下拉刷新改变距离
 */
-(CGFloat)refreshControlEnableInsetTop;

/*!
 * 上拉加载改变距离
 */
-(CGFloat)refreshControlEnableInsetBottom;

/*!
 * 刷新数据方法
 */
- (void)refreshControlForRefreshData;

/*!
 * 加载数据方法
 */
- (void)refreshControlForLoadMoreData;

/*!
 * 返回远处服务器数据是否加载完成;YES,表示没有数据了；如果不实现此代理，返回NO
 */
- (BOOL)refreshControlForDataLoadingFinished;

#pragma mark -
#pragma mark - 自定义RefreshView 和 LoadMoreView 必须实现对应的代理
/*!
 * 返回RefreshView,RefreshView必须实现RefreshViewDelegate方法
 */
- (UIView<RefreshViewDelegate>*)refreshControlForRefreshView;

/*!
 * 返回LoadMoreView,LoadMoreView必须实现RefreshViewDelegate方法
 */
- (UIView<RefreshViewDelegate>*)refreshControlForLoadMoreView;
#pragma mark -－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－



@end
