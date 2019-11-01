//
//  WholesaleMarketVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/29.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleMarket_AdvanceVC.h"
#import "ReleaseOrderVC.h"

@interface WholesaleMarket_AdvancePopView ()
<
UITextFieldDelegate
>
{
}

@property(nonatomic,strong)UILabel *numLab;
@property(nonatomic,strong)UILabel *paymentMethodLab;
@property(nonatomic,strong)UITextField *textfield;
@property(nonatomic,strong)UIButton *purchaseBtn;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,assign)CGRect framer;
@property(nonatomic,copy)ActionBlock block;

@end

@implementation WholesaleMarket_AdvancePopView

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

- (instancetype)initWithRequestParams:(id)requestParams{
    if (self = [super init]) {
        self.requestParams = requestParams;//支付方式
    }return self;
}

-(void)drawRect:(CGRect)rect{
    self.numLab.alpha = 1;
    self.purchaseBtn.alpha = 1;
    self.textfield.alpha = 1;
    self.paymentMethodLab.text = @"支付方式";
    self.framer = self.frame;
}

-(void)actionBlock:(ActionBlock)block{
    _block = block;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event {
//    NSLog(@"touchesMoved");
    UITouch *touch = [touches anyObject];
    //当前的point
    CGPoint currentP = [touch locationInView:self];
    //以前的point
    CGPoint preP = [touch previousLocationInView:self];
    //x轴偏移的量
    CGFloat offsetX = currentP.x - preP.x;
    //Y轴偏移的量
    CGFloat offsetY = currentP.y - preP.y;
    
    self.transform = CGAffineTransformTranslate(self.transform, offsetX, 0);
    
    if (offsetX < 0) {//向左滑
//        NSLog(@"向左滑");
        
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%f",self.mj_x);

    if (self.mj_x > (100 - SCREEN_WIDTH) / 2) {
        self.frame = self.framer;
    }else{
        NSLog(@"");
        self.frame = CGRectMake(-self.mj_w,
                                self.mj_y,
                                self.mj_w,
                                self.mj_h);
        if (self.block) {
            self.block();
        }
    }
}

#pragma mark —— UITextFieldDelegate
//询问委托人是否应该在指定的文本字段中开始编辑
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
//告诉委托人在指定的文本字段中开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}
//询问委托人是否应在指定的文本字段中停止编辑
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
//告诉委托人对指定的文本字段停止编辑
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
//告诉委托人对指定的文本字段停止编辑
//- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason;
//询问委托人是否应该更改指定的文本
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//询问委托人是否应删除文本字段的当前内容
//- (BOOL)textFieldShouldClear:(UITextField *)textField;
//询问委托人文本字段是否应处理按下返回按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
#pragma mark —— lazyLoad
-(UILabel *)numLab{
    if (!_numLab) {
        _numLab = UILabel.new;
        _numLab.text = @"欲购数量:";
        [_numLab sizeToFit];
        [self addSubview:_numLab];
        [_numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(SCALING_RATIO(5));
        }];
    }return _numLab;
}

-(UILabel *)paymentMethodLab{
    if (!_paymentMethodLab) {
        _paymentMethodLab = UILabel.new;
        [self addSubview:_paymentMethodLab];
        [_paymentMethodLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.numLab);
            make.bottom.equalTo(self).offset(SCALING_RATIO(-5));
        }];
    }return _paymentMethodLab;
}

-(UITextField *)textfield{
    if (!_textfield) {
        _textfield = UITextField.new;
        _textfield.placeholder = @"在此输入数量";
        _textfield.backgroundColor = KGreenColor;
        _textfield.delegate = self;
        [self addSubview:_textfield];
        [_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(SCALING_RATIO(5));
            make.right.equalTo(self.purchaseBtn.mas_left).offset(SCALING_RATIO(-5));
            make.left.equalTo(self.numLab.mas_right);
        }];
    }return _textfield;
}

-(UIButton *)purchaseBtn{
    if (!_purchaseBtn) {
        _purchaseBtn = UIButton.new;
        _purchaseBtn.backgroundColor = kRedColor;
        [_purchaseBtn setTitle:@"购买"
                      forState:UIControlStateNormal];
        [self addSubview:_purchaseBtn];
        [_purchaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(SCALING_RATIO(5));
            make.right.equalTo(self).offset(SCALING_RATIO(-5));
            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(50),
                                             SCALING_RATIO(20)));
        }];
    }return _purchaseBtn;
}

@end

@interface WholesaleMarket_AdvanceTBVCell (){
    
}

@property(nonatomic,strong)UILabel *userNameLab;//用户名
@property(nonatomic,strong)UILabel *numLab;//数量
@property(nonatomic,strong)UILabel *priceLab;//单价
@property(nonatomic,strong)UILabel *limitLab;//限额
@property(nonatomic,strong)UILabel *purchaseLab;//购买
@property(nonatomic,strong)UILabel *paymentMethodLab;//支付方式

@end

