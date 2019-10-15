//
//  UILabel+helper.h
//  guanggaobao
//
//  Created by 谭自强 on 16/6/28.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabelBlackBig.h"
#import "UILabelBlackSmall.h"
#import "UILabelBlackMiddle.h"
#import "UILabelDarkSmall.h"
#import "UILabelDarkMiddel.h"
#import "UILabelDarkBig.h"
#import "UILabelDarkGarySmall.h"
#import "UILabelDarkGaryMiddle.h"
#import "UILabelDarkGaryBig.h"

@interface UILabel (helper)
/* 去掉label的null
 */
- (void)setTextNull:(NSString *)string;
/* label的null变为暂无
 */
- (void)setTextZanwu:(NSString *)string;
/* label显示小数点两位
 */
- (void)setTextFolatTwo:(NSString *)string;
/* label的null变为其他
 */
- (void)setText:(NSString *)string andTip:(NSString *)strTip;
/* 店铺价格
 */
- (void)setTextVendorPrice:(NSString *)priceNow andOldPrice:(NSString *)priceOld;
/* 商品价格
 */
- (void)setTextGoodPrice:(NSString *)priceNow andDB:(NSString *)db;
@end
