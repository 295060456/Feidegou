//
//  JJHttpClient+ShopGood.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/11.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJHttpClient.h"
#import "ModelGood.h"
#import "ModelGoodTypeOne.h"
#import "ModelOrderList.h"
#import "ModelOrderDtail.h"
#import "ModelArea.h"
#import "ModelAddress.h"
#import "ModelEreaExchageList.h"
#import "ModelEreaExchangeDetail.h"
#import "ModelAreaList.h"
#import "ModelAreaDetail.h"
#import "ModelPayWay.h"
#import "ModelCenter.h"
#import "ModelIncome.h"
#import "ModelPerformance.h"
#import "ModelRankList.h"
#import "ModelInfo.h"
#import "ModelVendorNear.h"
#import "ModelOrderGoodList.h"
//30开头
@interface JJHttpClient (ShopGood)

-(RACSignal*)requestShopGoodMainGoodLimit:(NSString *)limit andPage:(NSString *)page;
//首页分类、网页与专题
-(RACSignal*)requestShopGoodTypeSubjectWeb:(NSString *)type;
-(RACSignal*)requestShopGoodTypeOne;
//品牌专区
-(RACSignal*)requestShopGoodBrandRone;
-(RACSignal*)requestShopGoodTypeTwoGoodsType_id:(NSString *)goodsType_id;
//商城商品列表
-(RACSignal*)requestShopGoodGoodTypeLimit:(NSString *)limit andPage:(NSString *)page andGoodsType_id:(NSString *)goodsType_id andgoodsName:(NSString *)goodsName andgoods_brand_id:(NSString *)goods_brand_id andsort:(NSString *)sort andorder:(NSString *)order andpriceStart:(NSString *)priceStart andpriceEnd:(NSString *)priceEnd andgoodArea:(NSString *)goodArea andgoodActivity:(NSString *)goodActivity andgood_area:(NSString *)good_area;
-(RACSignal*)requestShopGoodDetailGoods_id:(NSString *)goods_id;
-(RACSignal*)requestShopGoodGoodNumGoodsspecpropertyId:(NSString *)goodsspecpropertyId andGoodsId:(NSString *)goodsId;
-(RACSignal*)requestShopGoodOrderListLimit:(NSString *)limit andPage:(NSString *)page andOrder_status:(NSString *)order_status andUser_id:(NSString *)user_id;
-(RACSignal*)requestShopGoodOrderDetailOrderId:(NSString *)orderId;
-(RACSignal*)requestShopGoodOrderDetailLogisticsInformationType:(NSString *)type andPostid:(NSString *)postid;
//获取省市区列表
-(RACSignal*)requestShopGoodAreaListLevel:(NSString *)level andID:(NSString *)ID;
//获取地址列表
-(RACSignal*)requestShopGoodAddressListUserId:(NSString *)userId;
//选择支付类型支付 payType（微信：1   支付宝：2）
-(RACSignal*)requestShopGoodPayByType:(NSString *)payType andOrder_id:(NSString *)order_id;
//商家其他商品
-(RACSignal*)requestShopGoodVendorOtherGoodGoods_store_id:(NSString *)goods_store_id andLimit:(NSString *)limit andPage:(NSString *)page;
//state    1：好    0：中     差： -1  注： 如果state  为空 或者不传 将查询所有  ）
-(RACSignal*)requestShopGoodDiscussListGoods_id:(NSString *)goods_id andLimit:(NSString *)limit andPage:(NSString *)page andState:(NSString *)state andstore_id:(NSString *)store_id;

//参数(接口编码：num，商品名字：goodsName     备注： 如果参数不带  goodsName   则返回 热门搜索词   )
-(RACSignal*)requestShopGoodSearchGoodsName:(NSString *)goodsName;
//兑换专区列表
-(RACSignal*)requestShopGoodEreaExchangeListLimit:(NSString *)limit andPage:(NSString *)page;
//兑换详情
-(RACSignal*)requestShopGoodEreaExchangeDetailIg_goods_id:(NSString *)ig_goods_id;
//兑换专区订单列表
//积分兑换记录
-(RACSignal*)requestShopGoodOrderListAreaExchangeLimit:(NSString *)limit andPage:(NSString *)page;

