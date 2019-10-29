//
//  WholesaleMarket_VipVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/29.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleMarket_VipVC.h"
#import "WholesaleMarketTBViewForHeader.h"

@interface WholesaleMarketTBVCell ()

@property(nonatomic,strong)UILabel *orderIdLab;//订单号
@property(nonatomic,strong)UILabel *numLab;//数量
@property(nonatomic,strong)UILabel *priceLab;//单价
@property(nonatomic,strong)UILabel *typeLab;//类型
@property(nonatomic,strong)UILabel *styleLab;//状态
@property(nonatomic,strong)NSMutableArray <UILabel *>*labMutArr;

@end

@implementation WholesaleMarketTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    WholesaleMarketTBVCell *cell = (WholesaleMarketTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[WholesaleMarketTBVCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                  reuseIdentifier:ReuseIdentifier
                                                           margin:SCALING_RATIO(5)];
        cell.backgroundColor = RandomColor;//kClearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [UIView cornerCutToCircleWithView:cell.contentView
//                          AndCornerRadius:5.f];
//        [UIView colourToLayerOfView:cell.contentView
//                         WithColour:KGreenColor
//                     AndBorderWidth:.1f];
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(50);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.orderIdLab.text = @"11111111111111111111111111111111111111qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq1111112";
    self.numLab.text = @"13";
    self.priceLab.text = @"14";
    self.typeLab.text = @"15";
    self.styleLab.text = @"16";
     //计算lab之间的相隔距离
    __block CGFloat width = 0;
     for (int i = 0; i < self.labMutArr.count; i++) {
         [self.labMutArr[i] mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.bottom.equalTo(self.contentView);
         }];
     }
    [self layoutIfNeeded];
    //加约束以后刷新得出真正的值
    __block CGFloat w = 0;
    for (int i = 0; i < self.labMutArr.count; i++) {
        width += self.labMutArr[i].mj_w;
    }
     w = (SCREEN_WIDTH - width) / self.labMutArr.count;
    //     加约束
    if (width > SCREEN_WIDTH) {
//        label.lineBreakMode =NSLineBreakByCharWrapping;//其中lineBreakMode可选值为
        for (int i = 0; i < self.labMutArr.count; i++) {
            self.labMutArr[i].lineBreakMode = NSLineBreakByTruncatingMiddle;//省略中间，以省略号代替
            self.labMutArr[i].numberOfLines = 1;
            [self.labMutArr[i] mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / self.labMutArr.count, self.mj_h));
                if (i == 0) {
                    make.left.equalTo(self.contentView);
                }else{
                    make.left.equalTo(self.labMutArr[i - 1].mas_right);
                }
            }];
        }
    }else{
        for (int i = 0; i < self.labMutArr.count; i++) {
            self.labMutArr[i].backgroundColor = RandomColor;
            [self.labMutArr[i] mas_updateConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.left.equalTo(self.contentView).offset(w / 2);
                }else{
                    make.left.equalTo(self.labMutArr[i - 1].mas_right).offset(w);
                }
            }];
        }

    }

}
#pragma mark —— lazyLoad
-(UILabel *)orderIdLab{
    if (!_orderIdLab) {
        _orderIdLab = UILabel.new;
        _orderIdLab.text = @"没有值";
        _orderIdLab.numberOfLines = 0;
        _orderIdLab.textAlignment = NSTextAlignmentCenter;
        [_orderIdLab sizeToFit];
        [self.contentView addSubview:_orderIdLab];
    }return _orderIdLab;
}

-(UILabel *)numLab{
    if (!_numLab) {
        _numLab = UILabel.new;
        _numLab.text = @"没有值";
        _numLab.numberOfLines = 0;
        _numLab.textAlignment = NSTextAlignmentCenter;
        [_numLab sizeToFit];
        [self.contentView addSubview:_numLab];
    }return _numLab;
}

-(UILabel *)priceLab{
    if (!_priceLab) {
        _priceLab = UILabel.new;
        _priceLab.text = @"没有值";
        _priceLab.numberOfLines = 0;
        _priceLab.textAlignment = NSTextAlignmentCenter;
        [_priceLab sizeToFit];
        [self.contentView addSubview:_priceLab];
    }return _priceLab;
}

-(UILabel *)typeLab{
    if (!_typeLab) {
        _typeLab = UILabel.new;
        _typeLab.text = @"没有值";
        _typeLab.numberOfLines = 0;
        _typeLab.textAlignment = NSTextAlignmentCenter;
        [_typeLab sizeToFit];
        [self.contentView addSubview:_typeLab];
    }return _typeLab;
}

