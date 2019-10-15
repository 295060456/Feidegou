//
//  DefaultRefreshView.h
//  Refresh_Joker
//
//  Created by pengshuai on 15/2/12.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshViewDelegate.h"

@interface DefaultRefreshView : UIView<RefreshViewDelegate>

/*! 重新布局*/
-(void)resetLayoutSubViews;
/*! 开始刷新*/
-(void)beginRefreshing;
/*! 结束刷新*/
-(void)endRefreshing;
/*! 释放刷新(距离状态范围外) */
-(void)canEngageRefresh;
/*! 下拉刷新(距离状态范围内) */
-(void)didDisengageRefresh;
@end
