//
//  LoginViewController.m
//  guanggaobao
//
//  Created by 谭自强 on 15/11/19.
//  Copyright © 2015年 朝花夕拾. All rights reserved.
//

#import "LoginViewController.h"
#import "JJHttpClient+Login.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "UITextFieldPassWord.h"
#import "GettingDeviceIP.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextFieldPassWord *txtPsw;
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnForgetPsw;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property(nonatomic,strong)RACSignal *reqSignal;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.btnRegister setTitleColor:ColorGary forState:UIControlStateNormal];
    [self.btnForgetPsw setTitleColor:ColorGary forState:UIControlStateNormal];
    [self.btnLogin setTitleColor:ColorGary forState:UIControlStateNormal];
    [self.btnLogin setBackgroundColor:ColorGaryButtom];
    [self.txtUserName setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.txtUserName addTarget:self action:@selector(textFiledDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.txtPsw addTarget:self action:@selector(textFiledDidChanged:) forControlEvents:UIControlEventEditingChanged];
}
- (void)textFiledDidChanged:(UITextField *)text{
    NSString *strUserNum = self.txtUserName.text;
    NSString *strPsw = self.txtPsw.text;
    if (![NSString isNullString:strUserNum] && ![NSString isNullString:strPsw]) {
        [self.btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btnLogin setBackgroundColor:ColorRed];
    }else{
        [self.btnLogin setTitleColor:ColorGary forState:UIControlStateNormal];
        [self.btnLogin setBackgroundColor:ColorGaryButtom];
    }
}

- (IBAction)clickButtonLogin:(UIButton *)sender {
    NSString *strUserNum = self.txtUserName.text;
    NSString *strPsw = self.txtPsw.text;
    
#warning 线上环境的一个用户
//    strUserNum = @"88888888888";
//    strPsw = @"123456";
//    strUserNum = @"15167156784";
//    strPsw = @"123456";
    
#warning grade_id = 3 Vip商家
//    strUserNum = @"admin";
//    strPsw = @"123456";

//#warning grade_id = 2 高级商家
//    strUserNum = @"shopping";
//    strPsw = @"123456";
//    strUserNum = @"135662";
//    strPsw = @"123456";

//#warning grade_id = 1 普通商家
//    strUserNum = @"135661";
//    strPsw = @"123456";
    
//#warning grade_id = 0 普通人
//    strUserNum = @"135663";
//    strPsw = @"123456";

//    if ([NSString isNullString:strUserNum]) {
//        [SVProgressHUD showErrorWithStatus:@"请输入用户名"];
//        return;
//    }
//    if (![NSString isUser:strUserNum]) {
//        [SVProgressHUD showErrorWithStatus:@"请输入正确的用户名"];
//        return;
//    }
//    if ([NSString isNullString:strPsw]) {
//        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
//        return;
//    }
//    if (strPsw.length < 6) {
//        [SVProgressHUD showErrorWithStatus:@"请输入正确的密码"];
//        return;
//    }
    
    [self.view endEditing:YES];
    
    if (![NSString isNullString:strUserNum] ||
        ![NSString isNullString:strPsw]) {
        [SVProgressHUD showWithStatus:@"正在登录..."];
        Toast(strUserNum);
        [self my_NetworkingWithArgumentUsername:strUserNum
                                       password:strPsw];
        //    [self old_NetworkingWithArgumentUsername:strUserNum
        //                                    password:strPsw];
    }else{
        Toast(@"请输入账号和密码");
    }
}

-(void)my_NetworkingWithArgumentUsername:(NSString *)username
                                password:(NSString *)password{

    NSMutableDictionary *dataMutDic = NSMutableDictionary.dictionary;
    NSMutableDictionary *params = NSMutableDictionary.dictionary;
    [params setObject:username forKey:@"userName"];
    [params setObject:[EncryptUtils md5_32bits:password] forKey:@"password"];
    // 设置为中国时区
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8 * 3600];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strToday = [dateFormatter stringFromDate:[NSDate date]];
    [params setObject:strToday forKey:@"datetoken"];//token
    [params setObject:[YDDevice getUQID] forKey:@"identity"];//设备号
    [params setObject:[GettingDeviceIP getNetworkIPAddress] forKey:@"loginIp"];//ip

    NSString *strJson = [NSString DataTOjsonString:params];// 字典转为json
    strJson = [NSString encodeToPercentEscapeString:strJson];// encodeing  json
    NSString *strKey =  [NSString encryptionTheParameter:strJson];// 根据json生成Key
    [dataMutDic setObject:strKey forKey:@"key"];
    //最后拼接
    [dataMutDic setObject:strJson forKey:@"data"];
    [dataMutDic setObject:@"4" forKey:@"version"];
    [dataMutDic setObject:@"3028" forKey:@"num"];
    [dataMutDic setObject:@"Yes" forKey:@"isIphone"];

    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.发送GET请求
    /*
     第一个参数:请求路径(不包含参数).NSString
     第二个参数:字典(发送给服务器的数据~参数)
     第三个参数:progress 进度回调
     第四个参数:success 成功回调
        task:请求任务
        responseObject:响应体信息(JSON--->OC对象)
     第五个参数:failure 失败回调
        error:错误信息
     响应头:task.response
     */
    NSString *str = AK;//http://10.10.37.35:8080/SHOPAPP2.0/appShop7/query.do [NSString stringWithFormat:@"%@%@%@/%@",HTTP,IP_Daniel,Port_Daniel,RELATIVE_PATH_QUERY]//登录
    [manager POST:AK
       parameters:dataMutDic
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task,
                    id  _Nullable responseObject) {
        NSLog(@"%@---%@",[responseObject class],responseObject);
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dataDic = (NSDictionary *)responseObject;
            NSString *str = (NSString *)dataDic[@"data"][@"msg"];
            if ([str isEqualToString:@"用户名或密码错误"]) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    Toast(str);
                }];
            }else if ([str isEqualToString:@"登录成功"]){
                ModelLogin *model = [ModelLogin mj_objectWithKeyValues:responseObject[@"data"][@"data"]];
                [[PersonalInfo sharedInstance] updateLoginUserInfo:model];
                if ([[PersonalInfo sharedInstance] isLogined]) {
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate setAlias];
                    [SVProgressHUD showSuccessWithStatus:@"登录成功"];
//                    [self.navigationController popViewControllerAnimated:YES];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
        //            [SVProgressHUD showSuccessWithStatus:@"登录成功但是存取状态异常"];
        //            Toast(@"登录成功但是存取状态异常");
                }
            }else{}
        }
    } failure:^(NSURLSessionDataTask * _Nullable task,
                NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

-(void)old_NetworkingWithArgumentUsername:(NSString *)username
                                 password:(NSString *)password{
     @weakify(self)
    self.disposable = [[[JJHttpClient new] requestLoginUSERNAME:username
                                                    andPASSWORD:password
                                                andIsChangedPsw:NO]
                       subscribeNext:^(ModelLogin *model) {
        @strongify(self)
        if (model) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate setAlias];
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }error:^(NSError *error) {
        @strongify(self)
        self.disposable = nil;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }completed:^{
        @strongify(self)
        self.disposable = nil;
    }];
}

- (IBAction)clickButtonReg:(UIButton *)sender {//快速注册
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardLoginAndRegister bundle:nil];
    RegisterViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)clickButtonForgetPsw:(UIButton *)sender {//忘记密码
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardLoginAndRegister bundle:nil];
    RegisterViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    controller.isForgetPsw = YES;
    [self.navigationController pushViewController:controller animated:YES];
}


@end