-(UILabel *)styleLab{
    if (!_styleLab) {
        _styleLab = UILabel.new;
        _styleLab.text = @"没有值";
        _styleLab.numberOfLines = 0;
        _styleLab.textAlignment = NSTextAlignmentCenter;
        [_styleLab sizeToFit];
        [self.contentView addSubview:_styleLab];
    }return _styleLab;
}

-(NSMutableArray<UILabel *> *)labMutArr{
    if (!_labMutArr) {
        _labMutArr = NSMutableArray.array;
        [_labMutArr addObject:_orderIdLab];
        [_labMutArr addObject:_numLab];
        [_labMutArr addObject:_priceLab];
        [_labMutArr addObject:_typeLab];
        [_labMutArr addObject:_styleLab];
    }return _labMutArr;
}

@end

@interface WholesaleMarket_VipVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *releaseBtn;
@property(nonatomic,strong)NSMutableArray <NSString *>*dataMutArr;
@property(nonatomic,strong)WholesaleMarketTBViewForHeader *viewForHeader;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isDelCell;

@end

@implementation WholesaleMarket_VipVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    WholesaleMarket_VipVC *vc = WholesaleMarket_VipVC.new;
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

#pragma mark - Lifecycle
-(instancetype)init{
    
    if (self = [super init]) {
        
    }return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
//    self.navigationItem.title = @"喵粮管理";
    self.gk_navTitle = @"喵粮管理";
    self.tableView.alpha = 1;
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.releaseBtn];
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)releaseBtnClickEvent:(UIButton *)sender{
    NSLog(@"发布订单");
}
#pragma mark —— 私有方法
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    [self.tableView.mj_header endRefreshing];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
   [self.tableView.mj_footer endRefreshing];
}

#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    self.viewForHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:ReuseIdentifier];
    [self.viewForHeader actionBlock:^(MMButton *btn) {
        switch (btn.tag) {
            case 0:{//orderIdBtn 订单号
                NSLog(@"订单号");
            }
                break;
            case 1:{//numBtn 数量
                NSLog(@"数量");
            }
                break;
            case 2:{//priceBtn 单价
                NSLog(@"单价");
            }
                break;
            case 3:{//typeBtn 类型
                NSLog(@"类型");
            }
                break;
            case 4:{//styleBtn 状态
                NSLog(@"状态");
            }
                break;
            default:
                break;
        }
    }];
    return self.viewForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCALING_RATIO(40);
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WholesaleMarketTBVCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    //
    //先移除数据源
    //
    self.isDelCell = YES;
    
    [self.dataMutArr removeObjectAtIndex:indexPath.row];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                            withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                    withRowAnimation:UITableViewRowAnimationNone];
    
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(0.7 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
//        [OrderDetail_SellerVC pushFromVC:self_weak_
//                    requestParams:nil
//                          success:^(id data) {}
//                         animated:YES];
    });
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.dataMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WholesaleMarketTBVCell *cell = [WholesaleMarketTBVCell cellWith:tableView];
    [cell richElementsInCellWithModel:nil];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//给cell添加动画
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
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

#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        [_tableView registerClass:[WholesaleMarketTBViewForHeader class]
forHeaderFooterViewReuseIdentifier:ReuseIdentifier];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
        }];
    }return _tableView;
}

-(UIButton *)releaseBtn{
    if (!_releaseBtn) {
        _releaseBtn = UIButton.new;
        [_releaseBtn setTitle:@"发布订单"
                     forState:UIControlStateNormal];
        [_releaseBtn setTitleColor:kBlueColor
                          forState:UIControlStateNormal];
        [_releaseBtn addTarget:self
                        action:@selector(releaseBtnClickEvent:)
              forControlEvents:UIControlEventTouchUpInside];
    }return _releaseBtn;
}

-(NSMutableArray<NSString *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
        [_dataMutArr addObject:@"0"];
        [_dataMutArr addObject:@"1"];
        [_dataMutArr addObject:@"2"];
        [_dataMutArr addObject:@"3"];
        [_dataMutArr addObject:@"4"];
        [_dataMutArr addObject:@"5"];
        [_dataMutArr addObject:@"6"];
        [_dataMutArr addObject:@"7"];
        [_dataMutArr addObject:@"8"];
        [_dataMutArr addObject:@"9"];
    }return _dataMutArr;
}

@end
