//
//  FMHttpConstant.h
//  ZFMRACNetwork
//
//  Created by todriver02 on 2018/7/31.
//  Copyright © 2018年 zhufaming. All rights reserved.
//

/**
 *  网络请求相关 宏定义
 */
#ifndef FMHttpConstant_h
#define FMHttpConstant_h

/*******URL******/
#define BaseUrl @"http://10.1.41.158:8080"
/********ImgBaseURL*****/
#define ImgBaseURL @""

#define CatfoodManageURL @"/user/seller/Catfoodmanage.htm"//喵粮管理 post 1 Y
#define buyer_CatfoodRecord_listURL @"/user/seller/CatfoodRecord_list.htm"//喵粮订单列表 post 2 Y
#define buyer_CatfoodRecord_checkURL @"/user/seller/CatfoodRecord_check.htm"//喵粮订单查看 post 3 Y
#define seller_CatfoodRecord_goodsURL @"/user/seller/CatfoodRecord_goods.htm"//喵粮订单发货 post 4 没完 Y
#define CatfoodRecord_delURL @"/user/seller/CatfoodRecord_del.htm"//喵粮订单撤销 post 5 Y
#define CatfoodCOURL @"/user/buyer/CatfoodCO.htm"//喵粮产地列表 post 6 Y
#define CatfoodCO_BuyerURL @"/user/buyer/CatfoodCO_buyer.htm"//喵粮产地购买 post 7
#define CatfoodCO_payURL @"/user/buyer/CatfoodCO_pay.htm"//喵粮产地购买已支付 post 8
#define CatfoodCO_pay_delURL @"/user/buyer/CatfoodCO_pay_del.htm"//喵粮产地购买取消 9 Y
#define CatfoodSale_listURL @"/user/seller/CatfoodSale_list.htm"//喵粮批发管理 post 10
#define CatfoodSaleOrder_listURL @"/user/seller/CatfoodSaleOrder_list.htm"//喵粮批发订单管理 post 11 VIP
#define CatfoodSale_add_URL @"/user/seller/CatfoodSale_add.htm"//喵粮批发发布 post 12 y 对了一半
#define CatfoodSale_checkURL @"/user/seller/CatfoodSale_check.htm"//喵粮批发订单详情 post 13
#define CatfoodSale_goodsURL @"/user/seller/CatfoodSale_goods.htm"//喵粮批发订单发货 post 14
#define CatfoodSaleURL @"/user/buyer/CatfoodSale.htm"//喵粮批发市场 post 15 高级
#define CatfoodSale_BuyeroneURL @"/user/buyer/CatfoodSale_Buyerone.htm"//喵粮批发购买 post 16
#define CatfoodSale_payURL @"/user/buyer/CatfoodSale_pay.htm"//喵粮批发已支付 post 17
#define CatfoodSale_pay_delURL @"/user/buyer/CatfoodSale_pay_del.htm"//喵粮批发取消 post 18 Y
#define CatfoodTrainURL @"/user/buyer/CatfoodTrain.htm"//喵粮直通车 post 19 y没通
//#define //喵粮抢摊位 20
#define CatfoodBooth_goodsURL @"/user/buyer/CatfoodBooth_goods.htm"//喵粮抢摊位发货 post 21
#define CatfoodBooth_delURL @"/user/buyer/CatfoodBooth_del.htm"//喵粮抢摊位取消 post 22 Y
#define CatfoodRecord_goodsURL @"/user/CatfoodRecord_goods.htm"//喵粮赠送 post 23 y没好
#define CatfoodOrdernumberUpdateURL @"/user/seller/CatfoodOrdernumberUpdate.htm"//喵粮订单数量修改 post 24
#define CatfoodBooth_listURL @"/user/seller/CatfoodBooth_list.htm"//抢摊位列表 post 25
#define Catfood_qr_addURL @"/user/seller/Catfood_qr_add.htm"//上传二维码 post 26 Y
#define CatfoodWeixin_quarURL @"/user/seller/CatfoodWeixin_quary.htm"//展示二维码 post 27 Y
#define CatfoodPayment_quaryURL @"/user/seller/CatfoodPayment_quary.htm"//发布批发市场展示可选支付方式 post 28 Y
#define CatfoodPayment_setURL @"/user/seller/CatfoodPayment_set.htm"//设置支付方式


#pragma mark - api拼接
#define API(DomainName,api) [NSString stringWithFormat:@"%@%@",BaseUrl,api]

/********如果需要存储，相应的的 key 宏定义********/
/// 服务器相关
#define HTTPRequestTokenKey @"token"
/// 签名key
#define HTTPServiceSignKey @"sign"
/// 私钥key
#define HTTPServiceKey  @"privatekey"
/// 私钥Value
#define HTTPServiceKeyValue @"/** 你的私钥 **/"
/// 状态码key
#define HTTPServiceResponseCodeKey @"code"
/// 消息key
#define HTTPServiceResponseMsgKey @"message"
/// 数据data
#define HTTPServiceResponseDataKey  @"data"

#endif /* FMHttpConstant_h */
