//
//  WholesaleMarket_VipVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/13.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleMarket_VipVC.h"
#import "WholesaleMarket_VipVC+VM.h"
#import "WholesaleOrders_AdvanceVC.h"
#import "ReleaseOrderVC.h"

@interface WholesaleMarket_VipVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UIButton *releaseBtn;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)long indexPathRow;

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
    self.currentPage = 1;
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark —— 点击事件
-(void)OutofStock{
    //去下架
    self.wholesaleMarket_VipModel = self.dataMutArr[self.indexPathRow];
    if (self.wholesaleMarket_VipModel) {
        [self CatfoodSale_delURL_networking:(long)self.indexPathRow];
    }else{
        Toast(@"数据异常");
    }
}

-(void)sorry{

}
#pragma mark —— 私有方法
-(void)releaseBtnClickEvent:(UIButton *)sender{
    NSLog(@"发布订单");
    @weakify(self)
    [ReleaseOrderVC pushFromVC:self_weak_
                 requestParams:self.requestParams
                       success:^(id data) {}
                      animated:YES];
}

-(void)backBtnClickEvent:(UIButton *)sender{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
    [self netWorking];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    self.currentPage++;
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WholesaleMarket_VipTBVCell cellHeightWithModel:Nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    self.indexPathRow = indexPath.row;
//    Toast(@"Vip商家不可购买");
//    self.dataMutArr[indexPath.row];
    if (self.dataMutArr.count) {
        [self showAlertViewTitle:@"您确定要下架？"
                     message:@""
                 btnTitleArr:@[@"去下架",@"手滑，点错了"]
              alertBtnAction:@[@"OutofStock",@"sorry"]];
    }else{
        Toast(@"数据异常");
    }
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.dataMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WholesaleMarket_VipTBVCell *cell = [WholesaleMarket_VipTBVCell cellWith:tableView];
    cell.backgroundColor = RandomColor;
    if (self.dataMutArr.count) {
        [cell richElementsInCellWithModel:self.dataMutArr[indexPath.row]];
    }return cell;
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
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = UIView.new;
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.mj_footer.hidden = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//推荐该方法
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
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

-(NSMutableArray<WholesaleMarket_VipModel *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

@end

@interface WholesaleMarket_VipTBVCell (){
    
}

@property(nonatomic,strong)UILabel *userNameLab;//用户名
@property(nonatomic,strong)UILabel *numLab;//数量
@property(nonatomic,strong)UILabel *priceLab;//单价
@property(nonatomic,strong)UILabel *limitLab;//限额
@property(nonatomic,strong)UILabel *purchaseLab;//购买
@property(nonatomic,strong)UILabel *paymentMethodLab;//支付方式

@end

@implementation WholesaleMarket_VipTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    WholesaleMarket_VipTBVCell *cell = (WholesaleMarket_VipTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[WholesaleMarket_VipTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:ReuseIdentifier
                                                        margin:SCALING_RATIO(10)];
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"猫和鱼")];
        [UIView cornerCutToCircleWithView:cell
                          AndCornerRadius:10.f];
        [UIView colourToLayerOfView:cell
                         WithColour:kWhiteColor
                     AndBorderWidth:0.3f];
        [UIView cornerCutToCircleWithView:cell.contentView
                          AndCornerRadius:10.f];
        [UIView colourToLayerOfView:cell.contentView
                         WithColour:kWhiteColor
                     AndBorderWidth:0.3f];
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(130);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    if ([model isKindOfClass:[WholesaleMarket_VipModel class]]) {
        WholesaleMarket_VipModel *wholesaleMarket_AdvanceModel = (WholesaleMarket_VipModel *)model;
        //payment_type 0、都没有;2、支付宝;3、微信;4、银行卡;5、支付宝 + 微信;6、支付宝 + 银行卡;7、微信 + 银行卡;9、支付宝 + 微信 + 银行卡
        self.userNameLab.text = [NSString stringWithFormat:@"用户名:%@",[NSString ensureNonnullString:wholesaleMarket_AdvanceModel.seller_name ReplaceStr:@"暂无信息"]];
        self.numLab.text = [NSString stringWithFormat:@"数量:%@",[[NSString ensureNonnullString:wholesaleMarket_AdvanceModel.quantity ReplaceStr:@"无"] stringByAppendingString:@" g"]];
        self.priceLab.text = [NSString stringWithFormat:@"单价:%@",[[NSString ensureNonnullString:wholesaleMarket_AdvanceModel.price ReplaceStr:@"无"] stringByAppendingString:@" CNY"]];
        self.limitLab.text = [NSString stringWithFormat:@"限额:%@ ~ %@ ",[[NSString ensureNonnullString:wholesaleMarket_AdvanceModel.quantity_min ReplaceStr:@"无"] stringByAppendingString:@"g"],[[NSString ensureNonnullString:wholesaleMarket_AdvanceModel.quantity_max ReplaceStr:@"无"] stringByAppendingString:@"g"]];
        switch ([wholesaleMarket_AdvanceModel.payment_type intValue]) {
            case 0:{//都没有
                self.paymentMethodLab.text = @"支付方式:暂时缺乏";
            }break;
            case 2:{//支付宝
                self.paymentMethodLab.text = @"支付方式:支付宝";
            }break;
            case 3:{//微信
                self.paymentMethodLab.text = @"支付方式:微信";
            }break;
            case 4:{//银行卡
                self.paymentMethodLab.text = @"支付方式:银行卡";
            }break;
            case 5:{//支付宝 + 微信
                self.paymentMethodLab.text = @"支付方式:支付宝/微信";
            }break;
            case 6:{//支付宝 + 银行卡
                self.paymentMethodLab.text = @"支付方式:支付宝银行卡";
            }break;
            case 7:{//微信 + 银行卡
                self.paymentMethodLab.text = @"支付方式:微信/银行卡";
            }break;
            case 9:{//支付宝 + 微信 + 银行卡
                self.paymentMethodLab.text = @"支付方式:支付宝/微信/银行卡";
            }break;
            default:
                break;
        }
        [self.userNameLab sizeToFit];
        [self.numLab sizeToFit];
        [self.priceLab sizeToFit];
        [self.limitLab sizeToFit];
        [self.paymentMethodLab sizeToFit];
        self.purchaseLab.alpha = 1;
    }
}
#pragma mark —— lazyLoad
-(UILabel *)userNameLab{
    if (!_userNameLab) {
        _userNameLab = UILabel.new;
        [self.contentView addSubview:_userNameLab];
        [_userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(SCALING_RATIO(5));
        }];
    }return _userNameLab;
}

