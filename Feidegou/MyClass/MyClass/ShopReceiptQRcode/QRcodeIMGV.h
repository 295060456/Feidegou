//
//  QRcodeIMGV.h
//  Feidegou
//
//  Created by Kite on 2019/11/27.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRcodeIMGV : UIImageView

@property(nonatomic,copy)NSString *QRcodeStr;

-(instancetype)initWithStyle:(PaywayType)paywayType;
-(void)QRcode;//二维码信息调用
-(void)imgCode:(NSString *)QRcodeStr;//图片信息调用
-(void)actionBlock:(DataBlock)block;


@end

NS_ASSUME_NONNULL_END
