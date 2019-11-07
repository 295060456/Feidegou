//
//  StallListVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/25.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "StallListVC.h"
#import "OrderDetail_SellerVC.h"
#import "StallListVC+VM.h"

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
        cell.textLabel.text = @"摊位";
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
        _countdownView.time = 30;
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
    self.gk_navTitle = @"喵粮直通车";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark —— 私有方法
-(void)backBtnClickEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)sure{
    [self.navigationController popViewControllerAnimated:YES];
}
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
    [self.tableView.mj_header endRefreshing];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
   [self.tableView.mj_footer endRefreshing];
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
    StallListTBVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.userInteractionEnabled) {
        [self tableView:tableView
        deleteIndexPath:indexPath];
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.dataMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StallListTBVCell *cell = [StallListTBVCell cellWith:tableView];
    [cell richElementsInCellWithModel:nil];
    @weakify(self)
    [cell actionAnimationFinishedBlock:^{
        @strongify(self)
        cell.userInteractionEnabled = NO;
        cell.countdownView.str = @"废";
        [self showAlertViewTitle:@"已超时"
                         message:@"超过规定时间以后不能继续抢摊"
                     btnTitleArr:@[@"确认"]
                  alertBtnAction:@[@"sure"]];
    }];
    
    [cell actionTapBlock:^{
        @strongify(self)
        if (cell.userInteractionEnabled) {
            [self tableView:tableView
            deleteIndexPath:indexPath];
        }
    }];return cell;
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(0.7 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        @weakify(self)
        [OrderDetail_SellerVC pushFromVC:self_weak_
                           requestParams:nil
                                 success:^(id data) {}
                                animated:YES];
    });
}
//给cell添加动画
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isDelCell) {
        //设置Cell的动画效果为3D效果
        //设置x和y的初始值为0.1；
        cell.layer.transform = CATransform3DMakeScale(0.1,
                                                      0.1,
                                                      1);
        //x和y的最终值为1
        [UIView animateWithDuration:1
                         animations:^{
            cell.layer.transform = CATransform3DMakeScale(1,
                                                          1,
                                                          1);
        }];
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
