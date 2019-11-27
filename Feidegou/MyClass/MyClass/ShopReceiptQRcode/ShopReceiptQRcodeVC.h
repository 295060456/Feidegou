//
//  ShopReceiptQRcodeVC.h
//  Feidegou
//
//  Created by Kite on 2019/10/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "BaseVC.h"
#import "QRcodeIMGV.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopReceiptQRcodeVC : BaseVC

@property(nonatomic,strong)QRcodeIMGV *qrCodeIMGV_wechatPay;
@property(nonatomic,strong)QRcodeIMGV *qrCodeIMGV_alipay;

@property(nonatomic,copy)NSString *QRcodeStr_wechatPay;
@property(nonatomic,copy)NSString *QRcodeStr_alipay;

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                   withStyle:(ComingStyle)comingStyle
               requestParams:(nullable id)requestParams
                     success:(DataBlock)block
                    animated:(BOOL)animated;

//-(void)QRcode;
-(void)backBtnClickEvent:(UIButton *)sender;


@end

NS_ASSUME_NONNULL_END
