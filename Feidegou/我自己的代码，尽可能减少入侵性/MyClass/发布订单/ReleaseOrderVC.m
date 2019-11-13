//
//  RealeaseOrderVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/30.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ReleaseOrderVC.h"
#import "ReleaseOrderVC+VM.h"

#pragma ReleaseOrder_viewForHeader
@interface ReleaseOrder_viewForHeader (){
    
}

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *goodsLab;

@end

@implementation ReleaseOrder_viewForHeader

- (instancetype)initWithRequestParams:(id)requestParams{
    if (self = [super init]) {
    }return self;
}

-(void)drawRect:(CGRect)rect{
    self.titleLab.alpha = 1;
    [self layoutIfNeeded];
    self.goodsLab.alpha = 1;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
        _titleLab.text = @"商品";
        [_titleLab sizeToFit];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(SCALING_RATIO(20));
        }];
    }return _titleLab;
}

-(UILabel *)goodsLab{
    if (!_goodsLab) {
        _goodsLab = UILabel.new;
        _goodsLab.textAlignment = NSTextAlignmentCenter;
        _goodsLab.text = @"喵粮";
        [_goodsLab sizeToFit];
        [self.contentView addSubview:_goodsLab];
        [_goodsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.left.equalTo(self.titleLab.mas_right);
        }];
    }return _goodsLab;
}

@end

@interface ReleaseOrderTBVCell ()
<
UITextFieldDelegate,
BEMCheckBoxDelegate
>
{}

@property(nonatomic,strong)UITextField *textfield;
@property(nonatomic,strong)NSMutableArray <BEMCheckBox *>*btnMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*listTitleDataMutArr;
@property(nonatomic,copy)DataBlock block;
@property(nonatomic,copy)DataBlock dataBlock;
@property(nonatomic,strong)NSMutableArray <NSNumber *>*mutArr;
@property(nonatomic,strong)NSMutableArray <NSNumber *>*mutArr2;
@property(nonatomic,strong)NSMutableArray <UILabel *>*labMutArr;
@property(nonatomic,strong)id model;
@property(nonatomic,assign)ReleaseOrderTBVCellType type;

@end

@implementation ReleaseOrderTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    ReleaseOrderTBVCell *cell = (ReleaseOrderTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[ReleaseOrderTBVCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:ReuseIdentifier
                                                   margin:SCALING_RATIO(5)];
        cell.backgroundColor = kClearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(50);
}

