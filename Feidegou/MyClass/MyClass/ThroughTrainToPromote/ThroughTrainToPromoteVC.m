//
//  ThroughTrainToPromoteVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/25.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ThroughTrainToPromoteVC.h"
#import "ThroughTrainToPromoteVC+VM.h"

@interface ThroughTrainToPromoteTBVCell()
<
UITextFieldDelegate
>

@property(nonatomic,strong)ZYTextField *textField;
@property(nonatomic,copy)DataBlock block;

@end

@interface ThroughTrainToPromoteVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*detailTitleMutArr;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation ThroughTrainToPromoteVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    ThroughTrainToPromoteVC *vc = ThroughTrainToPromoteVC.new;
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
    self.gk_navTitle = @"喵粮直通车";
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.tableView.alpha = 1;
    [self showAlertViewTitle:@"开启直通车，您的宝贝将大大增加曝光度"
                     message:@""
                 btnTitleArr:@[@"好的"]
              alertBtnAction:@[@"OK"]];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_openBtn) {
        [self.openBtn removeFromSuperview];
    }
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark —— 私有方法
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    [self checkThroughTrainToPromoteStyle_netWorking];//查看直通车状态 按钮布局
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
   [self pullToRefresh];
}

-(void)OK{
    
}
#pragma mark —— 点击事件
-(void)cancelBtnClickEvent:(UIButton *)sender{
    NSLog(@"%@",sender.titleLabel.text);
    [self deleteThroughTrainToPromote_netWorking];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)backBtnClickEvent:(UIButton *)sender{
    [self deleteThroughTrainToPromote_netWorking];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)goOnBtnClickEvent:(UIButton *)sender{
    NSLog(@"%@",sender.titleLabel.text);
#warning KKK
    [self openBtnClickEvent:sender];
}

-(void)openBtnClickEvent:(UIButton *)sender{
    NSLog(@"开启直通车抢摊位")
    [self.view endEditing:YES];
    if (![NSString isNullString:self.quantity]) {
        [self check];//先查看机会、再开通直通车
    }else{
        Toast(@"请输入您的数量");
    }
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ThroughTrainToPromoteTBVCell cellHeightWithModel:nil];
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
    if (indexPath.row == 1) {
        ThroughTrainToPromoteTBVCell *cell = [ThroughTrainToPromoteTBVCell cellWith:tableView];
        cell.textLabel.text = self.titleMutArr[indexPath.row];
        cell.detailTextLabel.text = self.detailTitleMutArr[indexPath.row];
        [cell richElementsInCellWithModel:self.quantity];
        @weakify(self)
        [cell actionBlock:^(id data) {
            @strongify(self)
            if ([data isKindOfClass:[NSString class]]) {
                self.quantity = data;
            }
        }];return cell;
    }else{
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:ReuseIdentifier];
            cell.backgroundColor = kClearColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = self.titleMutArr[indexPath.row];
            cell.detailTextLabel.text = self.detailTitleMutArr[indexPath.row];
        }return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark —— lazyLoad
-(UIButton *)openBtn{
    if (!_openBtn) {
        _openBtn = UIButton.new;
        _openBtn.uxy_acceptEventInterval = btnActionTime;
        [_openBtn addTarget:self
                 action:@selector(openBtnClickEvent:)
       forControlEvents:UIControlEventTouchUpInside];
        [_openBtn setTitle:@"开启直通车抢摊位"
              forState:UIControlStateNormal];
        _openBtn.backgroundColor = kOrangeColor;
        [self.view addSubview:_openBtn];
        [_openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SCALING_RATIO(100),
                                             SCALING_RATIO(50)));
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.tableView).offset((self.titleMutArr.count + 1) * [ThroughTrainToPromoteTBVCell cellHeightWithModel:nil]);
        }];
        [self.view layoutIfNeeded];
        [UIView cornerCutToCircleWithView:_openBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_openBtn
                         WithColour:KLightGrayColor
                     AndBorderWidth:1.f];
    }return _openBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = UIButton.new;
        _cancelBtn.uxy_acceptEventInterval = btnActionTime;
        [_cancelBtn setTitle:@"取消上一次直通车"
                    forState:UIControlStateNormal];
        if (@available(iOS 8.2, *)) {
            _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:1];
        } else {
            _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        }
        [_cancelBtn addTarget:self
                       action:@selector(cancelBtnClickEvent:)
             forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.backgroundColor = KLightGrayColor;
        [self.view addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView).offset((self.titleMutArr.count + 1) * [ThroughTrainToPromoteTBVCell cellHeightWithModel:nil]);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2 - SCALING_RATIO(50),
                                             SCALING_RATIO(50)));
            make.left.equalTo(self.view).offset(SCALING_RATIO(30));
        }];
        [self.view layoutIfNeeded];
        [UIView cornerCutToCircleWithView:_cancelBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_cancelBtn
                         WithColour:KLightGrayColor
                     AndBorderWidth:1.f];
    }return _cancelBtn;
}

