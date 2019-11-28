//
//  ChatVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ChatVC.h"

@interface ChatVC ()
<
RCIMConnectionStatusDelegate
>

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;

@end

@implementation ChatVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{
    ChatVC *vc = ChatVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    if ([requestParams isKindOfClass:[RCConversationModel class]]) {
        RCConversationModel *model = (RCConversationModel *)requestParams;
        vc.conversationType = model.conversationType;
        vc.targetId = model.targetId;
        vc.chatSessionInputBarControl.hidden = NO;
        vc.title = @"想显示的会话标题";
    }
    extern NSString *tokenStr;
    RCIM *rcim = [RCIM sharedRCIM];
//    - (void)setRCConnectionStatusChangeDelegate:(id<RCConnectionStatusChangeDelegate>)delegate;
//    [rcim setConnectionStatusDelegate:self];
    rcim.connectionStatusDelegate = vc;
    [rcim connectWithToken:tokenStr
                                success:^(NSString *userId) {
        NSLog(@"%@",userId);
    }error:^(RCConnectErrorCode status) {
        
    }tokenIncorrect:^{}];
    
    switch (comingStyle) {
        case ComingStyle_PUSH:{
            if (rootVC.navigationController) {
                vc.isPush = YES;
                vc.isPresent = NO;
                vc.isFirstComing = YES;
                [rootVC.navigationController pushViewController:vc
                                                       animated:animated];
            }else{
                vc.isPush = NO;
                vc.isPresent = YES;
                [rootVC presentViewController:vc
                                     animated:animated
                                   completion:^{}];
            }
        }break;
        case ComingStyle_PRESENT:{
            vc.isPush = NO;
            vc.isPresent = YES;
            [rootVC presentViewController:vc
                                 animated:animated
                               completion:^{}];
        }break;
        default:
            NSLog(@"错误的推进方式");
            break;
    }return vc;
}

//- (RCMessage *)sendMessage:(RCConversationType)conversationType
//                  targetId:(NSString *)targetId
//                   content:(RCMessageContent *)content
//               pushContent:(NSString *)pushContent
//                  pushData:(NSString *)pushData
//                   success:(void (^)(long messageId))successBlock
//                     error:(void (^)(RCErrorCode nErrorCode, long messageId))errorBlock{
//
//}

-(void)sendUserInfoExtras{
    NSString *content = @"你好";
    
    RCTextMessage *txtMessage = [RCTextMessage messageWithContent:content];
     //        {"nick":"小家伙","portrait":"http:\/\/img.937753.com\/mlhead\/photh\/buy\/6.jpg","order_code":"123456"}
    
    NSDictionary *dataDic = @{
        @"nick":@"kite",
        @"portrait":@"123456",
        @"order_code":@"0987654321"
    };
    NSString *err;
    NSData * data = [NSJSONSerialization dataWithJSONObject:dataDic options:NSJSONWritingPrettyPrinted error:&err];
//    NSString *str = [NSString convertToJsonData:dataDic];
    
    txtMessage.extra = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
//    [NSString convertToJsonData];
    
    
//    @"我是消息里面的附加内容";
    
    
      [[RCIMClient sharedRCIMClient]
                  sendMessage:ConversationType_PRIVATE
                  targetId:@"admin"
                  content:txtMessage
                  pushContent:@"远程推送显示的内容"
                  pushData:@"远程推送的附加信息"
                  success:^(long messageId) {

                  }
                  error:^(RCErrorCode nErrorCode, long messageId) {

      }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self sendUserInfoExtras];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//     [self sendUserInfoExtras];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
//#pragma mark —— RCConnectionStatusChangeDelegate
//
///*!
//IMLib连接状态的的监听器
//
//@discussion 如果开发者设置了IMLib消息监听之后，当SDK与融云服务器的连接状态发生变化时，会回调此方法。
//*/
//- (void)onConnectionStatusChanged:(RCConnectionStatus)status{
//
//    if (status == ConnectionStatus_Connected) {
//        [self sendUserInfoExtras];
//    }
//}


#pragma mark —— RCIMConnectionStatusDelegate
                
/*!
 IMKit连接状态的的监听器

 @param status  SDK与融云服务器的连接状态

 @discussion 如果您设置了IMKit消息监听之后，当SDK与融云服务器的连接状态发生变化时，会回调此方法。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    if (status == ConnectionStatus_Connected) {
        [self sendUserInfoExtras];
    }
}

@end

//
