//
//  PlatformConversationModel.h
//  Feidegou
//
//  Created by Kite on 2019/12/3.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlatformConversationModel : RCConversationModel

@property(nonatomic,copy)NSString *nick;
@property(nonatomic,copy)NSString *portrait;
@property(nonatomic,copy)NSString *order_code;
@property(nonatomic,copy)NSString *userID;
@property(nonatomic,copy)NSString *myOrderCode;
@property(nonatomic,copy)NSString *buyer;

@end

NS_ASSUME_NONNULL_END
