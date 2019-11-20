//
//  ChatVC.h
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

typedef enum : NSUInteger {
    ComingStyle_PUSH = 0,
    ComingStyle_PRESENT
} ComingStyle;

NS_ASSUME_NONNULL_BEGIN

@interface ChatVC : RCConversationViewController

+ (instancetype)CominngFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