-(UILabel *)numLab{
    if (!_numLab) {
        _numLab = UILabel.new;
        [self.contentView addSubview:_numLab];
        [_numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userNameLab.mas_bottom).offset(SCALING_RATIO(3));
            make.left.equalTo(self.userNameLab);
        }];
    }return _numLab;
}

-(UILabel *)priceLab{
    if (!_priceLab) {
        _priceLab = UILabel.new;
        [self.contentView addSubview:_priceLab];
        [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userNameLab);
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-5));
        }];
    }return _priceLab;
}

-(UILabel *)limitLab{
    if (!_limitLab) {
        _limitLab = UILabel.new;
        [self.contentView addSubview:_limitLab];
        [_limitLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.numLab.mas_bottom).offset(SCALING_RATIO(3));
            make.left.equalTo(self.userNameLab);
        }];
    }return _limitLab;
}

-(UILabel *)purchaseLab{
    if (!_purchaseLab) {
        _purchaseLab = UILabel.new;
        _purchaseLab.backgroundColor = kOrangeColor;
        [UIView cornerCutToCircleWithView:_purchaseLab
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_purchaseLab
                         WithColour:kWhiteColor
                     AndBorderWidth:0.3f];
        _purchaseLab.text = @"点击进行下架";
        [_purchaseLab sizeToFit];
        [self.contentView addSubview:_purchaseLab];
        [_purchaseLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.equalTo(self.contentView).offset(SCALING_RATIO(-5));
        }];
    }return _purchaseLab;
}

-(UILabel *)paymentMethodLab{
    if (!_paymentMethodLab) {
        _paymentMethodLab = UILabel.new;
        [UIView cornerCutToCircleWithView:_paymentMethodLab
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_paymentMethodLab
                         WithColour:kWhiteColor
                     AndBorderWidth:0.3f];
        [_paymentMethodLab sizeToFit];
        [self.contentView addSubview:_paymentMethodLab];
        [_paymentMethodLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(SCALING_RATIO(-5));
            make.left.equalTo(self.userNameLab);
        }];
    }return _paymentMethodLab;
}

@end
