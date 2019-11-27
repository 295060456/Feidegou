//
//  ChatListVC.h
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "ChatVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatListVC : RCConversationListViewController

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
