//
//  ThroughTrainToPromoteVC+VM.h
//  Feidegou
//
//  Created by Kite on 2019/11/5.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ThroughTrainToPromoteVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ThroughTrainToPromoteVC (VM)

-(void)netWorking:(NSString *)quantity;//说是废弃了

-(void)webSocket:(NSString *)quantity;//启动WebSocket
-(void)SRWebSocketDidOpen;//回馈WebSocket开启状态
-(void)SRWebSocketDidReceiveMsg:(NSNotification *)note;//接受消息
-(void)SRWebSocketDidClose:(NSNotification *)note;//关闭WebSocket

@end

NS_ASSUME_NONNULL_END