-(void)drawRect:(CGRect)rect{
    [self.textLabel sizeToFit];
    if ([self.model isKindOfClass:[NSArray class]]) {
        switch (self.type) {
            case ReleaseOrderTBVCellType_Textfield:{
                self.detailTextLabel.text = @"g";
                self.textfield.placeholder = self.model[0];
                [self layoutIfNeeded];
                if ([self.model[0] isEqualToString:@"请输入数量"]) {
                    [_textfield mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.top.bottom.equalTo(self.contentView);
                        make.left.equalTo(self.textLabel.mas_right).offset(SCALING_RATIO(40));
                        make.right.equalTo(self.detailTextLabel.mas_left).offset(SCALING_RATIO(-10));
                    }];
                }else{}
                [self layoutIfNeeded];
                [self setBorderWithView:self.textfield
                            borderColor:kRedColor
                            borderWidth:1.f
                             borderType:UIBorderSideTypeBottom];
            }break;
            case ReleaseOrderTBVCellType_Lab:{
                self.detailTextLabel.text = self.model[0];
            }break;
            case ReleaseOrderTBVCellType_Btn:{
                if ([self.model[1] isKindOfClass:[ReleaseOrderModel class]]) {
                    if (self.mutArr.count) {
                        [self.mutArr removeAllObjects];
                    }
                    if (self.mutArr2.count) {//装的是：可以显示的，对应的标题
                        [self.mutArr2 removeAllObjects];
                    }
                    ReleaseOrderModel *releaseOrderModel = self.model[1];
#warning 以下是测试代码
//                    releaseOrderModel.alipay = [NSNumber numberWithInt:0];
//                    releaseOrderModel.weixin = [NSNumber numberWithInt:1];
//                    releaseOrderModel.bank = [NSNumber numberWithInt:1];
#warning 以上是测试代码
                    [self.mutArr addObject:releaseOrderModel.alipay];
                    [self.mutArr addObject:releaseOrderModel.weixin];
                    [self.mutArr addObject:releaseOrderModel.bank];
                    if ([releaseOrderModel.alipay intValue]) {
                        [self.mutArr2 addObject:[NSNumber numberWithInt:0]];
                    }
                    if([releaseOrderModel.weixin intValue]){
                        [self.mutArr2 addObject:[NSNumber numberWithInt:1]];
                    }
                    if([releaseOrderModel.bank intValue]){
                        [self.mutArr2 addObject:[NSNumber numberWithInt:2]];
                    }
                    if (self.mutArr2.count == 1) {//如果只有一个支付方式，那么默认点击
                        if (self.block) {
                            self.block(self.mutArr[[self.mutArr2.lastObject intValue]]);
                        }
                    }
                }
                if (self.btnMutArr.count) {
                    [self.btnMutArr removeAllObjects];
                }
                if (self.labMutArr.count) {
                    [self.labMutArr removeAllObjects];
                }
                for (int i = 0; i < self.mutArr2.count ; i++) {//
                    BEMCheckBox *checkBox = BEMCheckBox.new;
//                    checkBox.backgroundColor = RandomColor;
                    [self.btnMutArr addObject:checkBox];//
                    UILabel *titleLab = UILabel.new;
                    [self.labMutArr addObject:titleLab];//!!
                    titleLab.text = self.listTitleDataMutArr[[self.mutArr2[i] intValue]];
                    titleLab.textAlignment = NSTextAlignmentCenter;
//                    titleLab.backgroundColor = RandomColor;
                    [titleLab sizeToFit];
                    // 矩形复选框
                    checkBox.boxType = BEMBoxTypeSquare;
                    checkBox.tag = i;
                    checkBox.delegate = self;
                    // 动画样式
                    checkBox.onAnimationType  = BEMAnimationTypeStroke;
                    checkBox.offAnimationType = BEMAnimationTypeStroke;
                    checkBox.animationDuration = 0.3;
                    // 颜色样式
                    checkBox.tintColor    = KLightGrayColor;
                    checkBox.onTintColor  = HEXCOLOR(0x108EE9);
                    checkBox.onFillColor  = kClearColor;
                    checkBox.onCheckColor = HEXCOLOR(0x108EE9);
                    // 默认选中
                    checkBox.on = YES;
                    checkBox.alpha = 1;//[self.mutArr[i] intValue];
                    [self.contentView addSubview:checkBox];
                    [self.contentView addSubview:titleLab];
                    if (self.btnMutArr.count == 1) {
                        [checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(20), SCALING_RATIO(20)));
                            make.top.equalTo(self.contentView).offset(SCALING_RATIO(10));
                            make.left.equalTo(self.textLabel.mas_right).offset(SCALING_RATIO(10));
                        }];
                        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(checkBox.mas_right).offset(SCALING_RATIO(10));
                            make.top.bottom.equalTo(checkBox);
                        }];
                    }else{
                        [checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(20), SCALING_RATIO(20)));
                            make.top.equalTo(self.contentView).offset(SCALING_RATIO(10));
                            make.left.equalTo(self.labMutArr[i - 1].mas_right).offset(SCALING_RATIO(10));
                        }];
                        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(checkBox.mas_right).offset(SCALING_RATIO(10));
                            make.top.bottom.equalTo(checkBox);
                        }];
                    }
                    [self layoutIfNeeded];
                    NSLog(@"");
                }
            }break;
            case ReleaseOrderTBVCellType_TextfieldOnly:{
                self.textfield.placeholder = self.model[0];
                [self layoutIfNeeded];
                [_textfield mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self.contentView);
                    make.left.equalTo(self.textLabel.mas_right).offset(SCALING_RATIO(40));
                    make.right.equalTo(self.contentView).offset(SCALING_RATIO(-10));
                }];
            }break;
            default:
                break;
        }
    }
}

- (void)richElementsInCellWithModel:(id _Nullable)model
            ReleaseOrderTBVCellType:(ReleaseOrderTBVCellType)type{
    self.model = model;
    self.type = type;
}

-(void)dataBlock:(DataBlock)block{
    _dataBlock = block;
}

-(void)actionBlock:(DataBlock)block{
    _block = block;
}

