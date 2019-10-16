//
//  JJHttpClient+TwoZero.h
//  Vendor
//
//  Created by 谭自强 on 2016/12/15.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJHttpClient.h"

@interface JJHttpClient (TwoZero)

//修改昵称
-(RACSignal *)requestLeftNickname:(NSString *)nickname
                       andUserid:(NSString *)userid;
//修改头像
-(RACSignal *)requestHeadImageHead:(NSData *)data
                        andUserid:(NSString *)user_id;
@end
