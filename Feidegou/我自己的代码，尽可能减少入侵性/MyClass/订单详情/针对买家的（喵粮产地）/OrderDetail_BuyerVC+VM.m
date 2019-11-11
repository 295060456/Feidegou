//
//  OrderDetail_BuyerVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/8.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderDetail_BuyerVC+VM.h"

@implementation OrderDetail_BuyerVC (VM)

-(void)netWorking{
    extern NSString *randomStr;
    if ([self.requestParams isKindOfClass:[CatFoodProducingAreaModel class]]) {
        CatFoodProducingAreaModel *model = (CatFoodProducingAreaModel *)self.requestParams;
        NSDictionary *dataDic = @{
            @"order_id":[model.ID stringValue]//order_id
        };
        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                               path:CatfoodCO_BuyerURL
                                                         parameters:@{
                                                             @"data":dataDic,
                                                             @"key":[RSAUtil encryptString:randomStr
                                                                                 publicKey:RSA_Public_key]
                                                         }];
        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
        @weakify(self)
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
            [self.tableView.mj_header endRefreshing];
            @strongify(self)
            if ([response isKindOfClass:[NSDictionary class]]) {
                self.model = [OrderDetail_BuyerModel mj_objectWithKeyValues:response];
                NSString *str1 = [NSString ensureNonnullString:self.model.ID ReplaceStr:@"无"];
                NSString *str2 = [NSString ensureNonnullString:self.model.quantity ReplaceStr:@""];
                [self.dataMutArr addObject:[NSString stringWithFormat:@"您向厂家%@购买了%@g喵粮",str1,str2]];
                [self.dataMutArr addObject:[NSString ensureNonnullString:self.model.price ReplaceStr:@"无"]];//单价
                [self.dataMutArr addObject:[NSString ensureNonnullString:self.model.quantity ReplaceStr:@"无"]];//数量
                [self.dataMutArr addObject:[NSString ensureNonnullString:self.model.ID ReplaceStr:@"无"]];//订单号
                [self.dataMutArr addObject:[NSString ensureNonnullString:self.model.rental ReplaceStr:@"无"]];//总额
                [self.dataMutArr addObject:[NSString ensureNonnullString:self.model.updateTime ReplaceStr:@"无"]];//时间
                [self.dataMutArr addObject:@"银行卡"];//支付方式
                [self.dataMutArr addObject:[NSString ensureNonnullString:self.model.bankcard ReplaceStr:@"无"]];//银行卡号？
                [self.dataMutArr addObject:[NSString ensureNonnullString:self.model.bankaddress ReplaceStr:@"暂无信息"]];//银行类型
                [self.dataMutArr addObject:[NSString ensureNonnullString:self.model.bankuser ReplaceStr:@"暂无信息"]];//姓名
                switch ([self.model.order_status intValue]) {//0、已支付;1、已发单;2、已接单;3、已作废;4、已发货;5、已完成
                    case 0:{
                        [self.dataMutArr addObject:@"已支付"];
                    } break;
                    case 1:{
                        [self.dataMutArr addObject:@"已发单"];
                    } break;
                    case 2:{
                        [self.dataMutArr addObject:@"已接单"];
                    } break;
                    case 3:{
                        [self.dataMutArr addObject:@"已作废"];
                    } break;
                    case 4:{
                        [self.dataMutArr addObject:@"已发货"];
                    } break;
                    case 5:{
                        [self.dataMutArr addObject:@"已完成"];
                    } break;
                    default:
                        [self.dataMutArr addObject:@"异常数据"];
                        break;
                }
                [self.tableView reloadData];
            }
        }];
    }
}

-(void)cancelOrder_netWorking{
    extern NSString *randomStr;
    if ([self.requestParams isKindOfClass:[CatFoodProducingAreaModel class]]) {
        CatFoodProducingAreaModel *model = (CatFoodProducingAreaModel *)self.requestParams;
        NSDictionary *dataDic = @{
            @"order_id":[model.ID stringValue]//order_id
        };
        FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                               path:CatfoodCO_pay_delURL
                                                         parameters:@{
                                                             @"data":dataDic,
                                                             @"key":[RSAUtil encryptString:randomStr
                                                                                 publicKey:RSA_Public_key]
                                                         }];
        self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
        @weakify(self)
        [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
            @strongify(self)
            if ([response isKindOfClass:[NSString class]]) {
                NSString *str = (NSString *)response;
                if ([str isEqualToString:@""]) {
                    Toast(@"取消成功");
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
    }
}

@end
