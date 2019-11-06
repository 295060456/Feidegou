//
//  WholesaleMarket_VipVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/29.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleMarket_VipVC.h"
#import "ReleaseOrderVC.h"
#import "WholesaleOrders_VipVC.h"
#import "WholesaleMarket_VipVC+VM.h"

@interface WholesaleMarket_VipVC ()
<
StockViewDataSource,
StockViewDelegate
>

@property(nonatomic,strong)UIButton *releaseBtn;
@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

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
    self.gk_navTitle = @"喵粮批发市场管理";
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.releaseBtn];
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.stockView.alpha = 1;
    self.currentPage = 1;
    [self netWorking];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
#pragma mark —— 私有方法
-(void)backBtnClickEvent:(UIButton *)sender{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    [self.stockView.jjStockTableView.mj_header endRefreshing];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    self.currentPage ++;
   [self.stockView.jjStockTableView.mj_footer endRefreshing];
}
#pragma mark —— StockViewDataSource,StockViewDelegate
#pragma mark —— StockViewDataSource
/**
 控件内容的总行数

 @param stockView JJStockView
 @return 总行数
 */
- (NSUInteger)countForStockView:(JJStockView*)stockView{
    return self.dataMutArr.count;
}
/**
 内容左边自定义View

 @param stockView JJStockView
 @param row 当前行的索引值
 @return 返回自定义View
 */
- (UIView*)titleCellForStockView:(JJStockView*)stockView
                       atRowPath:(NSUInteger)row{
    UILabel *label = UILabel.new;
    label.frame = CGRectMake(0,
                             0,
                             SCALING_RATIO(115),
                             SCALING_RATIO(40));
    WholesaleMarket_VipModel *model = self.dataMutArr[row];
    label.text = [NSString stringWithFormat:@"%@",model.ordercode];
    label.lineBreakMode = NSLineBreakByTruncatingMiddle;
    label.textColor = kGrayColor;
    label.backgroundColor = COLOR_RGB(223.0f,
                                      223.0f,
                                      223.0f,
                                      1.f);
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
/**
 内容右边可滑动自定义View

 @param stockView JJStockView
 @param row 当前行的索引值
 @return 返回自定义View
 */
- (UIView*)contentCellForStockView:(JJStockView*)stockView
                         atRowPath:(NSUInteger)row{
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                          0,
                                                          1000,
                                                          30)];
    bg.backgroundColor = row % 2 == 0 ? kWhiteColor : COLOR_RGB(240.f,
                                                                240.f,
                                                                240.f,
                                                                1.f);
    NSMutableArray <NSString *>*dat = NSMutableArray.array;
    NSMutableArray <NSMutableArray *>*dat2 = NSMutableArray.array;
    for (int d = 0; d < self.dataMutArr.count; d++) {
        WholesaleMarket_VipModel *model = self.dataMutArr[row];
        [dat addObject:[NSString ensureNonnullString:model.quantity ReplaceStr:@""]];
        [dat addObject:[NSString ensureNonnullString:model.price ReplaceStr:@""]];
        
        switch ([model.order_type intValue]) {
            case 1:{
                [dat addObject:@"普通"];
            }
                break;
            case 2:{
                [dat addObject:@"批发"];
            }
                break;
            case 3:{
                [dat addObject:@"平台"];
            }
                break;
            default:
                break;
        }
        
        switch ([model.order_status intValue]) {
            case 0:{
              [dat addObject:@"已支付"];//
            }break;
            case 1:{
                [dat addObject:@"已发单"];//
            }break;
            case 2:{
                [dat addObject:@"已下单"];//
            }break;
            case 3:{
                [dat addObject:@"已作废"];//
            }break;
            case 4:{
                [dat addObject:@"已发货"];//
            }break;
            case 5:{
                [dat addObject:@"已完成"];//
            }break;
            default:
                break;
        }
        [dat2 addObject:dat];
    }
    
    for (int i = 0; i < self.titleMutArr.count - 1; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * 100,
                                                                   0,
                                                                   100,
                                                                   30)];
        //数量、单价、类型、状态
        for (int r = 0; r < dat2.count; r++) {
            label.text = dat2[r][i];
        }

        label.textAlignment = NSTextAlignmentCenter;
        [bg addSubview:label];
    }return bg;
}
#pragma mark —— StockViewDelegate
/**
 左上角的固定不动的自定义View

 @param stockView JJStockView
 @return 自定义View
 */
- (UIView *)headRegularTitle:(JJStockView *)stockView{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               SCALING_RATIO(115),
                                                               SCALING_RATIO(40))];
    label.text = self.titleMutArr[0];
    label.backgroundColor = kWhiteColor;
    label.textColor = kGrayColor;
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}
/**
 可滑动头部View

 @param stockView JJStockView
 @return 自定义View
 */
- (UIView*)headTitle:(JJStockView*)stockView{
    UIView* bg = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                          0,
                                                          1000,
                                                          40)];
    bg.backgroundColor = COLOR_RGB(223.0f,
                                   223.0f,
                                   223.0f,
                                   1.f);
    for (int i = 0; i < self.titleMutArr.count - 1; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * 100,
                                                                   0,
                                                                   SCALING_RATIO(100),
                                                                   SCALING_RATIO(40))];
        label.text = self.titleMutArr[i + 1];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kGrayColor;
        [bg addSubview:label];
    }return bg;
}
/**
 头部高度，headRegularTitle，headTitle共用这个高度
 保持头部的高度一致

 @param stockView JJStockView
 @return 返回指定高度
 */
- (CGFloat)heightForHeadTitle:(JJStockView*)stockView{
    return 40;
}
/**
 内容部分高度，左边和右边共用这个高度

 @param stockView JJStockView
 @param row 当前行的索引值
 @return 返回指定高度
 */
- (CGFloat)heightForCell:(JJStockView*)stockView
               atRowPath:(NSUInteger)row{
    return 30.0f;
}
/**
 点击行事件

 @param stockView JJStockView
 @param row 当前行的索引值
 */
- (void)didSelect:(JJStockView*)stockView atRowPath:(NSUInteger)row{
    NSLog(@"DidSelect Row:%ld",row);
    @weakify(self)
    [WholesaleOrders_VipVC pushFromVC:self_weak_
                    requestParams:nil//self.requestParams
                          success:^(id data) {}
                         animated:YES];
}
#pragma mark —— 点击事件
-(void)releaseBtnClickEvent:(UIButton *)sender{
    NSLog(@"发布订单");
    @weakify(self)
    [ReleaseOrderVC pushFromVC:self_weak_
                 requestParams:self.requestParams
                       success:^(id data) {}
                      animated:YES];
}
#pragma mark —— lazyLoad
-(JJStockView *)stockView{
    if (!_stockView) {
        _stockView = JJStockView.new;
        _stockView.jjStockTableView.mj_header = self.tableViewHeader;
        _stockView.jjStockTableView.mj_footer = self.tableViewFooter;
        _stockView.dataSource = self;
        _stockView.delegate = self;
        [self.view addSubview:_stockView];
        [_stockView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
        }];
    }return _stockView;
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

-(NSMutableArray<WholesaleMarket_VipModel *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

-(NSMutableArray<NSString *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:@"订单号"];
        [_titleMutArr addObject:@"数量"];
        [_titleMutArr addObject:@"单价"];
        [_titleMutArr addObject:@"类型"];
        [_titleMutArr addObject:@"状态"];
    }return _titleMutArr;
}

@end
