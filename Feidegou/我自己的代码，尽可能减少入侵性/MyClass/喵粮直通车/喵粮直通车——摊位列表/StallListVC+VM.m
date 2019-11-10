//
//  StallListVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/7.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "StallListVC+VM.h"

@implementation StallListVC (VM)

#pragma mark —— SRWebSocketDelegate
//WebSocketURL
-(void)webSocket:(NSString *)quantity{
    if (![NSString isNullString:quantity]) {//
        NSString *urlStr = [BaseWebSocketURL stringByAppendingString:[NSString stringWithFormat:@"/%@",quantity]];
        [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:urlStr];
    }else{
        Toast(@"请输入参与抢摊位的数量");
    }
}

- (void)SRWebSocketDidOpen {//开启
    NSLog(@"开启成功");
    //在成功后需要做的操作...
    [self.tableView.mj_header endRefreshing];
}

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {//接受消息
    @weakify(self)
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
    //收到服务端发送过来的消息
    if ([note.object isKindOfClass:[NSString class]]) {
        NSDictionary *dict = [NSString dictionaryWithJsonString:note.object];
        NSArray *array = [StallListModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        if (array) {
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                NSUInteger idx,
                                                BOOL * _Nonnull stop) {
                @strongify(self)
                StallListModel *model = array[idx];
                [self.dataMutArr addObject:model];
            }];
        }
//        [[SocketRocketUtility instance] SRWebSocketClose];//关闭WebSocket
        [self.tableView reloadData];
    }else{}
}

- (void)SRWebSocketDidClose:(NSNotification *)note {//断开
    
}

@end
