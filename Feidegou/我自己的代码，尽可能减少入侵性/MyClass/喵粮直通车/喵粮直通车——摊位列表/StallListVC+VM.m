//
//  StallListVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/7.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "StallListVC+VM.h"

@implementation StallListVC (VM)

//正式请求
-(void)networking{
    extern NSString *randomStr;
    NSDictionary *dic = @{
        @"":@""
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:buyer_CatfoodRecord_listURL
                                                     parameters:@{
                                                         @"data":aesEncryptString([NSString convertToJsonData:dic], randomStr),
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            NSLog(@"--%@",response);
//            StallListModel
            if ([response isKindOfClass:[NSArray class]]) {
                NSArray *array = [OrderListModel mj_objectArrayWithKeyValuesArray:response];
                if (array) {
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                        NSUInteger idx,
                                                        BOOL * _Nonnull stop) {
                        @strongify(self)
    //                    OrderListModel *model = array[idx];
    //                    [self.dataMutArr addObject:model];
                    }];
    //                self.tableView.mj_footer.hidden = NO;
    //                [self.tableView reloadData];
                }
            }
        }
    }];
}

#pragma mark —— SRWebSocketDelegate
//WebSocketURL
-(void)webSocket:(NSString *)quantity{
    if (![NSString isNullString:quantity]) {//
        NSString *urlStr = [BaseWebSocketURL stringByAppendingString:[NSString stringWithFormat:@"/%@/%@",@"1",quantity]];
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
    
    if (self.dataMutArr.count) {
        [StallListVC pushFromVC:self_weak_
                  requestParams:self.dataMutArr
                        success:^(id data) {}
                        animated:YES];
    }
}

- (void)SRWebSocketDidClose:(NSNotification *)note {//断开
    
}

@end
