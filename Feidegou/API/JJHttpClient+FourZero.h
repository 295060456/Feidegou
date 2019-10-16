//
//  JJHttpClient+FourZero.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/26.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJHttpClient.h"

@interface JJHttpClient (FourZero)
//参数（接口编码：num，数据id：id，删除标识：delete ，详细地址：area_info,手机号：mobile，座机：telephone，收货人：trueName，邮编：zip，地址id：area_id，用户id：user_id  备注：delete值为1 则是删除 ，为空 或者其他状态就是 修改）
//修改默认地址
-(RACSignal *)requestFourZeroChangeAddressDefaultID:(NSString *)ID
                                         andUserId:(NSString *)userId;
//删除，修改，新增地址
-(RACSignal *)requestFourZeroID:(NSString *)ID
                     andDelete:(NSString *)IsDelete
                  andArea_info:(NSString *)area_info
                     andMobile:(NSString *)mobile
                  andTelephone:(NSString *)telephone
                   andTrueName:(NSString *)trueName
                        andZip:(NSString *)zip
                    andArea_id:(NSString *)area_id
                    andUser_id:(NSString *)user_id;
//参数（接口编码：num，商品属性：spec_info，商品数量：count，发票类型：invoiceType          0：个人   1：公司   2:不开发票，  公司抬头：invoic， 留言：msg，  地址id：addr_id，用户id：user_id  商城的useridShop，送货方式：transport   平邮，快递，EMS）商品id：goods_id  属性id：property:32769_15_
//提交订单
-(RACSignal *)requestFourZeroCommitOrderInvoiceType:(NSString *)invoiceType
                                          andInvoic:(NSString *)invoic
                                             andMsg:(NSString *)msg
                                         andAddr_id:(NSString *)addr_id
                                         andUser_id:(NSString *)user_id
                                       andTransport:(NSString *)transport
                                           andCount:(NSString *)count
                                       andSpec_info:(NSString *)spec_info
                                        andGoods_id:(NSString *)goods_id
                                        andProperty:(NSString *)property;
//提交订单按店铺
-(RACSignal *)requestFourZeroCommitOrderInvoiceType:(NSString *)invoiceType
                                          andInvoic:(NSString *)invoic
                                             andMsg:(NSString *)msg
                                         andAddr_id:(NSString *)addr_id
                                         andUser_id:(NSString *)user_id
                                       andTransport:(NSString *)transport
                                           andSc_id:(NSString *)sc_id
                                      andship_price:(NSString *)ship_price;
//提现 userid：用户id，price：提现金额，）
-(RACSignal *)requestFourZeroWithDrawUserId:(NSString *)userId
                            andcash_account:(NSString *)cash_account
                               andcash_info:(NSString *)cash_info
                             andcash_amount:(NSString *)cash_amount
                               andcash_type:(NSString *)cash_type;
//提现记录
-(RACSignal *)requestFourZeroWithDrawUSERID:(NSString *)USERID
                                   andLimit:(NSString *)limit
                                    andPage:(NSString *)page;

//删除订单 确认收货 订单数据id：orderId  ，状态：state     state：1 删除订单   2 确认订单）
-(RACSignal *)requestFourZeroDeleteOrderId:(NSString *)orderId
                                  andState:(NSString *)state;
//订单付款回调 out_trade_no：订单编号
-(RACSignal *)requestFourZeroPayout_trade_no:(NSString *)out_trade_no;

//提交评论 evaluate_seller_val:好1   中0  差-1  ，evaluate_info：评论信息，evaluate_user_id:用户id，of_id：订单id， description_evaluate：描述 ，service_evaluate：服务，ship_evaluate：发货）
-(RACSignal *)requestFourZeroCommitDiscussevaluate_seller_val:(NSString *)evaluate_seller_val
                                             andevaluate_info:(NSString *)evaluate_info
                                         andevaluate_goods_id:(NSString *)evaluate_goods_id
                                          andevaluate_user_id:(NSString *)evaluate_user_id
                                                     andof_id:(NSString *)of_id
                                      anddescription_evaluate:(NSString *)description_evaluate
                                          andservice_evaluate:(NSString *)service_evaluate
                                             andship_evaluate:(NSString *)ship_evaluate;

-(RACSignal *)requestFourZeroCommitDiscussOrderID:(NSString *)orderId
                                          andOfId:(NSString *)ofId
                                     andAttribute:(NSArray *)arrAttribute
                                        andUserID:(NSString *)userID;