@implementation WholesaleMarket_AdvanceTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    WholesaleMarket_AdvanceTBVCell *cell = (WholesaleMarket_AdvanceTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[WholesaleMarket_AdvanceTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
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
    self.userNameLab.text = @"用户名:江泽民";
    self.numLab.text = @"数量:123";
    self.priceLab.text = @"单价:1234";
    self.limitLab.text = @"限额:denconcd";
    self.paymentMethodLab.text = @"支付宝/微信/银行卡";

    [self.userNameLab sizeToFit];
    [self.numLab sizeToFit];
    [self.priceLab sizeToFit];
    [self.limitLab sizeToFit];
    [self.paymentMethodLab sizeToFit];
    self.purchaseLab.alpha = 1;
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
        _purchaseLab.text = @"点击立即购买";
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
        [self.contentView addSubview:_paymentMethodLab];
        [_paymentMethodLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(SCALING_RATIO(-5));
            make.left.equalTo(self.userNameLab);
        }];
    }return _paymentMethodLab;
}

@end

@interface WholesaleMarket_AdvanceVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *refreshBtn;
@property(nonatomic,strong)WholesaleMarket_AdvancePopView *popView;

@property(nonatomic,strong)NSMutableArray *dataMutArr;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation WholesaleMarket_AdvanceVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    WholesaleMarket_AdvanceVC *vc = WholesaleMarket_AdvanceVC.new;
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
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.refreshBtn];
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
#pragma mark —— 私有方法
-(void)refreshBtnClickEvent:(UIButton *)sender{
    [self.tableView.mj_header beginRefreshing];
}

-(void)backBtnClickEvent:(UIButton *)sender{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}
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
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [WholesaleMarket_AdvanceTBVCell cellHeightWithModel:Nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    self.popView.alpha = 1;
    NSLog(@"123");
//    //
//    //先移除数据源
//    //
//    self.isDelCell = YES;
//
//    [self.dataMutArr removeObjectAtIndex:indexPath.row];
//
//    [self.tableView beginUpdates];
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                            withRowAnimation:UITableViewRowAnimationMiddle];
//    [self.tableView endUpdates];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
//                    withRowAnimation:UITableViewRowAnimationNone];
//
//    @weakify(self)
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
//                                 (int64_t)(0.7 * NSEC_PER_SEC)),
//                   dispatch_get_main_queue(), ^{
//        [OrderDetail_BuyerVC pushFromVC:self_weak_
//                          requestParams:nil
//                                success:^(id data) {}
//                               animated:YES];
//    });
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{

    return self.dataMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WholesaleMarket_AdvanceTBVCell *cell = [WholesaleMarket_AdvanceTBVCell cellWith:tableView];
    cell.backgroundColor = RandomColor;
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

-(UIButton *)refreshBtn{
    if (!_refreshBtn) {
        _refreshBtn = UIButton.new;
        [_refreshBtn setImage:kIMG(@"刷新")
                     forState:UIControlStateNormal];
        [_refreshBtn addTarget:self
                        action:@selector(refreshBtnClickEvent:)
              forControlEvents:UIControlEventTouchUpInside];
    }return _refreshBtn;
}

-(WholesaleMarket_AdvancePopView *)popView{
    if (!_popView) {
        _popView = [[WholesaleMarket_AdvancePopView alloc]initWithRequestParams:@""];//支付方式
        _popView.backgroundColor = KLightGrayColor;
        [UIView cornerCutToCircleWithView:_popView
                          AndCornerRadius:10.f];
        [UIView colourToLayerOfView:_popView
                         WithColour:kWhiteColor
                     AndBorderWidth:0.3f];
        [self.view addSubview:_popView];
        [self.view bringSubviewToFront:_popView];
        _popView.frame = CGRectMake(SCALING_RATIO(50),
                                    self.view.mj_h,
                                    SCREEN_WIDTH - SCALING_RATIO(100),
                                    SCALING_RATIO(50));
        @weakify(self)
        [UIView animateWithDuration:0.5f
                              delay:0.1f
             usingSpringWithDamping:0.1//弹簧动画的阻尼值 当该属性为1时，表示阻尼非常大，可以看到几乎是没有什么弹动的幅度
              initialSpringVelocity:1.f//值越小弹簧的动力越小，弹簧拉伸的幅度越小，反之动力越大，弹簧拉伸的幅度越大
                            options:UIViewAnimationOptionCurveEaseOut//时间曲线函数，由快到慢(快入缓出)
                         animations:^{
            @strongify(self)
            self->_popView.frame = CGRectMake(SCALING_RATIO(50),
                                              self.view.mj_h - SCALING_RATIO(170),
                                              SCREEN_WIDTH - SCALING_RATIO(100),
                                              SCALING_RATIO(60));//弹出框高度
        }
                         completion:^(BOOL finished) {
//            @strongify(self)
        }];
        [_popView actionBlock:^{
            @strongify(self)
            [self->_popView removeFromSuperview];
            self->_popView = nil;
        }];
    }return _popView;
}

-(NSMutableArray *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
        [_dataMutArr addObject:@"1"];
        [_dataMutArr addObject:@"2"];
        [_dataMutArr addObject:@"3"];
        [_dataMutArr addObject:@"4"];
        [_dataMutArr addObject:@"5"];
        [_dataMutArr addObject:@"6"];
        [_dataMutArr addObject:@"7"];
        [_dataMutArr addObject:@"8"];
        [_dataMutArr addObject:@"9"];
        [_dataMutArr addObject:@"0"];
    }return _dataMutArr;
}


@end
