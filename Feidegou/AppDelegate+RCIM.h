//
//  AppDelegate+RCIM.h
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (RCIM)
<
RCIMConnectionStatusDelegate,
RCIMUserInfoDataSource,
RCIMGroupInfoDataSource
>

-(void)RCIM;

@end

NS_ASSUME_NONNULL_END