//积分兑换提交订单 商品id：ig_goods_id，商品数量：goodsCont，留言信息：igo_msg，商城用户id：shopId  备：为商城用户id 并非app用户id，app用户id：userId，收货地址id：addrid）
-(RACSignal *)requestFourZeroAreaExchangeOrderComfilmig_goods_id:(NSString *)ig_goods_id
                                                    andgoodsCont:(NSString *)goodsCont
                                                      andigo_msg:(NSString *)igo_msg
                                                       andshopId:(NSString *)shopId
                                                       anduserId:(NSString *)userId
                                                       andaddrid:(NSString *)addrid;
//加入购物车
-(RACSignal *)requestFourZeroAddCartGoods_id:(NSString *)goods_id
                                    andcount:(NSString *)count
                                 andsotre_id:(NSString *)sotre_id
                                 andproperty:(NSString *)property
                                andspec_info:(NSString *)spec_info
                                  andUser_id:(NSString *)user_id;
//修改购物车数量
-(RACSignal *)requestFourZeroCartChangeNumSCId:(NSString *)SCId
                                      andcount:(NSString *)count
                                     andcartId:(NSString *)cartId;
//删除购物车
-(RACSignal *)requestFourZeroCartDeleteCartGoodsCartId:(NSString *)goodsCartId
                                        andstoreCartId:(NSString *)storeCartId
                                         anddeleteType:(NSString *)deleteType;
//申请成为分销商
-(RACSignal *)requestFourZeroApplyForVenderuser_id:(NSString *)user_id
                                     andstore_ower:(NSString *)store_ower
                                andstore_ower_card:(NSString *)store_ower_card
                                     andstore_name:(NSString *)store_name
                                          andsc_id:(NSString *)sc_id
                                        andarea_id:(NSString *)area_id
                                  andstore_address:(NSString *)store_address
                                      andstore_zip:(NSString *)store_zip
                                 andstore_telphone:(NSString *)store_telphone
                                      andcard_file:(UIImage *)card_file
                                   andlicense_file:(UIImage *)license_file;
//红包转账
-(RACSignal *)requestFourZeroRedPacketTransportuserId:(NSString *)userId
                                          andaccounts:(NSString *)accounts
                                            andredbag:(NSString *)redbag;
//修改个人资料
-(RACSignal *)requestFourZeroChangeInfoUserName:(NSString *)userName
                                   andtelePhone:(NSString *)telePhone
                                     andarea_id:(NSString *)area_id
                                         andsex:(NSString *)sex
                                    andbirthday:(NSString *)birthday
                                       andemail:(NSString *)email;
//修改密码
-(RACSignal *)requestFourZeroChangePswUserName:(NSString *)userName
                               andpassword_new:(NSString *)password_new
                               andpassword_old:(NSString *)password_old;
//商城首页
-(RACSignal *)requestFourZeroMainType;
//首页获取报单信息
-(RACSignal *)requestFourZeroMainAdver;

//用户买单
-(RACSignal *)requestFourZeroBuyTheBillbuy_user_id:(NSString *)buy_user_id
                                 andseller_user_id:(NSString *)seller_user_id
                                      andbuy_money:(NSString *)buy_money
                                 anddirectPurchase:(NSString *)directPurchase;

//会员付款
-(RACSignal *)requestFourZeroUserID:(NSString *)userid
                         andpayType:(NSString *)payType;

//购物车提交订单
-(RACSignal *)requestFourZeroCommitOrderCommit:(NSDictionary *)dicInfo;

//提交订单
-(RACSignal *)requestFourZeroCommitOrderInvoiceType:(NSString *)invoiceType
                                          andInvoic:(NSString *)invoic
                                             andMsg:(NSString *)msg
                                         andAddr_id:(NSString *)addr_id
                                         andUser_id:(NSString *)user_id
                                       andTransport:(NSString *)transport
                                           andCount:(NSString *)count
                                       andSpec_info:(NSString *)spec_info
                                        andGoods_id:(NSString *)goods_id
                                        andProperty:(NSString *)property
                                    andservice_user:(NSString *)service_user;

//签到送签到
-(RACSignal *)requestFourZeroSignInGoodId:(NSDictionary *)goodId;

//分享成功
-(RACSignal *)requestFourZeroShare;
//积分充值
-(RACSignal *)requestFourZeroAddInteger:(NSString *)cardpwd;
//支付宝修改
-(RACSignal *)requestFourZeroChangeAlipy:(NSString *)alipay
                           andalipayName:(NSString *)alipayName;
//退款申请
-(RACSignal *)requestFourZeroDarwback:(NSString *)order_id
                               andmsg:(NSString *)msg
                              andtype:(NSString *)type;
//保存物流信息
-(RACSignal *)requestFourZeroWuliuRefund_id:(NSString *)refund_id
                              andcompany_id:(NSString *)company_id
                               andship_code:(NSString *)ship_code;

 @end
