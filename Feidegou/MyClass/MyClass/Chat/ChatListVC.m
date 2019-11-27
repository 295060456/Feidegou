//
//  ChatListVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ChatListVC.h"
#import "OTCConversationListCellTableViewCell.h"

@interface ChatListVC ()

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;

@end

@implementation ChatListVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{
    ChatListVC *vc = ChatListVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    extern NSString *tokenStr;
    [[RCIM sharedRCIM] connectWithToken:tokenStr
                                success:^(NSString *userId) {
        NSLog(@"%@",userId);
    }error:^(RCConnectErrorCode status) {
        
    }tokenIncorrect:^{
        
    }];
    
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
    }return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationItem.title = @"1234";
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.conversationListTableView reloadData];// 更新未读消息角标
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)setupUI{
    self.navigationItem.title = @"消息";
    // 设置需要显示的会话类型
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    //设置聚合显示
    [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                          @(ConversationType_GROUP)]];
    //设置聊天头像为圆形
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    // 设置没有消息时显示的bgView
//    self.emptyMsgShowIMGV.alpha = 1;
    // 是否显示 无网络时的提示（默认：true）
    [self setIsShowNetworkIndicatorView:true];
    // 置顶Cell bgColor
//    [self setTopCellBackgroundColor:[UIColor redColor]];
    // conversationListTableView继承自UITableView
    // 设置 头、尾视图
    [self.conversationListTableView setTableHeaderView:UIView.new];
    [self.conversationListTableView setTableFooterView:UIView.new];
    // 分割线
    [self.conversationListTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    // bgColor
    self.conversationListTableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    // 内间距
    [self.conversationListTableView setContentInset:UIEdgeInsetsMake(10,
                                                                     0,
                                                                     0,
                                                                     0)];
    // 自定义CELL
//    [self.conversationListTableView registerClass:[OTCConversationListCellTableViewCell class] forCellReuseIdentifier:NSStringFromClass([OTCConversationListCellTableViewCell class])];
    /*
     // 头像style (默认；矩形，圆形)
     [[RCIM sharedRCIM]setGlobalMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
     // 头像size（默认：46*46，必须>36*36）
     [[RCIM sharedRCIM]setGlobalMessagePortraitSize:CGSizeMake(46, 46)];
     
     // 个人信息,自定义后不再有效。没自定义CELL时可使用，并实现getUserInfoWithUserId代理方法（详见聊天页）
     [[RCIM sharedRCIM]setUserInfoDataSource:self];
     */
    
    // 推送
//    [self setupPush];
}

- (CGFloat)rcConversationListTableView:(UITableView *)tableView
               heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [OTCConversationListCellTableViewCell cellHeightWithModel:nil];
}
// will display
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
                             atIndexPath:(NSIndexPath *)indexPath{
    // 选中不高亮（在cell中设置无效）
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [self.emptyIMGView removeFromSuperview];
    // 获取Model会话类型，做其它处理
    RCConversationModel *model = cell.model;
    if(model.conversationModelType != RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION){
        // 必须强制转换
        RCConversationCell *RCcell = (RCConversationCell *)cell;
        // 是否未读消息数（头像右上角，默认：true）
        [RCcell setIsShowNotificationNumber:true];
        
//        RCcell.conversationTitle.text = @"conversationTitle";
//        RCcell.messageContentLabel.text =@"messageContentLabel";
//        RCcell.messageCreatedTimeLabel.text = @"RCcell.messageCreatedTimeLabel";
        
        RCcell.conversationTitle.font = [UIFont fontWithName:@"PingFangSC-Light" size:18];
        RCcell.messageContentLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:16];
        RCcell.messageCreatedTimeLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14];
    }
}
//点击消息列表进行跳转
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    @weakify(self)
    [ChatVC ComingFromVC:self_weak_
                withStyle:ComingStyle_PUSH
            requestParams:model
                  success:^(id data) {}
                 animated:YES];
}
//收到消息 --- 更新未读角标
-(void)onRCIMReceiveMessage:(RCMessage *)message
                       left:(int)left{
    [self.conversationListTableView reloadData];
}

@end
