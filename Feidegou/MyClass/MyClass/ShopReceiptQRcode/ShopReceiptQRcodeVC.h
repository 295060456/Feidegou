//
//  ShopReceiptQRcodeVC.h
//  Feidegou
//
//  Created by Kite on 2019/10/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopReceiptQRcodeVC : BaseVC

@property(nonatomic,copy)NSString *QRcodeStr;
@property(nonatomic,strong)UIImageView *QRcodeIMGV;

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

-(void)QRcode;
-(void)backBtnClickEvent:(UIButton *)sender;


@end

NS_ASSUME_NONNULL_END