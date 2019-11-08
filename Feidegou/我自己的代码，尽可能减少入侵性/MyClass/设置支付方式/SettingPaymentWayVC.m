//
//  SettingPaymentWayVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/7.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "SettingPaymentWayVC.h"
#import "SettingPaymentWayVC+VM.h"
#import "SettingPaymentWayTBViewForHeader.h"

@interface SettingPaymentWayTBVCell ()
<
UITextFieldDelegate
>

@property(nonatomic,strong)UITextField *textField;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,copy)TwoDataBlock block;

@end

@implementation SettingPaymentWayTBVCell

+(instancetype)cellWith:(XDMultTableView *)tableView{
    SettingPaymentWayTBVCell *cell = (SettingPaymentWayTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[SettingPaymentWayTBVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:ReuseIdentifier
                                                        margin:SCALING_RATIO(5)];
        [UIView cornerCutToCircleWithView:cell.contentView
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:cell.contentView
                         WithColour:KGreenColor
                     AndBorderWidth:.1f];
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(50);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    
    self.textLabel.numberOfLines = 0;
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    [self.textLabel sizeToFit];
    
    if ([model isKindOfClass:[NSArray class]]) {
        self.textLabel.text = model[0];
        self.textField.text = model[1];
        self.indexPath = model[2];
    }
}

-(void)actionBlock:(TwoDataBlock)block{
    _block = block;
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
    if (self.block) {
        self.block(textField, self.indexPath);
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
-(UITextField *)textField{
    if (!_textField) {
        _textField = UITextField.new;
//        _textField.backgroundColor = RandomColor;
        _textField.delegate = self;
        [self.contentView addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.textLabel.mj_x +
                                  self.textLabel.mj_w +
                                  SCALING_RATIO(100));
            make.top.equalTo(self.contentView).offset(SCALING_RATIO(5));
            make.bottom.equalTo(self.contentView).offset(SCALING_RATIO(-5));
            make.right.equalTo(self.contentView);
        }];
    }return _textField;
}

@end

@interface SettingPaymentWayVC ()
<
XDMultTableViewDatasource,
XDMultTableViewDelegate
>

@property(nonatomic,strong)UIButton *saveBtn;
@property(nonatomic,strong)NSMutableArray <NSMutableArray *>*dataMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*headViewTitleMutArr;
@property(nonatomic,strong)NSMutableArray <NSMutableArray *>*placeholderMutArr;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation SettingPaymentWayVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    SettingPaymentWayVC *vc = SettingPaymentWayVC.new;
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
    self.gk_navTitle = @"收款方式设置";
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.saveBtn];
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableView.mj_header beginRefreshing];
}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveBtnClickEvent:(UIButton *)sender{
    NSLog(@"保存");
    [self netWorking];
}
#pragma mark —— XDMultTableViewDatasource & XDMultTableViewDelegate
- (NSInteger)mTableView:(XDMultTableView *)mTableView
  numberOfRowsInSection:(NSInteger)section{
    return self.dataMutArr[section].count;
}

- (NSInteger)numberOfSectionsInTableView:(XDMultTableView *)mTableView{
    return self.dataMutArr.count;
}

- (XDMultTableViewCell *)mTableView:(XDMultTableView *)mTableView
              cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SettingPaymentWayTBVCell *cell = [SettingPaymentWayTBVCell cellWith:mTableView];
    [cell richElementsInCellWithModel:@[self.dataMutArr[indexPath.section][indexPath.row],
                                        self.placeholderMutArr[indexPath.section][indexPath.row],
                                        indexPath]];
    [cell actionBlock:^(id data, id data2) {//textField, self.indexPath
        UITextField *textField;
        NSIndexPath *indexPath;
        if ([data isKindOfClass:[UITextField class]]) {
            textField = (UITextField *)data;
        }
        if ([data2 isKindOfClass:[NSIndexPath class]]) {
            indexPath = data2;
            if (indexPath.section == 0 &&
                indexPath.row == 0) {//微信
                self.wechatAccStr = textField.text;
            }else if (indexPath.section == 1 &&
                      indexPath.row == 0){//支付宝
                self.aliPayAccStr = textField.text;
            }else if(indexPath.section == 2){//银行卡
                if (indexPath.row == 0) {
                    self.bankCardNameStr = textField.text;
                }else if (indexPath.row == 1){
                    self.bankAccStr = textField.text;
                }else if (indexPath.row == 2){
                    self.bankNameStr = textField.text;
                }else if (indexPath.row == 3){
                    self.branchInfoStr = textField.text;
                }else{}
            }
        }
    }];return cell;
}

