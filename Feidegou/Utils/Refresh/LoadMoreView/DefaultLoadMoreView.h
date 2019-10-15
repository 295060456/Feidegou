//
//  DefaultLoadMoreView.h
//  Refresh_Joker
//
//  Created by pengshuai on 15/2/12.
//  Copyright (c) 2015年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshViewDelegate.h"

@interface DefaultLoadMoreView : UIView<RefreshViewDelegate>

-(void)resetLayoutSubViews;
-(void)beginRefreshing;
-(void)endRefreshing;
-(void)canEngageRefresh;
-(void)didDisengageRefresh;
-(void)dataLoadingFinished;
@end
