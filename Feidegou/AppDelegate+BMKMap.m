//
//  AppDelegate+BMKMap.m
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//
#import "AppDelegate+BMKMap.h"

BMKMapManager *_mapManager;

@implementation AppDelegate (BMKMap)

-(void)BMKMap{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"LLdCD1urvynTBvcw9rlekbCgfBTyQhej"
                  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

@end
