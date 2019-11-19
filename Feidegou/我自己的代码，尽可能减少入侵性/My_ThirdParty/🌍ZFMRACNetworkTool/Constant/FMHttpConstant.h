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

#pragma mark - api拼接 stringByAppendingString
#define API(DomainName,api) [DomainName stringByAppendingString:api]

#pragma mark —— 线下环境
//ashui
//#define BaseUrlLogin @"http://10.1.41.198:8080/SHOPAPP2.0/appShop7/query.do"
//狗哥给我的
#define BaseUrl2 @"http://10.1.41.158:8080"//3
#define BaseUrl API(BaseUrl2,@"/catfoodapp")//@"http://10.1.41.158:8080/catfoodapp"//1
//Daniel
#define Daniel @"http://10.1.41.174:8888/SHOPAPP2.0/appShop7"
#define AK API(Daniel,@"/query.do")//登录
#define YQM API(Daniel,@"/write.do")//邀请码
#define WebSocketLocalhost @"10.1.41.174"
#define BaseWebSocketURL [NSString stringWithFormat:@"ws://%@/websocket",WebSocketLocalhost]
//ws://10.1.41.174/websocket/500

#pragma mark —— 线上环境

/********ImgBaseURL*****/
#define ImgBaseURL @""

#define CatfoodManageURL @"/user/seller/Catfoodmanage.htm"//喵粮管理 post 1 Y
#define buyer_CatfoodRecord_listURL @"/user/seller/CatfoodRecord_list.htm"//喵粮订单列表 post 2 Y
#define buyer_CatfoodRecord_checkURL @"/user/seller/CatfoodRecord_check.htm"//喵粮订单查看 post 3 Y 
#define seller_CatfoodRecord_goodsURL @"/user/seller/CatfoodRecord_goods.htm"//喵粮订单发货 post 4 没完 Y
#define CatfoodRecord_delURL @"/user/seller/CatfoodRecord_del.htm"//喵粮订单撤销 post 5 Y PIC 不加catfoodapp
#define CatfoodCOURL @"/user/buyer/CatfoodCO.htm"//喵粮产地列表 post 6 Y
#define CatfoodCO_BuyerURL @"/user/buyer/CatfoodCO_buyer.htm"//喵粮产地购买 post 7 Y
#define CatfoodCO_payURL @"/user/buyer/CatfoodCO_pay.htm"//喵粮产地购买已支付 post 8 Y 不加catfoodapp
#define CatfoodCO_pay_delURL @"/user/buyer/CatfoodCO_pay_del.htm"//喵粮产地购买取消 9 Y
#define CatfoodSale_listURL @"/user/seller/CatfoodSale_list.htm"//喵粮批发管理 post 10
#define CatfoodSaleOrder_listURL @"/user/seller/CatfoodSaleOrder_list.htm"//喵粮批发订单管理 post 11 VIP
#define CatfoodSale_add_URL @"/user/seller/CatfoodSale_add.htm"//喵粮批发发布 post 12 y 对了一半
#define CatfoodSale_delURL @"/user/seller/CatfoodSale_del.htm" //12_2
#define CatfoodSale_checkURL @"/user/seller/CatfoodSale_check.htm"//喵粮批发订单详情 post 13
#define CatfoodSale_goodsURL @"/user/seller/CatfoodSale_goods.htm"//喵粮批发订单发货 post 14
#define CatfoodSaleURL @"/user/buyer/CatfoodSale.htm"//喵粮批发市场 post 15 高级 Y
#define CatfoodSale_BuyeroneURL @"/user/buyer/CatfoodSale_Buyerone.htm"//喵粮批发购买 post 16 Y
#define CatfoodSale_payURL @"/user/buyer/CatfoodSale_pay.htm"//喵粮批发已支付 post 17 Y 不加catfoodapp
#define CatfoodSale_pay_delURL @"/user/buyer/CatfoodSale_pay_del.htm"//喵粮批发取消 post 18 Y
#define CatfoodTrainURL @"/user/buyer/CatfoodTrain.htm"//喵粮转转 post 19 说是废弃了
//#define //喵粮抢摊位 20
#define Catfoodbooth_robURL @"/user/buyer/Catfoodbooth_rob.htm"
//http://10.1.41.174:8888/catfoodapp/user/buyer/Catfoodbooth_rob.htm
#define CatfoodBooth_goodsURL @"/user/buyer/CatfoodBooth_goods.htm"//喵粮抢摊位发货 post 21Y
#define CatfoodBooth_delURL @"/user/buyer/CatfoodBooth_del.htm"//喵粮抢摊位取消 post 22 Y
#define CatfoodBooth_del @"/user/buyer/CatfoodBooth_del.htm"//喵粮抢摊位取消 post 22_1
#define CatfoodBooth_del_time @"/user/buyer/CatfoodBooth_del_time.htm"//喵粮抢摊位取消剩余时间 post 22_2 5min
#define CatfoodRecord_goodsURL @"/user/buyer/CatfoodMeowFood.htm"//喵粮赠送 post 23 Y
#define CatfoodOrdernumberUpdateURL @"/user/seller/CatfoodOrdernumberUpdate.htm"//喵粮订单数量修改 post 24 ?
#define CatfoodBooth_listURL @"/user/seller/CatfoodBooth_list.htm"//抢摊位列表 post 25
#define Catfood_qr_addURL @"/user/seller/Catfood_qr_add.htm"//上传二维码 post 26 Y 不加catfoodapp
#define CatfoodWeixin_quarURL @"/user/seller/CatfoodWeixin_quary.htm"//展示二维码 post 27 Y
#define CatfoodPayment_quaryURL @"/user/seller/CatfoodPayment_quary.htm"//发布批发市场展示可选支付方式 post 28 Y
#define CatfoodPayment_setURL @"/user/seller/CatfoodPayment_set.htm"//设置支付方式 Y

#define CatfoodTrain_checkURL @"/user/buyer/CatfoodTrain_check.htm"//查看转转
#define CatfoodTrain_delURL @"/user/buyer/CatfoodTrain_del.htm"//关闭转转
#define PestFeed @"/user/PestFeed.htm"

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
