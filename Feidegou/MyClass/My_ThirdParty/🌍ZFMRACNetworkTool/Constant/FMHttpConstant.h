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

/********ImgBaseURL*****/
//#define ImgBaseURL @""
#define HTTP @"http://"
#define WS @"ws://"
#define IP_Gouge @"10.1.41.158"
#define IP_Daniel @"10.1.41.174"
#define Port_Gouge @":8080"
#define Port_Daniel_1 @":8888"//查看上下级
#define Port_Daniel @":8080"
#define RELATIVE_PATH_QUERY @"SHOPAPP2.0/appShop7/query.do?"
#define RELATIVE_PATH_WRITE @"SHOPAPP2.0/appShop7/write.do?"
#define BaseUrl_Gouge [NSString stringWithFormat:@"%@%@%@",HTTP,IP_Gouge,Port_Gouge]//http:xxx.xx.xx:8080 ###根 进行拼接
#define BaseUrl_Daniel [NSString stringWithFormat:@"%@%@%@",HTTP,IP_Daniel,Port_Daniel]
//#define BASE_URL [NSString stringWithFormat:@"%@%@%@",HTTP,IP_Gouge,Port_Gouge]//http:xxx.xx.xx:8080

//这个只有正式
#define Alipay_url_add_money [NSString stringWithFormat:@"%@%@%@%@",HTTP,IP_Gouge,Port_Gouge,@"/alipay/pay_notify.do"]
#define Alipay_url_add_time [NSString stringWithFormat:@"%@%@%@%@",HTTP,IP_Gouge,Port_Gouge,@"/alipay/adServiceMoney.do"]
#define Alipay_url_invite_code [NSString stringWithFormat:@"%@%@%@%@",HTTP,IP_Gouge,Port_Gouge,@"/alipay/inviteCode.do"]

#pragma mark —— 测试环境
//狗哥
//#define BaseUrl BaseUrl_Gouge
//#define BaseURL BaseUrl_Daniel
//#define BaseUrl2 [NSString stringWithFormat:@"%@%@%@%@",HTTP,IP_Gouge,Port_Gouge,@"/catfoodapp"]
////Daniel
//#define DanielUrL [NSString stringWithFormat:@"%@%@%@%@",HTTP,IP_Daniel,Port_Daniel,@"/MFW"]
//#define DanielUrL_1 [NSString stringWithFormat:@"%@%@%@%@",HTTP,IP_Daniel,Port_Daniel_1,@"/MFW"]//查看上下级
//#define AK [NSString stringWithFormat:@"%@%@%@/%@",HTTP,IP_Daniel,Port_Daniel,RELATIVE_PATH_QUERY]//登录
//#define YQM [NSString stringWithFormat:@"%@%@%@/%@",HTTP,IP_Daniel,Port_Daniel,RELATIVE_PATH_WRITE]//邀请码
////webSocket
//#define WebSocketLocalhost [NSString stringWithFormat:@"%@%@%@%@",WS,IP_Daniel,Port_Daniel,@"/MFW/websocket"]
//#define ImgBaseURL BaseUrl //正式BaseURL 测试BaseUrl

#pragma mark —— 预上线环境 47.56.142.41
#define BaseUrl @"http://47.56.142.41/SHOPAPP2.0/appShop7"//喵粮管理地址
#define BaseURL @"http://47.56.142.41"//喵粮管理地址
#define AK @"http://47.56.142.41/SHOPAPP2.0/appShop7/query.do"//登录
//#define AK @"http://www.miaoxiaodian.shop/SHOPAPP2.0/appShop7/query.do"//登录
#define YQM @"http://47.56.142.41/SHOPAPP2.0/appShop7/write.do"//邀请码
#define WebSocketLocalhost @"ws://www.miaoxiaodian.shop:8080/websocket/"//喵粮转转
#define DanielUrL @"http://47.56.142.41/SHOPAPP2.0/appShop7"//
#define DanielUrL_1 @"http://47.56.142.41/SHOPAPP2.0/appShop7"//查看上下级
#define ImgBaseURL BaseURL //正式BaseURL 测试BaseUrl
#define BASE_URL @"http://47.56.142.41"//商城服务器正式地址