-(NSString *)mTableView:(XDMultTableView *)mTableView
titleForHeaderInSection:(NSInteger)section{
    return self.headViewTitleMutArr[section];
}

- (CGFloat)mTableView:(XDMultTableView *)mTableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [SettingPaymentWayTBVCell cellHeightWithModel:nil];
}

- (CGFloat)mTableView:(XDMultTableView *)mTableView
heightForHeaderInSection:(NSInteger)section{
    return SCALING_RATIO(40);
}

- (void)mTableView:(XDMultTableView *)mTableView
willOpenHeaderAtSection:(NSInteger)section{
    NSLog(@"即将展开");
}

- (void)mTableView:(XDMultTableView *)mTableView
willCloseHeaderAtSection:(NSInteger)section{
    NSLog(@"即将关闭");
}

- (void)mTableView:(XDMultTableView *)mTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell");
}
#pragma mark —— lazyLoad
-(XDMultTableView *)tableView{
    if (!_tableView) {
        _tableView = [[XDMultTableView alloc] initWithFrame:CGRectMake(0,
                                                                       self.gk_navigationBar.mj_h,
                                                                       self.view.frame.size.width,
                                                                       self.view.frame.size.height - self.gk_navigationBar.mj_h)];
//        _tableView.openSectionArray = [NSArray arrayWithObjects:@1,@2, nil];
        _tableView.delegate = self;
        _tableView.datasource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoAdjustOpenAndClose = NO;
        [self.view addSubview:_tableView];
    }return _tableView;
}

-(UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = UIButton.new;
        [_saveBtn addTarget:self
                     action:@selector(saveBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        [_saveBtn setTitle:@"保存"
                  forState:UIControlStateNormal];
        [_saveBtn setTitleColor:kBlackColor
                       forState:UIControlStateNormal];
    }return _saveBtn;
}

-(NSMutableArray<NSMutableArray *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
        [_dataMutArr addObject:[NSMutableArray arrayWithObjects:@"微信账号", nil]];
        [_dataMutArr addObject:[NSMutableArray arrayWithObjects:@"支付宝账号", nil]];
        [_dataMutArr addObject:[NSMutableArray arrayWithObjects:@"银行卡姓名",@"银行卡账号",@"银行卡类型",@"支行信息", nil]];
    }return _dataMutArr;
}

-(NSMutableArray<NSMutableArray *> *)placeholderMutArr{
    if (!_placeholderMutArr) {
        _placeholderMutArr = NSMutableArray.array;
        [_placeholderMutArr addObject:[NSMutableArray arrayWithObjects:@"输入微信账号:", nil]];
        [_placeholderMutArr addObject:[NSMutableArray arrayWithObjects:@"输入支付宝账号:", nil]];
        [_placeholderMutArr addObject:[NSMutableArray arrayWithObjects:@"输入账户姓名:",@"输入银行卡账号:",@"输入开户行:",@"输入支行信息:", nil]];
    }return _placeholderMutArr;
}

-(NSMutableArray<NSString *> *)headViewTitleMutArr{
    if (!_headViewTitleMutArr) {
        _headViewTitleMutArr = NSMutableArray.array;
        [_headViewTitleMutArr addObject:@"微信"];
        [_headViewTitleMutArr addObject:@"支付宝"];
        [_headViewTitleMutArr addObject:@"银行卡"];
    }return _headViewTitleMutArr;
}

@end
