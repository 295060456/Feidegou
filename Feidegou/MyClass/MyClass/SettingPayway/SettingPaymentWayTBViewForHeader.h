//
//  SettingPaymentWayTBViewForHeader.h
//  Feidegou
//
//  Created by Kite on 2019/11/7.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ViewForHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingPaymentWayTBViewForHeader : ViewForHeader

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier
                               withData:(id)data;

-(void)actionBlock:(TwoDataBlock)block;

@end

NS_ASSUME_NONNULL_END
