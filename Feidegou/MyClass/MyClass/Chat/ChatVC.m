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
        vc.title = model.conversationTitle;
    }
    extern NSString *tokenStr;
    RCIM *rcim = [RCIM sharedRCIM];
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

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];//和GK冲突，还原设置
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
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
#warning KKK
-(void)sendUserInfoExtras{
    NSString *content = @"你好";
    RCTextMessage *txtMessage = [RCTextMessage messageWithContent:content];
    NSDictionary *dataDic = @{
        @"nick":@"kite",
        @"portrait":@"123456",
        @"order_code":@"0987654321"
    };
    NSData * data = [NSJSONSerialization dataWithJSONObject:dataDic
                                                    options:NSJSONWritingPrettyPrinted
                                                      error:Nil];
    txtMessage.extra = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
      [[RCIMClient sharedRCIMClient]
                  sendMessage:ConversationType_PRIVATE
                  targetId:@"admin"
                  content:txtMessage
                  pushContent:@"远程推送显示的内容"
                  pushData:@"远程推送的附加信息"
                  success:^(long messageId) {

                  }
                  error:^(RCErrorCode nErrorCode,
                          long messageId) {
      }];
}

@end


