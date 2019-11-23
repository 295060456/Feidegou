//
//  StallListVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/7.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "StallListVC+VM.h"

@implementation StallListVC (VM)

//Catfood_statisticsUrl 统计转转在线人数 35
-(void)onlinePeople:(NSString *)onlinePeople{
    extern NSString *randomStr;
    NSNumber *num;
    if ([onlinePeople isEqualToString:@"Online"]) {
        num = [NSNumber numberWithInt:1];
    }else if ([onlinePeople isEqualToString:@"Offline"]){
        num = [NSNumber numberWithInt:-1];
    }else{}
    NSDictionary *dic = @{
        @"type":num
    };
    NSLog(@"%lu",(unsigned long)onlinePeople)
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:Catfood_statisticsUrl
                                                     parameters:@{
                                                         @"data":dic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)

    }];
}

-(void)抢摊位:(StallListModel *)stallListModel
 indexPath:(NSIndexPath *)indexPath{
    extern NSString *randomStr;
    NSDictionary *dic = @{
        @"order_id":stallListModel.ID ? stallListModel.ID : @""
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:Catfoodbooth_robURL
                                                     parameters:@{
                                                         @"data":dic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
//        @strongify(self)
        if ([response isKindOfClass:[NSString class]]) {
             NSString *str = (NSString *)response;
            if ([NSString isNullString:str]) {
                [OrderDetailVC ComingFromVC:self_weak_
                                  withStyle:ComingStyle_PUSH
                              requestParams:stallListModel
                                    success:^(id data) {}
                                   animated:YES];                
            }
        }
    }];
}

-(void)allowWebSocketOpen_networking:(NSString *)quantity{
    extern NSString *randomStr;
    NSDictionary *dic = @{
        @"quantity":[NSString isNullString:quantity] ? @"" :quantity
    };
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodTrainURL
                                                     parameters:@{
                                                         @"data":dic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        if ([response isKindOfClass:[NSString class]]) {
            NSString *str = (NSString *)response;
            if ([NSString isNullString:str]) {
                Toast(@"开通成功");
                [self webSocket:quantity];
            }else{
//                Toast(@"开通失败");
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            Toast(@"网络异常");
        }
    }];
}
//WebSocketURL
-(void)webSocket:(NSString *)quantity{
    if (![NSString isNullString:quantity]) {//
        NSString *urlStr = [BaseWebSocketURL stringByAppendingString:[NSString stringWithFormat:@"/%@",quantity]];
        [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:urlStr];
    }else{
        Toast(@"请输入参与抢摊位的数量");
    }
}
#pragma mark —— SRWebSocketDelegate
- (void)SRWebSocketDidOpen{//开启
    NSLog(@"开启成功");
    //在成功后需要做的操作...
    [self.tableView.mj_header endRefreshing];
}

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note{//接受消息
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
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }else{}
}

- (void)SRWebSocketDidClose:(NSNotification *)note {//断开
    
}

@end
