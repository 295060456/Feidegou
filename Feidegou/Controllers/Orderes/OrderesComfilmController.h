//
//  OrderesComfilmController.h
//  guanggaobao
//
//  Created by 谭自强 on 16/7/15.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJBaseViewController.h"
@interface OrderesComfilmController : JJBaseViewController

@property (strong, nonatomic) NSDictionary *dicFromDetial;
@property (copy, nonatomic) NSString *strAttributeName;//属性名字
@property (copy, nonatomic) NSString *strAttribute;//属性值（用于下单）
@property (copy, nonatomic) NSString *strGoodPrice;//价格
@property (assign, nonatomic) int intBuyNum;//商品数量
@property (strong, nonatomic) NSDictionary *dicDetail;//商品详情
@property (copy, nonatomic) NSString *strGood_id;
@property (copy, nonatomic) NSString *outLine;
@property (assign, nonatomic) BOOL isCart;//购物车进入的属性,如果是购物车isCart为YES
@property (strong, nonatomic) NSDictionary *dicCart;
@property (strong, nonatomic) NSMutableArray *arrCart;

@end
