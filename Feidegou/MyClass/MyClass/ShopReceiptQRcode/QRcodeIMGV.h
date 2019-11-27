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

@property(nonatomic,strong)NSString *QRcodeStr;
-(void)QRcode;

@end

NS_ASSUME_NONNULL_END
