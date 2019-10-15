//
//  JJHttpClient+Login.h
//  guanggaobao
//
//  Created by 谭自强 on 15/12/1.
//  Copyright © 2015年 朝花夕拾. All rights reserved.
//

#import "JJHttpClient.h"

@interface JJHttpClient (Login)
//登录
-(RACSignal*)requestLoginUSERNAME:(NSString *)USERNAME andPASSWORD:(NSString *)PASSWORD andIsChangedPsw:(BOOL)isChanged;
//获取验证码
-(RACSignal*)requestRegisterPHONE:(NSString *)PHONE;
//检查获取验证码
-(RACSignal*)requestRegisterPHONE:(NSString *)PHONE andCODE:(NSString *)CODE;
//检查是否已注册
-(RACSignal*)requestIsRegisterPHONE:(NSString *)PHONE;
//检查邀请码是否存在
-(RACSignal*)requestIsRegisterinviterCode:(NSString *)inviterCode;
//注册
-(RACSignal*)requestRegisterPHONE:(NSString *)PHONE andPASSWORD:(NSString *)PASSWORD andinviter_id:(NSString *)inviter_id;

//192.168.0.133:8080/appShop7/query.do?num=3047&PHONE=电话号码
//效验电话号码并发送验证码
//192.168.0.133:8080/appShop7/query.do?num=3048&PHONE=电话号码&CODE=验证码
//比对验证码
//192.168.0.133:8080/appShop7/write.do?num=4018&PHONE=电话号码
//&password_new=password_new
//比对成功，修改密码


//找回密码检查电话号码是否有效
-(RACSignal*)requestPswGetBackPHONE:(NSString *)PHONE andType:(NSString *)strType;
//找回密码比对验证码
-(RACSignal*)requestPswGetBackPHONE:(NSString *)PHONE andCODE:(NSString *)CODE;
//找回密码修改密码
-(RACSignal*)requestPswGetBackPHONE:(NSString *)PHONE andpassword_new:(NSString *)password_new;


//忘记密码获取验证码
-(RACSignal*)requestForgetPswPHONE:(NSString *)PHONE;
//修改密码
-(RACSignal*)requestFindBackPswPHONE:(NSString *)PHONE andPASSWORD:(NSString *)PASSWORD andCODE:(NSString *)CODE;
//极光推送ID
-(RACSignal*)requestJPUSHServiceRegistrationId:(NSString *)registrationId andUserid:(NSString *)userid;

//启动广告
-(RACSignal*)requestAdverStart;
@end