-(UIButton *)goOnBtn{
    if (!_goOnBtn) {
        _goOnBtn = UIButton.new;
        _goOnBtn.uxy_acceptEventInterval = btnActionTime;
        [_goOnBtn setTitle:@"继续上一次直通车"
                  forState:UIControlStateNormal];
        if (@available(iOS 8.2, *)) {
            _goOnBtn.titleLabel.font = [UIFont systemFontOfSize:13 weight:1];
        } else {
            _goOnBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        }
        _goOnBtn.backgroundColor = kRedColor;
        [_goOnBtn addTarget:self
                     action:@selector(goOnBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_goOnBtn];
        [_goOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView).offset((self.titleMutArr.count + 1) * [ThroughTrainToPromoteTBVCell cellHeightWithModel:nil]);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH  / 2 - SCALING_RATIO(50),
                                             SCALING_RATIO(50)));
            make.right.equalTo(self.view).offset(-SCALING_RATIO(30));
        }];
        [self.view layoutIfNeeded];
        [UIView cornerCutToCircleWithView:_goOnBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_goOnBtn
                         WithColour:KLightGrayColor
                     AndBorderWidth:1.f];
    }return _goOnBtn;
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

-(NSMutableArray<NSString *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:@"商品"];
        [_titleMutArr addObject:@"参与直通车的数量"];
        [_titleMutArr addObject:@"市场价"];
    }return _titleMutArr;
}

-(NSMutableArray<NSString *> *)detailTitleMutArr{
    if (!_detailTitleMutArr) {
        _detailTitleMutArr = NSMutableArray.array;
        [_detailTitleMutArr addObject:@"喵粮"];
        [_detailTitleMutArr addObject:@"g"];
        [_detailTitleMutArr addObject:@"1g / CNY"];
    }return _detailTitleMutArr;
}

@end

@implementation ThroughTrainToPromoteTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    ThroughTrainToPromoteTBVCell *cell = (ThroughTrainToPromoteTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[ThroughTrainToPromoteTBVCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:ReuseIdentifier
                                                            margin:SCALING_RATIO(0)];
        cell.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(50);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    [self layoutIfNeeded];//在cell里面，用[self layoutIfNeeded]刷新立即得到textLabel等的frame值
    self.dataStr = model;
    self.textField.text = self.dataStr;
}

-(void)drawRect:(CGRect)rect{
    [self setBorderWithView:_textField
                            borderColor:kRedColor
                            borderWidth:1.f
                             borderType:UIBorderSideTypeBottom];
}

-(void)actionBlock:(DataBlock)block{
    _block = block;
}
#pragma mark —— UITextFieldDelegate
//询问委托人是否应该在指定的文本字段中开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return [NSString isNullString:self.dataStr];
}
//告诉委托人在指定的文本字段中开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}
//询问委托人是否应在指定的文本字段中停止编辑
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
//告诉委托人对指定的文本字段停止编辑
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.block) {
        self.block(textField.text);
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
-(ZYTextField *)textField{
    if (!_textField) {
        _textField = ZYTextField.new;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.placeholder = @"在此输入数量";
        _textField.delegate = self;
        [self.contentView addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.detailTextLabel.mas_left).offset(SCALING_RATIO(-10));
            make.left.equalTo(self.textLabel.mas_right).offset(SCALING_RATIO(30));
            make.top.bottom.equalTo(self.contentView);
        }];
        [self layoutIfNeeded];
    }return _textField;
}

@end
