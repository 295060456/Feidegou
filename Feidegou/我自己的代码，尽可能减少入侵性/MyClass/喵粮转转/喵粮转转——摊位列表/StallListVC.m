//
//  StallListVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/25.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "StallListVC.h"
#import "StallListVC+VM.h"

@interface StallListVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isDelCell;

@end

@implementation StallListVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated{
    StallListVC *vc = StallListVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    vc.isDelCell = NO;
    if (rootVC.navigationController) {
        vc.isPush = YES;
        vc.isPresent = NO;
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
    self.gk_navTitle = @"喵粮转转";
    Toast(@"收到款项请立即发货、如果没有及时发货，将可能面临账号被冻结的处理");
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.tableView.alpha = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SRWebSocketDidOpen)
                                                 name:kWebSocketDidOpenNote
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SRWebSocketDidReceiveMsg:)
                                                 name:kWebSocketdidReceiveMessageNote
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(SRWebSocketDidClose:)
                                                 name:kWebSocketDidCloseNote
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    #warning 如果有机会那么进入下个页面
    [self check];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[SocketRocketUtility instance] SRWebSocketClose];//关闭WebSocket
    [self onlinePeople:@"Offline"];
}
#pragma mark —— 私有方法
-(void)backBtnClickEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
//    [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:BaseWebSocketURL];
    //传user_id
    ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:[BaseWebSocketURL stringByAppendingString:[NSString stringWithFormat:@"/%@",model.userId]]];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
   [self pullToRefresh];
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCALING_RATIO(50);
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];

    //如果有机会那么进入下个页面
    @weakify(self)
    [OrderDetailVC ComingFromVC:self_weak_
                      withStyle:ComingStyle_PUSH
                  requestParams:self.dataMutArr[indexPath.row]
                        success:^(id data) {}
                       animated:YES];
    
//    StallListTBVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (cell.userInteractionEnabled) {
//        [self tableView:tableView
//        deleteIndexPath:indexPath];
//    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.dataMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StallListTBVCell *cell = [StallListTBVCell cellWith:tableView];
    //张三求购11g喵粮
    [cell richElementsInCellWithModel:self.dataMutArr[indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView
 deleteIndexPath:(NSIndexPath *)indexPath{
    //先移除数据源
    self.isDelCell = YES;

//    [self.dataMutArr removeObjectAtIndex:indexPath.row];
//
//    [self.tableView beginUpdates];
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                            withRowAnimation:UITableViewRowAnimationMiddle];
//    [self.tableView endUpdates];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
//                    withRowAnimation:UITableViewRowAnimationNone];
    
    [self 抢摊位:self.dataMutArr[indexPath.row]
    indexPath:indexPath];
}
//给cell添加动画
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isDelCell) {
//        //设置Cell的动画效果为3D效果
//        //设置x和y的初始值为0.1；
//        cell.layer.transform = CATransform3DMakeScale(0.1,
//                                                      0.1,
//                                                      1);
//        //x和y的最终值为1
//        [UIView animateWithDuration:1
//                         animations:^{
//            cell.layer.transform = CATransform3DMakeScale(1,
//                                                          1,
//                                                          1);
//        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.tableFooterView = UIView.new;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
        _tableView.mj_footer.hidden = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }return _tableView;
}

-(NSMutableArray<StallListModel *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

@end


@interface StallListTBVCell ()

@property(nonatomic,copy)ActionBlock blockAnimationFinishedAction;
@property(nonatomic,copy)ActionBlock blockTapAction;

@end

@implementation StallListTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    StallListTBVCell *cell = (StallListTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[StallListTBVCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:ReuseIdentifier
                                                            margin:SCALING_RATIO(5)];
        
        cell.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        [UIView cornerCutToCircleWithView:cell
                          AndCornerRadius:10.f];
        [UIView colourToLayerOfView:cell
                         WithColour:kWhiteColor
                     AndBorderWidth:0.3f];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(50);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.countdownView.alpha = 1;
    if ([model isKindOfClass:[StallListModel class]]) {
        StallListModel *stallListModel = (StallListModel *)model;
        self.textLabel.text = [NSString stringWithFormat:@"%@求购%@g喵粮",stallListModel.byname,stallListModel.quantity];
    }
}

-(void)actionAnimationFinishedBlock:(ActionBlock)block{
    _blockAnimationFinishedAction = block;
}

-(void)actionTapBlock:(ActionBlock)block{
    _blockTapAction = block;
}

#pragma mark —— lazyLoad
-(CountdownView *)countdownView{
    if (!_countdownView) {
        _countdownView = CountdownView.new;
        _countdownView.time = 2;
        _countdownView.str = @"抢";
        @weakify(self)
        _countdownView.blockTapAction = ^{
            @strongify(self)
            NSLog(@"主动点击");
            if (self.blockTapAction) {
                self.blockTapAction();
            }
        };
        _countdownView.blockAnimationFinishedAction = ^{
             @strongify(self)
            NSLog(@"动画结束该干嘛？");
            if (self.blockAnimationFinishedAction) {
                self.blockAnimationFinishedAction();
            }
        };
        [self.contentView addSubview:_countdownView];
        [_countdownView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-10));
            CGFloat h = MIN(SCALING_RATIO(30), self.contentView.mj_h);
            make.size.mas_equalTo(CGSizeMake(h, h));
        }];
        [self.contentView layoutIfNeeded];
    }return _countdownView;
}

@end

