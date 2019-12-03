//
//  PersonalDataChangedListVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "PersonalDataChangedListVC.h"
#import "PersonalDataChangedListVC+VM.h"
#import "PersonalDataChangedListTBViewForHeader.h"

@interface PersonalDataChangedListVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;
@property(nonatomic,assign)BOOL isDelCell;

@end

@implementation PersonalDataChangedListVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    PersonalDataChangedListVC *vc = PersonalDataChangedListVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    vc.page = 1;
    if ([requestParams isKindOfClass:[RCConversationModel class]]) {

    }
    
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navTitle = @"个人喵粮变动清单";
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
// 手动下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
    [self PestCatFood_changelist_netWorking];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    self.page++;
    [self PestCatFood_changelist_netWorking];
}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    PersonalDataChangedListTBViewForHeader *viewForHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:ReuseIdentifier];
    if (!viewForHeader) {
        viewForHeader = [[PersonalDataChangedListTBViewForHeader alloc]initWithReuseIdentifier:ReuseIdentifier
                                                                                      withData:@""];
        
        if (self.dataMutArr.count) {
            [viewForHeader headerViewWithModel:self.dataMutArr[section]];
        }
        @weakify(self)
        [viewForHeader actionBlock:^(id data) {
            @strongify(self)
            NSLog(@"联系");
            Toast(@"功能开发中,敬请期待...");
        }];
    }return viewForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return [PersonalDataChangedListTBViewForHeader headerViewHeightWithModel:Nil];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PersonalDataChangedListTBVCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    self.isDelCell = YES;
    //
    //先移除数据源
    //
    
//    [self.dataMutArr removeObjectAtIndex:indexPath.row];
//
//    [self.tableView beginUpdates];
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                            withRowAnimation:UITableViewRowAnimationMiddle];
//    [self.tableView endUpdates];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
//                    withRowAnimation:UITableViewRowAnimationNone];
    
//    @weakify(self)
//    OrderListModel *orderListModel = self.dataMutArr[indexPath.row];
//    [OrderDetailVC pushFromVC:self_weak_
//                requestParams:orderListModel
//                      success:^(id data) {}
//                     animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalDataChangedListTBVCell *cell = [PersonalDataChangedListTBVCell cellWith:tableView];
    if (self.dataMutArr.count) {
        [cell richElementsInCellWithModel:self.dataMutArr[indexPath.section]];
    }return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataMutArr.count;
}
//给cell添加动画
//-(void)tableView:(UITableView *)tableView
// willDisplayCell:(UITableViewCell *)cell
//forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (!self.isDelCell) {
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
//    }
//}

#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"picLoadErr"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.mj_footer.hidden = YES;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }return _tableView;
}

-(NSMutableArray<PersonalDataChangedListModel *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

@end

@interface PersonalDataChangedListTBVCell ()

@property(nonatomic,strong)UILabel *styleLab;//类型
@property(nonatomic,strong)UILabel *numLab;//数量
@property(nonatomic,strong)UILabel *remarkTitleLab;//备注标题
@property(nonatomic,strong)UILabel *remarkLab;//备注
@property(nonatomic,strong)UILabel *balanceTitleLab;//余额标题
@property(nonatomic,strong)UILabel *orderNumTitleLab;//订单号标题
@property(nonatomic,strong)UILabel *orderNumLab;//订单号

@property(nonatomic,copy)NSString *styleLabStr;//类型
@property(nonatomic,copy)NSString *numLabStr;//数量
@property(nonatomic,copy)NSString *remarkLabStr;//备注
@property(nonatomic,copy)NSString *balanceLabStr;//余额
@property(nonatomic,copy)NSString *orderNumStr;//订单号

@end

@implementation PersonalDataChangedListTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    PersonalDataChangedListTBVCell *cell = (PersonalDataChangedListTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[PersonalDataChangedListTBVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:ReuseIdentifier
                                                              margin:SCALING_RATIO(5)];
        [UIView cornerCutToCircleWithView:cell.contentView
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:cell.contentView
                         WithColour:KLightGrayColor
                     AndBorderWidth:.1f];
        [UIView cornerCutToCircleWithView:cell
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:cell
                         WithColour:KLightGrayColor
                     AndBorderWidth:.1f];
        cell.backgroundColor = kWhiteColor;
        cell.contentView.backgroundColor = kWhiteColor;
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(200);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    if ([model isKindOfClass:[PersonalDataChangedListModel class]]) {
        PersonalDataChangedListModel *personalDataChangedListModel = (PersonalDataChangedListModel *)model;
        self.styleLabStr = [NSString ensureNonnullString:personalDataChangedListModel.change_statusStr ReplaceStr:@"无"];
        switch ([personalDataChangedListModel.change_status intValue]) {
            case 11://赠送增加
            case 12://后台增加
            case 16://结束直通车增加
            case 23://摊位出售
            case 33://摊位发布
            case 24://批发出售
            case 34://批发发布
            case 25://产地出售
            case 35:{//产地发布
                self.numLabStr = [NSString stringWithFormat:@"-%@g",[NSString ensureNonnullString:personalDataChangedListModel.number ReplaceStr:@"无"]];
        }break;
            case 21://赠送减少
            case 22://后台减少
            case 13://摊位购买
            case 14://批发购买
            case 44://批发下架
            case 15://产地购买
            case 26://开启直通车减少
            case 27:{//喂食喵粮减少
                self.numLabStr = [NSString stringWithFormat:@"+%@g",[NSString ensureNonnullString:personalDataChangedListModel.number ReplaceStr:@"无"]];
            }break;
            default:{
                self.numLabStr = @"数据异常";
            }break;
        }
        self.remarkLabStr = [NSString ensureNonnullString:personalDataChangedListModel.detailed ReplaceStr:@"无"];
        self.balanceLabStr = [NSString stringWithFormat:@"%@g",[NSString ensureNonnullString:personalDataChangedListModel.number_new ReplaceStr:@"无"]];
        self.styleLab.alpha = 1;
        self.numLab.alpha = 1;
        self.remarkTitleLab.alpha = 1;
        self.remarkLab.alpha = 1;
        self.balanceTitleLab.alpha = 1;
        self.balanceLab.alpha = 1;
        self.orderNumTitleLab.alpha = 1;
        self.orderNumLab.text = [NSString ensureNonnullString:personalDataChangedListModel.ordercode ReplaceStr:@"无"];
    }
}
#pragma mark —— lazyLoad
-(UILabel *)styleLab{
    if (!_styleLab) {
        _styleLab = UILabel.new;
        _styleLab.text = self.styleLabStr;
        [self.contentView addSubview:_styleLab];
        [_styleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView).offset(SCALING_RATIO(10));
            make.height.mas_equalTo(SCALING_RATIO(30));
        }];
    }return _styleLab;
}

