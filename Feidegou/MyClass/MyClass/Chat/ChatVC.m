//
//  ChatVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ChatVC.h"
#import "CatFoodsManagementVC.h"

@interface ChatVC ()
<
RCIMConnectionStatusDelegate
>

@property(nonatomic,strong)UIViewController *rootVC;

@property(nonatomic,strong)RCConversationModel *rcConversationModel;
@property(nonatomic,strong)ConversationModel *conversationModel;
@property(nonatomic,strong)PlatformConversationModel *platformConversationModel;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;
@property(nonatomic,strong)UISwipeGestureRecognizer *recognizer;

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
    vc.rootVC = rootVC;
    if ([requestParams isKindOfClass:[ConversationModel class]]){//订单详情——直通车进来
        vc.conversationModel = (ConversationModel *)requestParams;
        vc.conversationType = vc.conversationModel.conversationType;
        vc.targetId = vc.conversationModel.targetId;
        vc.chatSessionInputBarControl.hidden = NO;
        vc.title = vc.conversationModel.conversationTitle;
    }else if ([requestParams isKindOfClass:[PlatformConversationModel class]]){//喵粮管理右上角进
        vc.platformConversationModel = (PlatformConversationModel *)requestParams;
        vc.conversationType = vc.platformConversationModel.conversationType;
        vc.targetId = vc.platformConversationModel.targetId;
        vc.chatSessionInputBarControl.hidden = NO;
        vc.title = vc.platformConversationModel.conversationTitle;
    }else{//从会话列表进
        vc.rcConversationModel = (RCConversationModel *)requestParams;
        vc.conversationType = vc.rcConversationModel.conversationType;
        vc.targetId = vc.rcConversationModel.targetId;
        vc.chatSessionInputBarControl.hidden = NO;
        vc.title = vc.rcConversationModel.conversationTitle;
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
    self.navigationItem.rightBarButtonItem = nil;
//    [self Recognizer];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO];//和GK冲突，还原设置
    self.tabBarController.tabBar.hidden = YES;
    [self.chatSessionInputBarControl setInputBarType:RCChatSessionInputBarControlDefaultType style:RC_CHAT_INPUT_BAR_STYLE_CONTAINER_EXTENTION];
    if ([self.chatSessionInputBarControl.pluginBoardView allItems].count > 2) {
        [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:3];
        [self.chatSessionInputBarControl.pluginBoardView removeItemAtIndex:2];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

//-(void)Recognizer{
//    self.recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self
//                                                               action:@selector(handleSwipeFrom:)];
//    [self.recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
//    [self.view addGestureRecognizer:self.recognizer];
//}
//
// - (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
//    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
//        NSLog(@"swipe down");
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
//        NSLog(@"swipe up");
//    }
//    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
//        NSLog(@"swipe left");
//    }
//    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
//      NSLog(@"swipe right");
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
#warning KKK
-(void)sendUserInfoExtras{
    NSString *content = @"你好";
    RCTextMessage *txtMessage = [RCTextMessage messageWithContent:content];
    NSDictionary *dataDic = nil;
    if (self.rcConversationModel) {
         dataDic = @{};
    }else if (self.conversationModel){
        dataDic = @{
            @"nick":[NSString ensureNonnullString:self.conversationModel.nick ReplaceStr:@""],
            @"portrait":[NSString ensureNonnullString:self.conversationModel.portrait ReplaceStr:@""],
            @"order_code":[NSString ensureNonnullString:self.conversationModel.order_code ReplaceStr:@""],
        };
    }else if (self.platformConversationModel){
        dataDic = @{};
    }else{}
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDic
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:Nil];
    txtMessage.extra = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];
      [[RCIMClient sharedRCIMClient] sendMessage:ConversationType_PRIVATE
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


