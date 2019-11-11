//
//  WholesaleMarketVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/29.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleMarket_AdvanceVC.h"
#import "ReleaseOrderVC.h"
#import "WholesaleOrders_AdvanceVC.h"
#import "WholesaleMarket_AdvanceVC+VM.h"

@interface WholesaleMarket_AdvancePopView ()
<
UITextFieldDelegate,
BEMCheckBoxDelegate
>

@property(nonatomic,strong)UILabel *numLab;
@property(nonatomic,strong)UILabel *userNameLab;
@property(nonatomic,strong)UILabel *paymentMethodLab;
@property(nonatomic,strong)UITextField *textfield;
@property(nonatomic,strong)UIButton *purchaseBtn;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,assign)CGRect framer;
@property(nonatomic,copy)ActionBlock block;
@property(nonatomic,copy)TwoDataBlock dataBlock;
@property(nonatomic,strong)NSMutableArray <NSString *>*dataMutArr;
@property(nonatomic,strong)NSMutableArray <UILabel *>*mutArr;
@property(nonatomic,strong)NSMutableArray <BEMCheckBox *>*checkBoxMutArr;
@property(nonatomic,strong)NSNumber *tagger;
@property(nonatomic,strong)BEMCheckBoxGroup *checkBoxGroup;

@end

@implementation WholesaleMarket_AdvancePopView

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (WholesaleMarket_AdvancePopView *)shareManager {
    static WholesaleMarket_AdvancePopView *wholesaleMarket_AdvancePopView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!wholesaleMarket_AdvancePopView) {
            wholesaleMarket_AdvancePopView = WholesaleMarket_AdvancePopView.new;
        }
    });return wholesaleMarket_AdvancePopView;
}

- (instancetype)initWithRequestParams:(id)requestParams{
    if (self = [super init]) {
        self.requestParams = requestParams;//支付方式
    }return self;
}

-(void)drawRect:(CGRect)rect{
    if ([self.requestParams isKindOfClass:[WholesaleMarket_AdvanceModel class]]) {
        WholesaleMarket_AdvanceModel *wholesaleMarket_AdvanceModel = self.requestParams;
        self.numLab.alpha = 1;
        self.userNameLab.text = [NSString stringWithFormat:@"用户名:%@",[NSString ensureNonnullString:wholesaleMarket_AdvanceModel.seller_name ReplaceStr:@"暂无信息"]];
        self.purchaseBtn.alpha = 1;
        self.textfield.alpha = 1;
        NSLog(@"KKK = %d",[wholesaleMarket_AdvanceModel.payment_type intValue]);
        if (self.dataMutArr.count) {
            [self.dataMutArr removeAllObjects];
        }
        //0、都没有;2、支付宝;3、微信;4、银行卡;5、支付宝 + 微信;6、支付宝 + 银行卡;7、微信 + 银行卡;9、支付宝 + 微信 + 银行卡
        switch ([wholesaleMarket_AdvanceModel.payment_type intValue]) {
            case 0:{//都没有

            }break;
            case 2:{//支付宝
                [self.dataMutArr addObject:@"支付宝"];
            }break;
            case 3:{//微信
                [self.dataMutArr addObject:@"微信"];
            }break;
            case 4:{//银行卡
                [self.dataMutArr addObject:@"银行卡"];
            }break;
            case 5:{//支付宝 + 微信
                [self.dataMutArr addObject:@"支付宝"];
                [self.dataMutArr addObject:@"微信"];
            }break;
            case 6:{//支付宝 + 银行卡
                [self.dataMutArr addObject:@"支付宝"];
                [self.dataMutArr addObject:@"银行卡"];
            }break;
            case 7:{//微信 + 银行卡
                [self.dataMutArr addObject:@"微信"];
                [self.dataMutArr addObject:@"银行卡"];
            }break;
            case 9:{//支付宝 + 微信 + 银行卡
                [self.dataMutArr addObject:@"支付宝"];
                [self.dataMutArr addObject:@"微信"];
                [self.dataMutArr addObject:@"银行卡"];
            }break;
            default:
                break;
        }
#warning 以下是暂时的
//        [self.dataMutArr addObject:@"支付宝"];
//        [self.dataMutArr addObject:@"微信"];
//        [self.dataMutArr addObject:@"银行卡"];
#warning 以上是暂时的
        [self BEMCheckBoxWithDataArr:self.dataMutArr];
        [self setupBEMCheckBoxGroup];
        self.framer = self.frame;
    }
}
#pragma mark —— BEMCheckBoxDelegate
- (void)didTapCheckBox:(BEMCheckBox*)checkBox{
    self.tagger = [NSNumber numberWithInteger:checkBox.tag];
}
#pragma mark —— 私有方法
- (void)setupBEMCheckBoxGroup {//单选
    NSArray *checkBoxArray = self.checkBoxMutArr;
    self.checkBoxGroup = [BEMCheckBoxGroup groupWithCheckBoxes:checkBoxArray];
    self.tagger = [NSNumber numberWithInteger:0];
    if (self.checkBoxMutArr.count) {
        self.checkBoxGroup.selectedCheckBox = self.checkBoxMutArr[0];
    }
    self.checkBoxGroup.mustHaveSelection = YES;
}

