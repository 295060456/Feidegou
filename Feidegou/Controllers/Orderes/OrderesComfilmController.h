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
//属性名字
@property (strong, nonatomic) NSString *strAttributeName;

//属性值（用于下单）
@property (strong, nonatomic) NSString *strAttribute;
//价格
@property (strong, nonatomic) NSString *strGoodPrice;
//商品数量
@property (assign, nonatomic) int intBuyNum;
//商品详情
@property (strong, nonatomic) NSDictionary *dicDetail;
@property (strong, nonatomic) NSString *strGood_id;
@property (strong, nonatomic) NSString *outLine;

//购物车进入的属性
//如果是购物车isCart为YES
@property (assign, nonatomic) BOOL isCart;
@property (strong, nonatomic) NSDictionary *dicCart;
@property (strong, nonatomic) NSMutableArray *arrCart;
@end
