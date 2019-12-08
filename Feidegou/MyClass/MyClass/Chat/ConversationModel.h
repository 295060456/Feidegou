//
//  ConversationModel.h
//  Feidegou
//
//  Created by Kite on 2019/12/3.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConversationModel : RCConversationModel

@property(nonatomic,copy)NSString *nick;
@property(nonatomic,copy)NSString *portrait;
@property(nonatomic,copy)NSString *order_code;

@property(nonatomic,copy)NSString *myOrderCode;

@end

NS_ASSUME_NONNULL_END