#pragma mark —— 点击事件

#pragma mark —— BEMCheckBoxDelegate
- (void)didTapCheckBox:(BEMCheckBox *)checkBox {
    NSLog(@"%@", self.listTitleDataMutArr[checkBox.tag]);
    checkBox.selected = !checkBox.selected;
    self.block(checkBox);
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
    if (self.dataBlock) {
        self.dataBlock(textField);
    }
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
-(UITextField *)textfield{
    if (!_textfield) {
        _textfield = UITextField.new;
        _textfield.keyboardType = UIKeyboardTypeDecimalPad;
//        _textfield.backgroundColor = KLightGrayColor;
        _textfield.delegate = self;
        [self.contentView addSubview:_textfield];
        [_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.textLabel.mas_right).offset(SCALING_RATIO(10));
            make.right.equalTo(self.detailTextLabel.mas_left).offset(SCALING_RATIO(-10));
        }];
        [self layoutIfNeeded];
    }return _textfield;
}

-(NSMutableArray<BEMCheckBox *> *)btnMutArr{
    if (!_btnMutArr) {
        _btnMutArr = NSMutableArray.array;
    }return _btnMutArr;
}

-(NSMutableArray<NSString *> *)listTitleDataMutArr{
    if (!_listTitleDataMutArr) {
        _listTitleDataMutArr = NSMutableArray.array;
        [_listTitleDataMutArr addObject:@"支付宝"];
        [_listTitleDataMutArr addObject:@"微信"];
        [_listTitleDataMutArr addObject:@"银行卡"];
    }return _listTitleDataMutArr;
}

-(NSMutableArray<NSNumber *> *)mutArr{
    if (!_mutArr) {
        _mutArr = NSMutableArray.array;
    }return _mutArr;
}

-(NSMutableArray<NSNumber *> *)mutArr2{
    if (!_mutArr2) {
        _mutArr2 = NSMutableArray.array;
    }return _mutArr2;
}

-(NSMutableArray<UILabel *> *)labMutArr{
    if (!_labMutArr) {
        _labMutArr = NSMutableArray.array;
    }return _labMutArr;
}

@end

@interface ReleaseOrderVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UIButton *releaseBtn;
@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*placeholderMutArr;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;

@end

