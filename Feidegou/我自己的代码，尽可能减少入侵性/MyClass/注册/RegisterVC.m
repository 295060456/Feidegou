//
//  RegisterVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/22.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "RegisterVC.h"
#import "RegisterVC+VM.h"

@interface RegisterTBVCell ()<UITextFieldDelegate>

@property(nonatomic,strong)VerifyCodeButton *gettingAuthCode;
@property(nonatomic,strong)UITextField *textField;

@property(nonatomic,assign)__block int time;
@property(nonatomic,copy)DataBlock block;


@end

@interface RegisterVC ()
<
UITableViewDelegate,
UITableViewDataSource,
BEMCheckBoxDelegate
>

@property(nonatomic,strong)BEMCheckBox *checkBox;
@property(nonatomic,strong)UIButton *nextBtn;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *titleLab;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation RegisterVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    RegisterVC *vc = RegisterVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    switch (comingStyle) {
        case ComingStyle_PUSH:{
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
    self.gk_navTitle = @"注册";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.tableView.alpha = 1;
    self.checkBox.alpha = 1;
    self.titleLab.alpha = 1;
    self.nextBtn.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [RegisterTBVCell cellHeightWithModel:nil];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RegisterTBVCell *cell = [RegisterTBVCell cellWith:tableView];
    [cell richElementsInCellWithModel:indexPath];
    @weakify(self)
    [cell actionBlock:^(id data) {
        @strongify(self)
        if ([data isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)data;
            [self authCode:textField.text];
        }
    }];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark —— BEMCheckBoxDelegate
- (void)didTapCheckBox:(BEMCheckBox *)checkBox{
    NSLog(@"");
    self.nextBtn.enabled = checkBox.on;
    if (checkBox.on) {
        _nextBtn.backgroundColor = kRedColor;
    }else{
        _nextBtn.backgroundColor = KLightGrayColor;
    }
}

- (void)animationDidStopForCheckBox:(BEMCheckBox *)checkBox{
    
}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)nextBtnClickEvent:(UIButton *)sender{
    
}
#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
        _tableView.mj_footer.hidden = YES;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
            make.height.mas_equalTo([RegisterTBVCell cellHeightWithModel:nil] * 2 + 44);
        }];
    }return _tableView;
}

-(BEMCheckBox *)checkBox{
    if (!_checkBox) {
        _checkBox = BEMCheckBox.new;
        // 矩形复选框
        _checkBox.boxType = BEMBoxTypeSquare;
        _checkBox.delegate = self;
        // 动画样式
        _checkBox.onAnimationType  = BEMAnimationTypeStroke;
        _checkBox.offAnimationType = BEMAnimationTypeStroke;
        _checkBox.animationDuration = 0.3;
        // 颜色样式
        _checkBox.tintColor    = kWhiteColor;
        _checkBox.onTintColor  = HEXCOLOR(0x108EE9);
        _checkBox.onFillColor  = kClearColor;
        _checkBox.onCheckColor = HEXCOLOR(0x108EE9);
        [self.view addSubview:_checkBox];
        [_checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(SCALING_RATIO(20));
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.top.equalTo(self.tableView.mas_bottom).offset(SCALING_RATIO(0));
        }];
    }return _checkBox;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
        _titleLab.text = @"我同意用户协议";
        [_titleLab sizeToFit];
        [self.view addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.checkBox.mas_right).offset(SCALING_RATIO(10));
            make.top.bottom.equalTo(self.checkBox);
        }];
    }return _titleLab;
}

-(UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = UIButton.new;
        _nextBtn.backgroundColor = KLightGrayColor;
        [UIView cornerCutToCircleWithView:_nextBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_nextBtn
                         WithColour:kWhiteColor
                     AndBorderWidth:.5f];
        [_nextBtn setTitle:@"下一步"
                  forState:UIControlStateNormal];
        [_nextBtn addTarget:self
                     action:@selector(nextBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nextBtn];
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SCALING_RATIO(100), SCALING_RATIO(80)));
            make.top.equalTo(self.titleLab.mas_bottom).offset(SCALING_RATIO(30));
        }];
    }return _nextBtn;
}

@end

@implementation RegisterTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    RegisterTBVCell *cell = (RegisterTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[RegisterTBVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:ReuseIdentifier
                                                margin:SCALING_RATIO(5)];
        [UIView cornerCutToCircleWithView:cell.contentView
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:cell.contentView
                         WithColour:KGreenColor
                     AndBorderWidth:.1f];
    }return cell;
}

-(void)drawRect:(CGRect)rect{
    self.textField.alpha = 1;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCREEN_HEIGHT / 15;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    if ([model isKindOfClass:[NSIndexPath class]]) {
        NSIndexPath *indexPath = (NSIndexPath *)model;
        if (indexPath.row == 0) {
            self.imageView.image = kIMG(@"手机号");
            self.textField.placeholder = @"请输入您的手机号";
            self.gettingAuthCode.alpha = 1;
        }else if (indexPath.row == 1){
            self.imageView.image = kIMG(@"验证码");
            self.textField.placeholder = @"请输入验证码";
        }else{}
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

-(void)actionBlock:(DataBlock)block{
    self.block = block;
}

#pragma mark —— 点击事件
-(void)gettingAuthCodeClickEvent:(UIButton *)sender{
    [self endEditing:YES];
    [self.gettingAuthCode timeFailBeginFrom:30];
    if (self.block) {
        self.block(self.textField);
    }
}
#pragma mark —— lazyLoad
-(UITextField *)textField{
    if (!_textField) {
        _textField = UITextField.new;
        _textField.keyboardType = UIKeyboardTypePhonePad;
        _textField.delegate = self;
        [self.contentView addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.imageView.mas_right);
            if (_gettingAuthCode) {
                make.right.equalTo(self.gettingAuthCode.mas_left);
            }else{
                make.right.equalTo(self.contentView);
            }
        }];
    }return _textField;
}

-(VerifyCodeButton *)gettingAuthCode{
    if (!_gettingAuthCode) {
        _gettingAuthCode = VerifyCodeButton.new;
        _gettingAuthCode.showTimeType = ShowTimeType_SS;;
        _gettingAuthCode.layerCornerRadius = 5.f;
        if (@available(iOS 8.2, *)) {
            _gettingAuthCode.titleLabelFont = [UIFont systemFontOfSize:20.f weight:1];
        } else {
            // Fallback on earlier versions
        }
        _gettingAuthCode.clipsToBounds = YES;
        _gettingAuthCode.bgBeginColor = kRedColor;
        _gettingAuthCode.bgEndColor = kRedColor;
        _gettingAuthCode.titleBeginStr = @"获取验证码";
        _gettingAuthCode.titleEndStr = @"重新获取";
        [_gettingAuthCode addTarget:self
                             action:@selector(gettingAuthCodeClickEvent:)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_gettingAuthCode];
        [_gettingAuthCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(SCALING_RATIO(-5));
            make.top.equalTo(self.contentView).offset(SCALING_RATIO(5));
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-10));
        }];
        [self layoutIfNeeded];
    }return _gettingAuthCode;
}



@end




