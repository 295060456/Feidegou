//
//  GiftFoodsModel.h
//  Feidegou
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//用户赠送喵粮
@interface GiftFoodsModel : NSObject

@property(nonatomic,assign)int code;
@property(nonatomic,copy)NSString *message;

@end

NS_ASSUME_NONNULL_END
