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
<
RCIMConnectionStatusDelegate
>

@property(nonatomic,strong)MJRefreshAutoGifFooter *tableViewFooter;
@property(nonatomic,strong)MJRefreshGifHeader *tableViewHeader;
@property(nonatomic,strong)MJRefreshBackNormalFooter *refreshBackNormalFooter;

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

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    ChatListVC *vc = ChatListVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:ConversationType_PRIVATE]];
    [vc setDisplayConversationTypes:array];
    [vc setCollectionConversationType:nil];
    vc.isEnteredToCollectionViewController = YES;
    
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

-(instancetype)init{
    if ([super init]) {
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
        [self setIsShowNetworkIndicatorView:YES];
        // 置顶Cell bgColor
        [self setTopCellBackgroundColor:kWhiteColor];
        // conversationListTableView继承自UITableView
        // 设置 头、尾视图
        [self.conversationListTableView setTableHeaderView:UIView.new];
        [self.conversationListTableView setTableFooterView:UIView.new];
        // 分割线
        [self.conversationListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        // bgColor
        self.conversationListTableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        // 内间距
        [self.conversationListTableView setContentInset:UIEdgeInsetsMake(10,
                                                                         0,
                                                                         0,
                                                                         0)];
        /*
        融云 sdk 的机制是，在 connect 后，会解析 token 获取到对应的 userId，然后根据 userId 打开对应的数据库（如果数据库中有该 userId 的数据），之后，使用者才可以调用获取历史消息，会话列表的接口，并获取到数据。

        所以，不论有没有网络，使用者都应该调用 connect。

        拿不到数据的原因之一，没有调用 connect，没有打开对应用户的数据库。
         */
        extern NSString *tokenStr;
        RCIM *rcim = [RCIM sharedRCIM];
        rcim.connectionStatusDelegate = self;
        [rcim connectWithToken:tokenStr
                       success:^(NSString *userId) {
            NSLog(@"%@",userId);
        }error:^(RCConnectErrorCode status) {
            
        }tokenIncorrect:^{}];
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.conversationListTableView.mj_header = self.tableViewHeader;
    self.conversationListTableView.mj_footer = self.tableViewFooter;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];//和GK冲突，还原设置
    self.tabBarController.tabBar.hidden = YES;
    [self.conversationListTableView.mj_header beginRefreshing];
    [self.conversationListTableView reloadData];// 更新未读消息角标
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

// 下拉刷新
-(void)pullToRefresh{//轮询
    NSLog(@"下拉刷新");
    [self.conversationListTableView.mj_header endRefreshing];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    [self.conversationListTableView.mj_footer endRefreshing];
}

#pragma mark —— RCIMConnectionStatusDelegate
/*!
 IMKit连接状态的的监听器

 @param status  SDK与融云服务器的连接状态

 @discussion 如果您设置了IMKit消息监听之后，当SDK与融云服务器的连接状态发生变化时，会回调此方法。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    if (status == ConnectionStatus_Connected) {
        
    }
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

-(MJRefreshGifHeader *)tableViewHeader{
    if (!_tableViewHeader) {
        _tableViewHeader =  [MJRefreshGifHeader headerWithRefreshingTarget:self
                                                          refreshingAction:@selector(pullToRefresh)];
        // 设置普通状态的动画图片
        [_tableViewHeader setImages:@[kIMG(@"catFoods")]
                           forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [_tableViewHeader setImages:@[kIMG(@"kitty")]
                           forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [_tableViewHeader setImages:@[kIMG(@"catClaw")]
                           forState:MJRefreshStateRefreshing];
        // 设置文字
        [_tableViewHeader setTitle:@"Click or drag down to refresh"
                          forState:MJRefreshStateIdle];
        [_tableViewHeader setTitle:@"Loading more ..."
                          forState:MJRefreshStateRefreshing];
        [_tableViewHeader setTitle:@"No more data"
                          forState:MJRefreshStateNoMoreData];
        // 设置字体
        _tableViewHeader.stateLabel.font = [UIFont systemFontOfSize:17];
        // 设置颜色
        _tableViewHeader.stateLabel.textColor = KLightGrayColor;
    }return _tableViewHeader;
}

-(MJRefreshAutoGifFooter *)tableViewFooter{
    if (!_tableViewFooter) {
        _tableViewFooter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:self
                                                                refreshingAction:@selector(loadMoreRefresh)];
        // 设置普通状态的动画图片
        [_tableViewFooter setImages:@[kIMG(@"catFoods")]
                           forState:MJRefreshStateIdle];
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        [_tableViewFooter setImages:@[kIMG(@"kitty")]
                           forState:MJRefreshStatePulling];
        // 设置正在刷新状态的动画图片
        [_tableViewFooter setImages:@[kIMG(@"catClaw")]
                           forState:MJRefreshStateRefreshing];
        // 设置文字
        [_tableViewFooter setTitle:@"Click or drag up to refresh"
                          forState:MJRefreshStateIdle];
        [_tableViewFooter setTitle:@"Loading more ..."
                          forState:MJRefreshStateRefreshing];
        [_tableViewFooter setTitle:@"No more data"
                          forState:MJRefreshStateNoMoreData];
        // 设置字体
        _tableViewFooter.stateLabel.font = [UIFont systemFontOfSize:17];
        // 设置颜色
        _tableViewFooter.stateLabel.textColor = KLightGrayColor;
        _tableViewFooter.hidden = YES;
    }return _tableViewFooter;
}

@end