-(UILabel *)numLab{
    if (!_numLab) {
        _numLab = UILabel.new;
        if ([self.numLabStr containsString:@"-"]) {
            _numLab.textColor = KGreenColor;
        }else if ([self.numLabStr containsString:@"+"]){
            _numLab.textColor = kRedColor;
        }
        if (@available(iOS 8.2, *)) {
            _numLab.font = [UIFont systemFontOfSize:40.f weight:.7f];
        } else {
            _numLab.font = [UIFont systemFontOfSize:40.f];
        }
        _numLab.textAlignment = NSTextAlignmentCenter;
        _numLab.text = self.numLabStr;
        [self.contentView addSubview:_numLab];
        [_numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.styleLab.mas_bottom).offset(SCALING_RATIO(0));
            make.left.right.equalTo(self.contentView).offset(SCALING_RATIO(10));
        }];
    }return _numLab;
}

-(UILabel *)remarkTitleLab{
    if (!_remarkTitleLab) {
        _remarkTitleLab = UILabel.new;
        _remarkTitleLab.text = @"备注";
        _remarkTitleLab.numberOfLines = 0;
        [_remarkTitleLab sizeToFit];
        [self.contentView addSubview:_remarkTitleLab];
        [_remarkTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.numLab.mas_bottom).offset(SCALING_RATIO(10));
            make.left.equalTo(self.contentView).offset(SCALING_RATIO(10));
            make.width.mas_equalTo(SCALING_RATIO(50));
        }];
    }return _remarkTitleLab;
}

-(UILabel *)remarkLab{
    if (!_remarkLab) {
        _remarkLab = UILabel.new;
        _remarkLab.text = self.remarkLabStr;
        [_remarkLab sizeToFit];
        _remarkLab.numberOfLines = 0;
        [self.contentView addSubview:_remarkLab];
        [_remarkLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.numLab.mas_bottom).offset(SCALING_RATIO(10));
            make.right.equalTo(self.contentView);
            make.left.equalTo(self.remarkTitleLab.mas_right).offset(SCALING_RATIO(10));
        }];
    }return _remarkLab;
}

-(UILabel *)balanceTitleLab{
    if (!_balanceTitleLab) {
        _balanceTitleLab = UILabel.new;
        _balanceTitleLab.text = @"余额";
//        _balanceTitleLab.backgroundColor = KGreenColor;
        [_balanceTitleLab sizeToFit];
        [self.contentView addSubview:_balanceTitleLab];
        [_balanceTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.remarkLab.mas_bottom).offset(SCALING_RATIO(10));
            make.left.equalTo(self.contentView).offset(SCALING_RATIO(10));
            make.width.mas_equalTo(SCALING_RATIO(50));
        }];
    }return _balanceTitleLab;
}

-(UILabel *)balanceLab{
    if (!_balanceLab) {
        _balanceLab = UILabel.new;
//        _balanceLab.backgroundColor = kRedColor;
        _balanceLab.textAlignment = NSTextAlignmentCenter;
        _balanceLab.text = self.balanceLabStr;
        [self.contentView addSubview:_balanceLab];
        [_balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.remarkLab.mas_bottom).offset(SCALING_RATIO(10));
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(10));
            make.left.equalTo(self.balanceTitleLab.mas_right);
        }];
    }return _balanceLab;
}

-(UILabel *)orderNumTitleLab{
    if (!_orderNumTitleLab) {
        _orderNumTitleLab = UILabel.new;
//        _orderNumTitleLab.textAlignment = NSTextAlignmentCenter;
        _orderNumTitleLab.text = @"订单号:";
        [self.contentView addSubview:_orderNumTitleLab];
        [_orderNumTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(SCALING_RATIO(10));
            make.width.mas_equalTo(SCALING_RATIO(70));
            make.top.equalTo(self.balanceTitleLab.mas_bottom).offset(SCALING_RATIO(10));
        }];
    }return _orderNumTitleLab;
}

-(UILabel *)orderNumLab{
    if (!_orderNumLab) {
        _orderNumLab = UILabel.new;
//        _orderNumLab.backgroundColor = kGrayColor;
        _orderNumLab.textAlignment = NSTextAlignmentCenter;
        _orderNumLab.text = self.orderNumStr;
        [self.contentView addSubview:_orderNumLab];
        [_orderNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.balanceLab.mas_bottom).offset(SCALING_RATIO(10));
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(10));
            make.left.equalTo(self.balanceTitleLab.mas_right);
        }];
    }return _orderNumLab;
}

@end



