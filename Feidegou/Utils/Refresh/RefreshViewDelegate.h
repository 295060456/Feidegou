//
//  RefreshViewDelegate.h
//  Refresh_Joker
//
//  Created by pengshuai on 15/2/12.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  自定义RefreshView和LoadMoreView代理
 */
@protocol RefreshViewDelegate <NSObject>

@required
/**
 *  重新布局[设置RefreshView/LoadMoreView大小等]
 */
-(void)resetLayoutSubViews;
/**
 *  开始刷新,加载状态
 */
-(void)beginRefreshing;
/**
 *  结束刷新,加载状态
 */
-(void)endRefreshing;
/**
 *  可刷新,加载状态(距离状态范围外)
 */
-(void)canEngageRefresh;
/**
 *  下拉,上拉刷新(距离状态范围内)
 */
-(void)didDisengageRefresh;

@optional
/**
 *  数据加载完了
 */
-(void)dataLoadingFinished;

@end
