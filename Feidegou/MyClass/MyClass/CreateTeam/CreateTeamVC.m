//
//  CreateTeamVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/11.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "CreateTeamVC.h"
#import "CreateTeamVC+VM.h"

@interface InvitationCodeTBVCell ()
<
UITextFieldDelegate
>

@property(nonatomic,copy)DataBlock block;

@end

@interface CreateTeamVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation CreateTeamVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    CreateTeamVC *vc = CreateTeamVC.new;
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navTitle = @"创建团队";
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.sendBtn];
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    if (_titleMutArr.count > 3) {
        [_titleMutArr removeLastObject];
    }
    [self lookUserInfo];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");

}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)sendBtnClickEvent:(UIButton *)sender{
    NSLog(@"发送");
    [self.view endEditing:YES];
    //三种联系方式微信是必填的，手机号和qq号选填
    if ([NSString isNullString:self.wechatStr]) {
        Toast(@"请填写微信号码");
    }else{
        [self ChangeMyInfo];
    }
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [InvitationCodeTBVCell cellHeightWithModel:Nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.titleMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3 &&
        self.titleMutArr[3]) {
        TBVCell_style_01 *cell = (TBVCell_style_01 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
        if (!cell) {
            cell = [[TBVCell_style_01 alloc] initWithStyle:UITableViewCellStyleValue1
                                           reuseIdentifier:ReuseIdentifier
                                                    margin:SCALING_RATIO(5)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = kClearColor;
        }
        cell.textLabel.text = self.titleMutArr[3];
        return cell;
    }else{
        InvitationCodeTBVCell *cell = [InvitationCodeTBVCell cellWith:tableView];
        [self.dataMutSet addObject:cell.textField];
        [cell richElementsInCellWithModel:self.titleMutArr[indexPath.row]];
        @weakify(self);
        [cell actionBlock:^(ZYTextField *textField) {
            @strongify(self)
            if ([textField.placeholder isEqualToString:self.titleMutArr[0]]) {//请输入手机号
                self.telePhoneStr = textField.text;
            }else if ([textField.placeholder isEqualToString:self.titleMutArr[1]]){//请输入QQ账号
                self.QQStr = textField.text;
            }else if ([textField.placeholder isEqualToString:self.titleMutArr[2]]){//请输入微信账号"
                self.wechatStr = textField.text;
            }else{}
        }];return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark —— lazyLoad
-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = UIButton.new;
        [_sendBtn setTitle:@"点我发送"
                  forState:UIControlStateNormal];
        [_sendBtn setTitleColor:kWhiteColor
                       forState:UIControlStateNormal];
        [_sendBtn.titleLabel sizeToFit];
        _sendBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_sendBtn addTarget:self
                     action:@selector(sendBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
    }return _sendBtn;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.tableFooterView = UIView.new;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.mj_footer.hidden = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }return _tableView;
}

-(LoginViewController *)loginVC{
    if (!_loginVC) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardLoginAndRegister bundle:nil];
        _loginVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    }return _loginVC;
}

-(NSString *)telePhonePlaceholderStr{
    if (!_telePhonePlaceholderStr) {
        _telePhonePlaceholderStr = @"请输入手机号(选填)";
    }return _telePhonePlaceholderStr;
}

-(NSString *)QQPlaceholderStr{
    if (!_QQPlaceholderStr) {
        _QQPlaceholderStr = @"请输入QQ账号(选填)";
    }return _QQPlaceholderStr;
}

-(NSString *)wechatPlaceholderStr{
    if (!_wechatPlaceholderStr) {
        _wechatPlaceholderStr = @"请输入微信账号(必填)";
    }return _wechatPlaceholderStr;
}

-(NSString *)invitationCodeStr{
    if (!_invitationCodeStr) {
        _invitationCodeStr = @"您的邀请码是:";
    }return _invitationCodeStr;
}

-(NSMutableArray<NSString *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:self.telePhonePlaceholderStr];
        [_titleMutArr addObject:self.QQPlaceholderStr];
        [_titleMutArr addObject:self.wechatPlaceholderStr];
    }return _titleMutArr;
}

-(NSMutableSet<ZYTextField *> *)dataMutSet{
    if (!_dataMutSet) {
        _dataMutSet = NSMutableSet.set;
    }return _dataMutSet;
}

@end

@implementation InvitationCodeTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    InvitationCodeTBVCell *cell = (InvitationCodeTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[InvitationCodeTBVCell alloc] initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:ReuseIdentifier
                                                     margin:SCALING_RATIO(5)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = kRedColor;
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(50);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    if ([model isKindOfClass:[NSString class]]) {
        NSString *str = model;
        if ([str isEqualToString:@"请输入手机号(选填)"]) {
            self.textField.keyboardType = UIKeyboardTypePhonePad;
        }
    }
    self.textField.placeholder = model;
}

-(void)actionBlock:(DataBlock)block{
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
        self.block(textField);
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

-(ZYTextField *)textField{
    if (!_textField) {
        _textField = ZYTextField.new;
        _textField.delegate = self;
        [self.contentView addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
//        [self.view layoutSubviews];
//        [self.view setBorderWithView:_textField
//                          borderColor:kBlackColor
//                          borderWidth:0.5f
//                           borderType:UIBorderSideTypeBottom];

    }return _textField;
}

@end


