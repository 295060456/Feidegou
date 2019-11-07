//
//  WholesaleOrders_AdvanceVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/6.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleOrders_AdvanceVC+VM.h"

@implementation WholesaleOrders_AdvanceVC (VM)

-(void)netWorking{//展示数据
    extern NSString *randomStr;
    NSString *text;
//    WholesaleMarket_AdvanceModel *model;
    NSString *paymentWayStr;
    NSString *order_IDStr;
    if ([self.requestParams isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)self.requestParams;//购买的数量、付款的方式、订单ID
        text = arr[0];
        NSNumber *paymentWay = (NSNumber *)arr[1];
        paymentWayStr = [paymentWay stringValue] ;
        NSNumber *order_ID = (NSNumber *)arr[2];
        order_IDStr = [order_ID stringValue];
    }

    NSDictionary *dataDic = @{
        @"order_id":order_IDStr,//批发id
        @"quantity":text,//数量
        @"payment_status": paymentWayStr//支付类型 ：1、支付宝;2、微信;3、银行卡
    };
    randomStr = [EncryptUtils shuffledAlphabet:16];
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodSale_BuyeroneURL
                                                     parameters:@{
                                                         @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            @strongify(self)
            NSLog(@"--%@",response);
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)response;
                self.model = [WholesaleOrders_AdvanceModel mj_objectWithKeyValues:dic[@"catFoodOrder"]];
                
                [self.dataArr addObject:@"喵粮"];//商品
                [self.dataArr addObject:[NSString ensureNonnullString:self.model.quantity ReplaceStr:@""]];//数量
                [self.dataArr addObject:[NSString ensureNonnullString:self.model.price ReplaceStr:@""]];//单价
                [self.dataArr addObject:[NSString ensureNonnullString:self.model.rental ReplaceStr:@""]];//总额
                
                switch ([self.model.payment_status intValue]) {//支付类型:1、支付宝;2、微信;3、银行卡
                    case 1:{
                        [self.dataArr addObject:@"支付宝"];
                    }break;
                    case 2:{
                        [self.dataArr addObject:@"微信"];
                    }break;
                    case 3:{
                        [self.dataArr addObject:@"银行卡"];
                    }break;
                    default:
                        [self.dataArr addObject:@"支付方式异常"];
                        break;
                }
                switch ([self.model.order_status intValue]) {//0、已支付;1、已发单;2、已接单;3、已作废;4、已发货;5、已完成
                    case 0:{
                        [self.dataArr addObject:@"已支付"];
                    }break;
                    case 1:{
                         [self.dataArr addObject:@"已发单"];
                    }break;
                    case 2:{
                        [self.dataArr addObject:@"已接单"];
                    }break;
                    case 3:{
                        [self.dataArr addObject:@"已作废"];
                    }break;
                    case 4:{
                        [self.dataArr addObject:@"已发货"];
                    }break;
                    case 5:{
                        [self.dataArr addObject:@"已完成"];
                    }break;
                    default:
                        [self.dataArr addObject:@"订单状态异常"];
                        break;
                }
                [self.tableView reloadData];
            }
        }
    }];
}

-(void)upLoadPic_netWorking:(UIImage *)pic{//真正开始购买
    extern NSString *randomStr;
    
//    self.requestParams;//str nsnumber
    
    NSDictionary *dataDic = @{
        @"order_id":@"",//订单id
        @"payment_print":@""//支付凭证
    };
    randomStr = [EncryptUtils shuffledAlphabet:16];
    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:CatfoodSale_payURL 
                                                     parameters:@{
                                                         @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key]
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        if (response) {
            NSLog(@"--%@",response);
        }
    }];
}

//{
//    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
//    extern NSString *randomStr;
//    NSDictionary *dic;
//    OrderListModel *model;
//    if ([self.requestParams isKindOfClass:[NSDictionary class]]) {
//        dic = (NSDictionary *)self.requestParams;
//        model = dic[@"OrderListModel"][@"OrderListModel"];
//    }
//
//    NSDictionary *dataDic = @{
//         @"order_id":[NSString ensureNonnullString:model.ID ReplaceStr:@""],//订单id
//         @"reason":dic[@"Result"],//撤销理由
//         @"order_type":[NSString ensureNonnullString:model.order_type ReplaceStr:@""]//订单类型 —— 1、摊位;2、批发;3、产地
//    };
//    __block NSData *picData = [UIImage imageZipToData:self.pic];
//    [mgr POST:@"http://10.1.41.158:8080/user/seller/CatfoodRecord_del.htm"
//   parameters:@{
//       @"data":aesEncryptString([NSString convertToJsonData:dataDic], randomStr),
//       @"key":[RSAUtil encryptString:randomStr
//                           publicKey:RSA_Public_key]
//   }
//constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithFileData:picData
//                                    name:@"del_print"
//                                fileName:@"test.png"
//                                mimeType:@"image/png"];
//    }
//     progress:^(NSProgress * _Nonnull uploadProgress) {
//        NSLog(@"uploadProgress = %@",uploadProgress);
//    }
//      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"responseObject = %@",responseObject);
//    }
//      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"error = %@",error);
//    }];
//}


@end