//兑换专区订单详情
//订单id：orderId）
//localhost:8080/UIORACLE/appKu/query.do?num=3021&orderId=1
-(RACSignal*)requestShopGoodOrderDetailAreaExchangeorderId:(NSString *)orderId;
//支付方式
-(RACSignal*)requestShopGoodOrderPayWay;
//购物车列表
-(RACSignal*)requestShopGoodCartListLimit:(NSString *)limit andPage:(NSString *)page anduser_id:(NSString *)user_id;
//购物车进入订单详情获取邮费等
-(RACSignal*)requestShopGoodCartToOrderDetailsc_id:(NSString *)sc_id andUserId:(NSString *)userId;
//个人中心
-(RACSignal*)requestShopGoodCenterInfoUserId:(NSString *)userId;
//我的团队下线人数
-(RACSignal*)requestMyTeamNumberInfoUserId:(NSString *)userId;
//余额明细
-(RACSignal*)requestShopGoodBlanceDetialLimit:(NSString *)limit andPage:(NSString *)page anduserId:(NSString *)userId;
//业绩提成明细
-(RACSignal*)requestShopGoodPerformanceDetialLimit:(NSString *)limit andPage:(NSString *)page anduserId:(NSString *)userId;
//红包明细
-(RACSignal*)requestShopGoodRedpacketDetialLimit:(NSString *)limit andPage:(NSString *)page andmode:(NSString *)mode;
//积分明细
-(RACSignal*)requestShopGoodIntegralDetialLimit:(NSString *)limit andPage:(NSString *)page andGrouId:(NSString *)group_id;

//佣金排行
-(RACSignal*)requestShopGoodRankListLimit:(NSString *)limit andPage:(NSString *)page;
//店铺分类
-(RACSignal*)requestShopGoodVenderType;


//佣金排行
-(RACSignal*)requestShopGoodPersonalInfoUserId:(NSString *)userId;
//线下店首页
-(RACSignal*)requestShopGoodVenderMain;

//附近商家
-(RACSignal*)requestShopGoodVendorNearByLimit:(NSString *)limit andPage:(NSString *)page andlat:(NSString *)lat andlng:(NSString *)lng andkey:(NSString *)key;
//店铺分类查询
-(RACSignal*)requestShopGoodVendorNearByLimit:(NSString *)limit andPage:(NSString *)page andclas:(NSString *)clas andkey:(NSString *)key;
//商家详情
-(RACSignal*)requestShopGoodVendorDetailstore_id:(NSString *)store_id;
//查询店铺所有商品
-(RACSignal*)requestShopGoodVendorNearByLimit:(NSString *)limit andPage:(NSString *)page andgoods_store_id:(NSString *)goods_store_id;


//商家其他商品
-(RACSignal*)requestShopGoodVendorOtherGoodGoods_store_id:(NSString *)goods_store_id andLimit:(NSString *)limit andPage:(NSString *)page andrealstore_approve:(NSString *)realstore_approve;

//买单历史记录
-(RACSignal*)requestShopGoodVendorBillHistoryuser_id:(NSString *)user_id andLimit:(NSString *)limit andPage:(NSString *)page;

//店铺分类查询
-(RACSignal*)requestShopGoodVendorNearByLimit:(NSString *)limit andPage:(NSString *)page andclas:(NSString *)clas andkey:(NSString *)key andLat:(NSString *)lat andLng:(NSString *)lng;

//查看订单是否有能量
-(RACSignal*)requestShopGoodOrderEnergy:(NSString *)ofId;

//买单选择支付类型支付 payType（微信：1   支付宝：2）
-(RACSignal*)requestShopGoodPayTheBillType:(NSString *)payType andOrder_id:(NSString *)order_id;

//选择支付类型支付 payType（微信：1   支付宝：2）
-(RACSignal*)requestShopGoodPayByType:(NSString *)payType andOrder_id:(NSString *)order_id andpay_msg:(NSString *)pay_msg andNum:(NSString *)strNum;

//购物车进入订单详情获取邮费等
-(RACSignal*)requestShopGoodCartToOrderDetailsc_list:(NSArray *)sc_list anduser_id:(NSString *)user_id;

//签到送
-(RACSignal*)requestShopGoodSignIn;
//签到分享数据
-(RACSignal*)requestShopGoodSignInShare;
//邀请好友
-(RACSignal*)requestShopGoodInviteFriend;
//累计收益
-(RACSignal*)requestShopGoodChivement:(NSString *)way;
//提现记录
-(RACSignal*)requestShopGoodWithdrawHistoryLimit:(NSString *)limit andPage:(NSString *)page;
//物流信息公司
-(RACSignal*)requestShopGoodWuliuList;
@end