#pragma mark —— 线上环境
//#define BaseUrl @"http://www.miaoxiaodian.shop/SHOPAPP2.0/appShop7"//喵粮管理地址
//#define BaseURL @"http://www.miaoxiaodian.shop"//喵粮管理地址
//#define AK @"http://www.miaoxiaodian.shop/SHOPAPP2.0/appShop7/query.do"//登录
//#define YQM @"http://www.miaoxiaodian.shop/SHOPAPP2.0/appShop7/write.do"//邀请码
//#define WebSocketLocalhost @"ws://www.miaoxiaodian.shop:8080/websocket/"//喵粮转转
//#define DanielUrL @"http://www.miaoxiaodian.shop/SHOPAPP2.0/appShop7"//
//#define DanielUrL_1 @"http://www.miaoxiaodian.shop/SHOPAPP2.0/appShop7"//查看上下级
//#define ImgBaseURL BaseURL //正式BaseURL 测试BaseUrl
//#define BASE_URL @"http://10.1.41.174:8080"//商城服务器正式地址

#define CatfoodManageURL @"/catfoodapp/user/seller/Catfoodmanage.htm"//喵粮管理 post 1 Y
#define buyer_CatfoodRecord_listURL @"/catfoodapp/user/seller/CatfoodRecord_list.htm"//喵粮订单列表 post 2 Y
#define buyer_CatfoodRecord_checkURL @"/catfoodapp/user/seller/CatfoodRecord_check.htm"//喵粮订单查看 post 3 Y
#define seller_CatfoodRecord_goodsURL @"/catfoodapp/user/seller/CatfoodRecord_goods.htm"//喵粮订单发货 post 4 没完 Y
#define CatfoodRecord_delURL @"/user/seller/CatfoodRecord_del.htm"//喵粮订单撤销 post 5 Y PIC 不加catfoodapp
#define CatfoodCOURL @"/catfoodapp/user/buyer/CatfoodCO.htm"//喵粮产地列表 post 6 Y
#define CatfoodCO_BuyerURL @"/catfoodapp/user/buyer/CatfoodCO_buyer.htm"//喵粮产地购买 post 7 Y
#define CatfoodCO_payURL @"/user/buyer/CatfoodCO_pay.htm"//喵粮产地购买已支付 post 8 Y 不加catfoodapp
#define CatfoodCO_pay_delURL @"/catfoodapp/user/buyer/CatfoodCO_pay_del.htm"//喵粮产地购买取消 9 Y
#define CatfoodSale_listURL @"/catfoodapp/user/seller/CatfoodSale_list.htm"//喵粮批发管理 post 10
#define CatfoodSaleOrder_listURL @"/catfoodapp/user/seller/CatfoodSaleOrder_list.htm"//喵粮批发订单管理 post 11 VIP
#define CatfoodSale_add_URL @"/catfoodapp/user/seller/CatfoodSale_add.htm"//喵粮批发发布 post 12 y 对了一半
#define CatfoodSale_delURL @"/catfoodapp/user/seller/CatfoodSale_del.htm" //12_2
#define CatfoodSale_checkURL @"/catfoodapp/user/seller/CatfoodSale_check.htm"//喵粮批发订单详情 post 13
#define CatfoodSale_goodsURL @"/catfoodapp/user/seller/CatfoodSale_goods.htm"//喵粮批发订单发货 post 14
#define CatfoodSaleURL @"/catfoodapp/user/buyer/CatfoodSale.htm"//喵粮批发市场 post 15 高级 Y
#define CatfoodSale_BuyeroneURL @"/catfoodapp/user/buyer/CatfoodSale_Buyerone.htm"//喵粮批发购买 post 16 Y
#define CatfoodSale_payURL @"/user/buyer/CatfoodSale_pay.htm"//喵粮批发已支付 post 17 Y 不加catfoodapp
#define CatfoodSale_pay_delURL @"/catfoodapp/user/buyer/CatfoodSale_pay_del.htm"//喵粮批发取消 post 18 Y
#define CatfoodTrainURL @"/catfoodapp/user/buyer/CatfoodTrain.htm"//喵粮直通车 post 19 
//#define //喵粮抢摊位 20
#define Catfoodbooth_robURL @"/catfoodapp/user/buyer/Catfoodbooth_rob.htm"
//http://10.1.41.174:8888/catfoodapp/user/buyer/Catfoodbooth_rob.htm
#define CatfoodBooth_goodsURL @"/catfoodapp/user/buyer/CatfoodBooth_goods.htm"//喵粮抢摊位发货 post 21Y
#define CatfoodBooth_delURL @"/catfoodapp/user/buyer/CatfoodBooth_del.htm"//喵粮抢摊位取消 post 22 Y
#define CatfoodBooth_del @"/catfoodapp/user/buyer/CatfoodBooth_del.htm"//喵粮抢摊位取消 post 22_1
#define CatfoodBooth_del_time @"/catfoodapp/user/buyer/CatfoodBooth_del_time.htm"//喵粮抢摊位取消剩余时间 post 22_2 5min
#define CatfoodRecord_goodsURL @"/catfoodapp/user/buyer/CatfoodMeowFood.htm"//喵粮赠送 post 23 Y
#define CatfoodOrdernumberUpdateURL @"/catfoodapp/user/seller/CatfoodOrdernumberUpdate.htm"//喵粮订单数量修改 post 24 ?
//#define CatfoodBooth_listURL @"/catfoodapp/user/seller/CatfoodBooth_list.htm"//抢摊位列表 post 25
#define CatfoodBooth_listURL @"/catfoodapp/user/seller/CatfoodBooth_list.htm"//直通车列表 25.1
#define Catfood_qr_addURL @"/user/seller/Catfood_qr_add.htm"//上传二维码 post 26 Y 不加catfoodapp
#define CatfoodWeixin_quarURL @"/catfoodapp/user/seller/CatfoodWeixin_quary.htm"//展示二维码 post 27 Y
#define CatfoodPayment_quaryURL @"/catfoodapp/user/seller/CatfoodPayment_quary.htm"//发布批发市场展示可选支付方式 post 28 Y
#define CatfoodPayment_setURL @"/catfoodapp/user/seller/CatfoodPayment_set.htm"//设置支付方式 Y
#define CatfoodTrain_checkURL @"/catfoodapp/user/buyer/CatfoodTrain_check.htm"//查看直通车
#define CatfoodTrain_delURL @"/catfoodapp/user/buyer/CatfoodTrain_del.htm"//关闭直通车
#define PestFeedUrl @"/catfoodapp/user/PestFeed.htm"
#define PestCatFood_changelistUrl @"/catfoodapp/user/seller/PestCatFood_changelist.htm"//个人喵粮变动记录 36
#define Catfood_statisticsUrl @"/catfoodapp/user/seller/Catfood_statistics.htm" //统计直通车在线人数 35
#define Catfoodbooth_rob_agoUrl @"/catfoodapp/user/buyer/Catfoodbooth_rob_ago.htm"//喵粮直通车机会查询 37
#define Updatewx @"/catfoodapp/user/updatewx.htm"//我的团队修改信息
#define GetTeam @"/catfoodapp/user/getTeam.htm"//查看用戶信息
#define GetSuperior @"/catfoodapp/user/getSuperior.htm"//查看上级用户信息
#define CatfoodboothType @"/catfoodapp/user/buyer/CatfoodboothType.htm"//Daniel
#define CatfoodTrain_ranking @"/catfoodapp/user/buyer/CatfoodTrain_ranking.htm"

///user/buyer/CatfoodBooth_del_time.htm // 看是否过3分钟

///user/buyer/CatfoodBooth_del.htm

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
