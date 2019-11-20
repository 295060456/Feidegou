//
//  AppDelegate+BMKMap.h
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//
#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (BMKMap)
<
BMKGeneralDelegate
>

-(void)BMKMap;

@end

NS_ASSUME_NONNULL_END