@implementation ReleaseOrderVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{
    ReleaseOrderVC *vc = ReleaseOrderVC.new;
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
#pragma mark —— 私有方法
-(void)backBtnClickEvent:(UIButton *)sender{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
//    if (self.dataMutArr.count) {
//        [self.dataMutArr removeAllObjects];
//    }
    [self gettingPaymentWay];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark —— Lifecycle
-(instancetype)init{
    if (self = [super init]) {
    }return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.isFirstComing = YES;
    self.gk_navTitle = @"发布订单";
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    self.releaseBtn.alpha = 1;
    [self.releaseBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.gk_navigationBar.mj_h +
                                           (self.titleMutArr.count - 2) * SCALING_RATIO(50) +
                                           SCALING_RATIO(40) +
                                           SCALING_RATIO(50));//附加值
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView removeFromSuperview];
}

#pragma mark —— 点击事件
-(void)releaseBtnClickEvent:(UIButton *)sender{
    NSLog(@"发布");
    [self netWorking];
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    ReleaseOrder_viewForHeader *viewForHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:ReuseIdentifier];
    return viewForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCALING_RATIO(40);
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ReleaseOrderTBVCell cellHeightWithModel:nil];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.titleMutArr.count - 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReleaseOrderTBVCell *cell = [ReleaseOrderTBVCell cellWith:tableView];
    cell.textLabel.text = self.titleMutArr[indexPath.row + 2];
    if (indexPath.row == 0 ||//数量
        indexPath.row == 1 ||//最低限额
        indexPath.row == 2) {//最高限额
        if (self.placeholderMutArr.count) {
            [cell richElementsInCellWithModel:@[self.placeholderMutArr[indexPath.row]]
                      ReleaseOrderTBVCellType:ReleaseOrderTBVCellType_Textfield];
        }
        @weakify(self)
        [cell dataBlock:^(id data) {
            @strongify(self)
            if ([data isKindOfClass:[UITextField class]]) {
                UITextField *textfield = (UITextField *)data;
                if ([textfield.placeholder isEqualToString:self.placeholderMutArr[0]]) {//请输入数量
                    self.str_1 = textfield.text;
                }else if([textfield.placeholder isEqualToString:self.placeholderMutArr[1]]){//请输入最低限额
                    self.str_2 = textfield.text;
                }else if([textfield.placeholder isEqualToString:self.placeholderMutArr[2]]){//请输入最高限额
                    self.str_3 = textfield.text;
                }else{}
            }     
        }];
    }else if(indexPath.row == 3){//单价
        if (self.placeholderMutArr.count) {
            [cell richElementsInCellWithModel:@[self.placeholderMutArr[indexPath.row]]
                      ReleaseOrderTBVCellType:ReleaseOrderTBVCellType_Lab];
        }
    }else if (indexPath.row == 4){//收款方式
        if (self.releaseOrderModel) {
            @weakify(self)
            [cell actionBlock:^(id data) {
                @strongify(self)
                if ([data isKindOfClass:[BEMCheckBox class]]) {
                    BEMCheckBox *btn = (BEMCheckBox *)data;//1、支付宝；2、微信；3、银行卡
                    self.str_4 = [NSString stringWithFormat:@"%ld",btn.tag + 1];
                }else if ([data isKindOfClass:[NSNumber class]]){
                    NSNumber *b = (NSNumber *)data;
                    self.str_4 = [NSString stringWithFormat:@"%d",[b intValue]];
                }
            }];
            if (self.placeholderMutArr.count) {
                [cell richElementsInCellWithModel:@[self.placeholderMutArr[indexPath.row],
                                          self.releaseOrderModel]
                ReleaseOrderTBVCellType:ReleaseOrderTBVCellType_Btn];
            }
        }
    }return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//给cell添加动画
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isFirstComing) {
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
        self.isFirstComing = NO;
    }else{
        if (indexPath.row == self.titleMutArr.count) {
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
}
#pragma mark —— lazyLoad
-(BaseTableViewer *)tableView{
    if (!_tableView) {
        _tableView = [[BaseTableViewer alloc]initWithFrame:CGRectZero
                                                   style:UITableViewStyleGrouped];
        _tableView.userInteractionEnabled = YES;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.mj_footer.hidden = YES;
        _tableView.tableFooterView = UIView.new;
        [_tableView registerClass:[ReleaseOrder_viewForHeader class]
forHeaderFooterViewReuseIdentifier:ReuseIdentifier];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
        }];
    }return _tableView;
}

-(UIButton *)releaseBtn{
    if (!_releaseBtn) {
        _releaseBtn = UIButton.new;
        _releaseBtn.backgroundColor = kOrangeColor;
        [UIView cornerCutToCircleWithView:_releaseBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_releaseBtn
                         WithColour:KGreenColor
                     AndBorderWidth:.1f];
        [_releaseBtn setTitle:@"我要发布"
                     forState:UIControlStateNormal];
        [_releaseBtn addTarget:self
                        action:@selector(releaseBtnClickEvent:)
              forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_releaseBtn];
        [_releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SCALING_RATIO(100), SCALING_RATIO(50)));
        }];
    }return _releaseBtn;
}

-(NSMutableArray<NSString *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:@"商品"];
        [_titleMutArr addObject:@"喵粮"];
        [_titleMutArr addObject:@"数量"];
        [_titleMutArr addObject:@"最低限额"];
        [_titleMutArr addObject:@"最高限额"];
        [_titleMutArr addObject:@"单价"];
        [_titleMutArr addObject:@"收款方式"];
    }return _titleMutArr;
}

-(NSMutableArray<NSString *> *)placeholderMutArr{
    if (!_placeholderMutArr) {
        _placeholderMutArr = NSMutableArray.array;
        [_placeholderMutArr addObject:@"请输入数量"];
        [_placeholderMutArr addObject:@"请输入最低限额"];
        [_placeholderMutArr addObject:@"请输入最高限额"];
        if ([self.requestParams isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray *)self.requestParams;
            NSNumber *b = (NSNumber *)arr[2];
            [_placeholderMutArr addObject:[NSString stringWithFormat:@"%.2f g / CNY",[b floatValue]]];
        }
        [_placeholderMutArr addObject:@"请选择收款方式"];
    }return _placeholderMutArr;
}




@end