-(void)BEMCheckBoxWithDataArr:(NSMutableArray <NSString *>*)dataMutArr{
    //防止此子类不销毁，数据异常
    if (self.mutArr.count ||
        self.checkBoxMutArr.count) {
        [self.mutArr removeAllObjects];
        [self.checkBoxMutArr removeAllObjects];
        
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[BEMCheckBox class]]) {
                [view removeFromSuperview];
            }
            if ([view isKindOfClass:[UILabel class]]) {
                UILabel *lab = (UILabel *)view;
                if ([lab.text isEqualToString:@"支付宝"] ||
                    [lab.text isEqualToString:@"微信"] ||
                    [lab.text isEqualToString:@"银行卡"]) {
                    [lab removeFromSuperview];
                }
            }
        }
    }//

    for (int t = 0; t < self.dataMutArr.count; t++) {
        BEMCheckBox *checkBox = BEMCheckBox.new;
        // 矩形复选框
        checkBox.boxType = BEMBoxTypeSquare;
        checkBox.tag = t;
        checkBox.delegate = self;
        // 动画样式
        checkBox.onAnimationType  = BEMAnimationTypeStroke;
        checkBox.offAnimationType = BEMAnimationTypeStroke;
        checkBox.animationDuration = 0.3;
        // 颜色样式
        checkBox.tintColor    = kWhiteColor;
        checkBox.onTintColor  = HEXCOLOR(0x108EE9);
        checkBox.onFillColor  = kClearColor;
        checkBox.onCheckColor = HEXCOLOR(0x108EE9);

        UILabel *titleLab = UILabel.new;
        titleLab.text = dataMutArr[t];
        titleLab.textAlignment = NSTextAlignmentCenter;
        [titleLab sizeToFit];
        [self addSubview:checkBox];
        [self addSubview:titleLab];
        [self.mutArr addObject:titleLab];//KKK 这个地方用局部变量会出错？
        [self.checkBoxMutArr addObject:checkBox];
        if (self.mutArr.count == 1) {
            [checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.paymentMethodLab.mas_right).offset(SCALING_RATIO(5));
                make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(20), SCALING_RATIO(20)));
                make.centerY.equalTo(self.paymentMethodLab);
            }];
            [self layoutIfNeeded];
            NSLog(@"12");
        }else{
           UILabel *lab = (UILabel *)self.mutArr[self.mutArr.count - 2];
            [checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lab.mas_right).offset(SCALING_RATIO(5));
                make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(20), SCALING_RATIO(20)));
                make.centerY.equalTo(self.paymentMethodLab);
            }];
            [self layoutIfNeeded];
            NSLog(@"12");
        }
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(checkBox.mas_right).offset(SCALING_RATIO(5));
            make.centerY.equalTo(checkBox);
        }];
        [self layoutIfNeeded];
        NSLog(@"12");
    }
}

-(void)clickBlock:(TwoDataBlock)block{
    _dataBlock = block;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event {
//    NSLog(@"touchesMoved");
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self];//当前的point
    CGPoint preP = [touch previousLocationInView:self];//以前的point
    CGFloat offsetX = currentP.x - preP.x;//x轴偏移的量
//    CGFloat offsetY = currentP.y - preP.y;//Y轴偏移的量
    if (offsetX < 0) {//向左滑
        NSLog(@"向左滑");
        self.transform = CGAffineTransformTranslate(self.transform,
                                                    offsetX,
                                                    0);
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches
          withEvent:(UIEvent *)event{
    NSLog(@"%f",self.mj_x);
    if (self.mj_x > (100 - SCREEN_WIDTH) / 2) {
        self.frame = self.framer;
    }else{
        NSLog(@"");
        self.frame = CGRectMake(-self.mj_w,
                                self.mj_y,
                                self.mj_w,
                                self.mj_h);
        [[WholesaleMarket_AdvancePopView shareManager] removeFromSuperview];
    }
}
#pragma mark —— 点击事件
-(void)clickPurchaseBtnEvent:(UIButton *)sender{
    if (self.dataBlock) {
        self.dataBlock(self.textfield,self.tagger);
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
        _numLab.font = [UIFont systemFontOfSize:15];
        [_numLab sizeToFit];
        [self addSubview:_numLab];
        [_numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(SCALING_RATIO(5));
        }];
    }return _numLab;
}

-(UILabel *)userNameLab{
    if (!_userNameLab) {
        _userNameLab = UILabel.new;
        _userNameLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:_userNameLab];
        [_userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.numLab);
            make.top.equalTo(self.numLab.mas_bottom).offset(SCALING_RATIO(5));
        }];
    }return _userNameLab;
}

-(UILabel *)paymentMethodLab{
    if (!_paymentMethodLab) {
        _paymentMethodLab = UILabel.new;
        _paymentMethodLab.text = @"支付方式:";
        _paymentMethodLab.font = [UIFont systemFontOfSize:15];
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
        _textfield.keyboardType = UIKeyboardTypeDecimalPad;
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
        [_purchaseBtn addTarget:self
                         action:@selector(clickPurchaseBtnEvent:)
               forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_purchaseBtn];
        [_purchaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(SCALING_RATIO(5));
            make.right.equalTo(self).offset(SCALING_RATIO(-5));
            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(50),
                                             SCALING_RATIO(20)));
        }];
    }return _purchaseBtn;
}

