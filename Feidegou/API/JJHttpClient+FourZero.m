//
//  JJHttpClient+FourZero.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/26.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJHttpClient+FourZero.h"

@implementation JJHttpClient (FourZero)
-(RACSignal*)requestFourZeroChangeAddressDefaultID:(NSString *)ID andUserId:(NSString *)userId{
    NSDictionary *param = [self paramStringWithStype:@"4009"
                                                data:@{@"id":ID}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestFourZeroID:(NSString *)ID andDelete:(NSString *)IsDelete andArea_info:(NSString *)area_info andMobile:(NSString *)mobile andTelephone:(NSString *)telephone andTrueName:(NSString *)trueName andZip:(NSString *)zip andArea_id:(NSString *)area_id andUser_id:(NSString *)user_id{
    NSDictionary *param;
//    ID 为空则不传
    if ([NSString isNullString:ID]) {
        param = [self paramStringWithStype:@"4001"
                              data:@{@"delete":IsDelete,
                                     @"area_info":area_info,
                                     @"mobile":mobile,
                                     @"telephone":telephone,
                                     @"trueName":trueName,
                                     @"zip":zip,
                                     @"area_id":area_id,
                                     @"user_id":user_id}];
    }else{
        param = [self paramStringWithStype:@"4001"
                                      data:@{@"id":ID,
                                             @"delete":IsDelete,
                                             @"area_info":area_info,
                                             @"mobile":mobile,
                                             @"telephone":telephone,
                                             @"trueName":trueName,
                                             @"zip":zip,
                                             @"area_id":area_id,
                                             @"user_id":user_id}];
    }
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestFourZeroCommitOrderInvoiceType:(NSString *)invoiceType andInvoic:(NSString *)invoic andMsg:(NSString *)msg andAddr_id:(NSString *)addr_id andUser_id:(NSString *)user_id andTransport:(NSString *)transport andCount:(NSString *)count andSpec_info:(NSString *)spec_info andGoods_id:(NSString *)goods_id andProperty:(NSString *)property{
    NSDictionary *param = [self paramStringWithStype:@"4002"
                                  data:@{@"invoiceType":invoiceType,
                                         @"invoic":invoic,
                                         @"msg":msg,
                                         @"addr_id":addr_id,
                                         @"user_id":user_id,
                                         @"transport":transport,
                                         @"count":count,
                                         @"spec_info":spec_info,
                                         @"goods_id":goods_id,
                                         @"property":property}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}


-(RACSignal*)requestFourZeroCommitOrderInvoiceType:(NSString *)invoiceType andInvoic:(NSString *)invoic andMsg:(NSString *)msg andAddr_id:(NSString *)addr_id andUser_id:(NSString *)user_id andTransport:(NSString *)transport andSc_id:(NSString *)sc_id andship_price:(NSString *)ship_price{
    NSDictionary *param = [self paramStringWithStype:@"4011"
                                                data:@{@"invoiceType":invoiceType,
                                                       @"invoic":invoic,
                                                       @"msg":msg,
                                                       @"addr_id":addr_id,
                                                       @"user_id":user_id,
                                                       @"transport":transport,
                                                       @"sc_id":sc_id,
                                                       @"ship_price":ship_price}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}


-(RACSignal*)requestFourZeroWithDrawUserId:(NSString *)userId andcash_account:(NSString *)cash_account andcash_info:(NSString *)cash_info andcash_amount:(NSString *)cash_amount andcash_type:(NSString *)cash_type{
    NSDictionary *param = [self paramStringWithStype:@"4014"
                                                data:@{
                                                       @"alipay":cash_account,
                                                       @"alipayName":cash_info,
                                                       @"cash_money":cash_amount}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestFourZeroWithDrawUSERID:(NSString *)USERID  andLimit:(NSString *)limit andPage:(NSString *)page{
    NSDictionary *param = [self paramStringWithStype:@"1100"
                                                data:@{@"USERID":USERID,
                                                       @"limit":limit,
                                                       @"page":page}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictinary) {
        
        return dictinary;
//        RACSequence *sequence=[dictinary[@"recordList"] rac_sequence];
//        return [[sequence map:^id(NSDictionary *item){
//            ModelRedPacketSealHistory *model = [MTLJSONAdapter modelOfClass:[ModelRedPacketSealHistory class] fromJSONDictionary:item error:nil];
//            return model;
//        }] array];
    }];
}
-(RACSignal*)requestFourZeroDeleteOrderId:(NSString *)orderId andState:(NSString *)state{
    NSDictionary *param = [self paramStringWithStype:@"4024"
                                                data:@{@"order_id":orderId,
                                                       @"state":state}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestFourZeroPayout_trade_no:(NSString *)out_trade_no{
    NSDictionary *param = [self paramStringWithStype:@"4005"
                                                data:@{@"out_trade_no":out_trade_no}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestFourZeroCommitDiscussevaluate_seller_val:(NSString *)evaluate_seller_val andevaluate_info:(NSString *)evaluate_info andevaluate_goods_id:(NSString *)evaluate_goods_id andevaluate_user_id:(NSString *)evaluate_user_id andof_id:(NSString *)of_id anddescription_evaluate:(NSString *)description_evaluate andservice_evaluate:(NSString *)service_evaluate andship_evaluate:(NSString *)ship_evaluate{
    NSDictionary *param = [self paramStringWithStype:@"4004"
                                                data:@{@"evaluate_seller_val":evaluate_seller_val,
                                                       @"evaluate_info":evaluate_info,
                                                       @"evaluate_goods_id":evaluate_goods_id,
                                                       @"evaluate_user_id":evaluate_user_id,
                                                       @"of_id":of_id,
                                                       @"description_evaluate":description_evaluate,
                                                       @"service_evaluate":service_evaluate,
                                                       @"ship_evaluate":ship_evaluate}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestFourZeroCommitDiscussOrderID:(NSString *)orderId andOfId:(NSString *)ofId andAttribute:(NSArray *)arrAttribute andUserID:(NSString *)userID{
    NSDictionary *param = [self paramStringWithStype:@"4004"
                                                data:@{@"orderId":orderId,
                                                       @"ofId":ofId,
                                                       @"attribute":arrAttribute,
                                                       @"userID":userID}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestFourZeroAreaExchangeOrderComfilmig_goods_id:(NSString *)ig_goods_id andgoodsCont:(NSString *)goodsCont andigo_msg:(NSString *)igo_msg andshopId:(NSString *)shopId anduserId:(NSString *)userId andaddrid:(NSString *)addrid{
    NSDictionary *param = [self paramStringWithStype:@"4007"
                                                data:@{@"goods_id":ig_goods_id,
                                                       @"goodsCont":goodsCont,
                                                       @"igo_msg":igo_msg,
                                                       @"shopId":shopId,
                                                       @"userId":userId,
                                                       @"address":addrid}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestFourZeroAddCartGoods_id:(NSString *)goods_id andcount:(NSString *)count andsotre_id:(NSString *)store_id andproperty:(NSString *)property andspec_info:(NSString *)spec_info andUser_id:(NSString *)user_id{
    NSDictionary *param = [self paramStringWithStype:@"4010"
                                                data:@{@"goods_id":goods_id,
                                                       @"count":count,
                                                       @"store_id":store_id,
                                                       @"property":property,
                                                       @"spec_info":spec_info,
                                                       @"user_id":user_id}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestFourZeroCartChangeNumSCId:(NSString *)SCId andcount:(NSString *)count andcartId:(NSString *)cartId{
    NSDictionary *param = [self paramStringWithStype:@"4012"
                                                data:@{@"storeCartId":SCId,
                                                       @"count":count,
                                                       @"goodsCartId":cartId}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestFourZeroCartDeleteCartGoodsCartId:(NSString *)goodsCartId andstoreCartId:(NSString *)storeCartId anddeleteType:(NSString *)deleteType{
    NSDictionary *param = [self paramStringWithStype:@"4013"
                                                data:@{@"goodsCartId":goodsCartId,
                                                       @"storeCartId":storeCartId,
                                                       @"deleteType":deleteType}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestFourZeroApplyForVenderuser_id:(NSString *)user_id andstore_ower:(NSString *)store_ower andstore_ower_card:(NSString *)store_ower_card andstore_name:(NSString *)store_name andsc_id:(NSString *)sc_id andarea_id:(NSString *)area_id andstore_address:(NSString *)store_address andstore_zip:(NSString *)store_zip andstore_telphone:(NSString *)store_telphone andcard_file:(UIImage *)card_file andlicense_file:(UIImage *)license_file{
//    NSData *dataImageCard_filet = UIImageJPEGRepresentation(card_file, 0.2);
//    NSUInteger longSizeCard_filet = dataImageCard_filet.length/1000;
//    D_NSLog(@"longSizeLeft is %lu",(unsigned long)longSizeCard_filet);
//    NSString *_encodedImagecard_file = [dataImageCard_filet base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    
    
//    NSData *dataImageLicense_file = UIImageJPEGRepresentation(license_file, 0.2);
//
//    NSUInteger longSizeLicense_file = dataImageLicense_file.length/1000;
//    D_NSLog(@"longSizeRight is %lu",(unsigned long)longSizeLicense_file);
//    NSString *_encodedImageLicense_file = [dataImageLicense_file base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    NSDictionary *param = [self paramStringWithStype:@"4015"
                                                data:@{@"user_id":user_id,
                                                       @"store_ower":store_ower,
                                                           @"store_ower_card":store_ower_card,
                                                           @"store_name":store_name,
                                                           @"sc_id":sc_id,
                                                           @"area_id":area_id,
                                                           @"store_address":store_address,
                                                           @"store_zip":store_zip,
                                                           @"store_telphone":store_telphone,
//                                                           @"card_file":[NSString stringStandard:_encodedImagecard_file],
//                                                           @"license_file":[NSString stringStandard:_encodedImageLicense_file]
                                                       
                                                       }];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestFourZeroRedPacketTransportuserId:(NSString *)userId andaccounts:(NSString *)accounts andredbag:(NSString *)redbag{
    NSDictionary *param = [self paramStringWithStype:@"4016"
                                                data:@{@"userId":userId,
                                                       @"accounts":accounts,
                                                       @"redbag":redbag}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestFourZeroChangeInfoUserName:(NSString *)userName andtelePhone:(NSString *)telePhone andarea_id:(NSString *)area_id andsex:(NSString *)sex andbirthday:(NSString *)birthday andemail:(NSString *)email{
    ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    NSDictionary *param = [self paramStringWithStype:@"4019"
                                                data:@{@"userId":[NSString stringStandard:model.userId],
                                                       @"telePhone":telePhone,
                                                       @"area_id":area_id,
                                                       @"sex":sex,
                                                       @"birthday":birthday,
                                                       @"email":email}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestFourZeroChangePswUserName:(NSString *)userName andpassword_new:(NSString *)password_new andpassword_old:(NSString *)password_old{
    NSDictionary *param = [self paramStringWithStype:@"4020"
                                                data:@{@"userName":userName,
                                                       @"password_new":[self md5HexDigestSmall:password_new],
                                                       @"password_old":[self md5HexDigestSmall:password_old]}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestFourZeroMainType{//首页接口
    NSDictionary *param = [self paramStringWithStype:@"3001"//
                                                data:@{}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        
        return dictionary;
    }];
}
-(RACSignal*)requestFourZeroMainAdver{
    NSDictionary *param = [self paramStringWithStype:@"3059"
                                                data:@{}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_QUERY
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        [[JJDBHelper sharedInstance] updateCacheForId:@"3059" cacheArray:dictionary[@"biaoXiaoList"]];
        return dictionary;
    }];
}

-(RACSignal*)requestFourZeroBuyTheBillbuy_user_id:(NSString *)buy_user_id andseller_user_id:(NSString *)seller_user_id andbuy_money:(NSString *)buy_money anddirectPurchase:(NSString *)directPurchase{
    NSDictionary *param = [self paramStringWithStype:@"4022"
                                                data:@{@"buy_user_id":buy_user_id,
                                                       @"seller_user_id":seller_user_id,
                                                       @"buy_money":buy_money,
                                                       @"directPurchase":directPurchase
                                                       }];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestFourZeroUserID:(NSString *)userid andpayType:(NSString *)payType{
    NSDictionary *param = [self paramStringWithStype:@"4023"
                                                data:@{@"userid":userid,
                                                       @"payType":payType
                                                       }];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestFourZeroCommitOrderCommit:(NSDictionary *)dicInfo{
    NSDictionary *param = [self paramStringWithStype:@"4011"
                                                data:dicInfo];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestFourZeroCommitOrderInvoiceType:(NSString *)invoiceType andInvoic:(NSString *)invoic andMsg:(NSString *)msg andAddr_id:(NSString *)addr_id andUser_id:(NSString *)user_id andTransport:(NSString *)transport andCount:(NSString *)count andSpec_info:(NSString *)spec_info andGoods_id:(NSString *)goods_id andProperty:(NSString *)property andservice_user:(NSString *)service_user{
    NSDictionary *param = [self paramStringWithStype:@"4002"
                                                data:@{@"invoiceType":invoiceType,
                                                       @"invoic":invoic,
                                                       @"msg":msg,
                                                       @"addr_id":addr_id,
                                                       @"user_id":user_id,
                                                       @"transport":transport,
                                                       @"count":count,
                                                       @"spec_info":spec_info,
                                                       @"goods_id":goods_id,
                                                       @"property":property,
                                                       @"service_user":service_user
                                                       }];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestFourZeroSignInGoodId:(NSDictionary *)goodId{
    NSDictionary *param = [self paramStringWithStype:@"4100"
                                                data:@{@"id":goodId}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestFourZeroShare{
    NSDictionary *param = [self paramStringWithStype:@"4101"
                                                data:@{}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestFourZeroAddInteger:(NSString *)cardpwd{
    NSDictionary *param = [self paramStringWithStype:@"4102"
                                                data:@{@"cardpwd":cardpwd}];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestFourZeroChangeAlipy:(NSString *)alipay andalipayName:(NSString *)alipayName{
    NSDictionary *param = [self paramStringWithStype:@"4028"
                                                data:@{@"alipay":alipay,
                                                       @"alipay_name":alipayName
                                                       }];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}

-(RACSignal*)requestFourZeroDarwback:(NSString *)order_id andmsg:(NSString *)msg andtype:(NSString *)type{
    NSDictionary *param = [self paramStringWithStype:@"4027"
                                                data:@{@"order_id":order_id,
                                                       @"msg":msg,
                                                       @"type":type
                                                       }];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
-(RACSignal*)requestFourZeroWuliuRefund_id:(NSString *)refund_id andcompany_id:(NSString *)company_id andship_code:(NSString *)ship_code{
    NSDictionary *param = [self paramStringWithStype:@"4029"
                                                data:@{@"refund_id":refund_id, @"company_id":company_id,   @"ship_code":ship_code
                                                       }];
    return [[self requestPOSTWithRelativePath:RELATIVE_PATH_WRITE
                                   parameters:param] map:^id(NSDictionary* dictionary) {
        return dictionary;
    }];
}
@end