-(NSMutableArray<NSString *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

-(NSMutableArray<UILabel *> *)mutArr{
    if (!_mutArr) {
        _mutArr = NSMutableArray.array;
    }return _mutArr;
}

-(NSMutableArray<BEMCheckBox *> *)checkBoxMutArr{
    if (!_checkBoxMutArr) {
        _checkBoxMutArr = NSMutableArray.array;
    }return _checkBoxMutArr;
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
    if ([model isKindOfClass:[WholesaleMarket_AdvanceModel class]]) {
        WholesaleMarket_AdvanceModel *wholesaleMarket_AdvanceModel = (WholesaleMarket_AdvanceModel *)model;
        //payment_type 0、都没有;2、支付宝;3、微信;4、银行卡;5、支付宝 + 微信;6、支付宝 + 银行卡;7、微信 + 银行卡;9、支付宝 + 微信 + 银行卡
        self.userNameLab.text = [NSString stringWithFormat:@"用户名:%@",[NSString ensureNonnullString:wholesaleMarket_AdvanceModel.seller_name ReplaceStr:@"暂无信息"]];
        self.numLab.text = [NSString stringWithFormat:@"数量:%@",[NSString ensureNonnullString:wholesaleMarket_AdvanceModel.quantity ReplaceStr:@"无"]];
        self.priceLab.text = [NSString stringWithFormat:@"单价:%@",[NSString ensureNonnullString:wholesaleMarket_AdvanceModel.price ReplaceStr:@"无"]];
        self.limitLab.text = [NSString stringWithFormat:@"限额:%@ ~ %@ ",[NSString ensureNonnullString:wholesaleMarket_AdvanceModel.quantity_min ReplaceStr:@"无"],[NSString ensureNonnullString:wholesaleMarket_AdvanceModel.quantity_max ReplaceStr:@"无"]];
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

@interface WholesaleMarket_AdvanceVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UIButton *refreshBtn;
@property(nonatomic,weak)WholesaleMarket_AdvancePopView *popView;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)long indexPathRow;

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
    
    self.currentPage = 1;
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_popView) {
        [_popView removeFromSuperview];
        _popView = Nil;
    }
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
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
    [self netWorking];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    self.currentPage++;
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
    self.indexPathRow = indexPath.row;
    if (_popView) {
        _popView = nil;
    }
    self.popView.alpha = 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{

    return self.dataMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WholesaleMarket_AdvanceTBVCell *cell = [WholesaleMarket_AdvanceTBVCell cellWith:tableView];
    cell.backgroundColor = RandomColor;
    [cell richElementsInCellWithModel:self.dataMutArr[indexPath.row]];
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
        _popView = [[WholesaleMarket_AdvancePopView shareManager] initWithRequestParams:self.dataMutArr[self.indexPathRow]];//支付方式
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
                                    SCREEN_WIDTH - SCALING_RATIO(90),
                                    SCALING_RATIO(100));
        @weakify(self)
        [UIView animateWithDuration:0.5f
                              delay:0.1f
             usingSpringWithDamping:0.1//弹簧动画的阻尼值 当该属性为1时，表示阻尼非常大，可以看到几乎是没有什么弹动的幅度
              initialSpringVelocity:1.f//值越小弹簧的动力越小，弹簧拉伸的幅度越小，反之动力越大，弹簧拉伸的幅度越大
                            options:UIViewAnimationOptionCurveEaseOut//时间曲线函数，由快到慢(快入缓出)
                         animations:^{
            @strongify(self)
            self->_popView.frame = CGRectMake(SCALING_RATIO(50),
                                              self.view.mj_h - SCALING_RATIO(200),
                                              SCREEN_WIDTH - SCALING_RATIO(90),
                                              SCALING_RATIO(100));//弹出框高度
        }
                         completion:^(BOOL finished) {
//            @strongify(self)
        }];
        
        [_popView clickBlock:^(id data, id data2) {//点击购买 发送 (self.textfield,self.tagger)
//            @strongify(self)
            WholesaleMarket_AdvanceModel *model = (WholesaleMarket_AdvanceModel *)self.dataMutArr[self.indexPathRow];
            if ([data isKindOfClass:[UITextField class]] &&
                [data2 isKindOfClass:[NSNumber class]]) {
                UITextField *textfield = (UITextField *)data;
                if (![NSString isNullString:textfield.text]) {
                    [WholesaleOrders_AdvanceVC pushFromVC:self_weak_
                                            requestParams:@[textfield.text,data2,model.ID]//购买的数量、付款的方式、订单ID
                                                  success:^(id data) {}
                                                 animated:YES];
                }else{
                    Toast(@"请输入金额");
                }
            }
        }];
    }return _popView;
}

-(NSMutableArray<WholesaleMarket_AdvanceModel *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

@end
