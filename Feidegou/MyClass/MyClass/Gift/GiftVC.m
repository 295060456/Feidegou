//
//  GiftVC.m
//  Feidegou
//
//  Created by Kite on 2019/12/2.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "GiftVC.h"
#import "GiftVC+VM.h"
#import "GiftTBViewForHeader.h"

@interface GiftTBVCell ()
<
UITextFieldDelegate
>
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)ZYTextField *textField;
@property(nonatomic,copy)DataBlock block;
@property(nonatomic,copy)NSString *btnTitleStr;
@property(nonatomic,copy)NSString *textFieldPlaceHolderStr;

@end

@interface GiftVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *sendBtn;
@property(nonatomic,strong)UIButton *cancelBtn;

@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,strong)NSMutableArray <NSString *>*placeHolderDataMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*btnTitleDataMutArr;

@end

@implementation GiftVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    GiftVC *vc = GiftVC.new;
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

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navTitle = @"赠送给他人";
    self.tableView.alpha = 1;
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cancelBtn];
    self.sendBtn.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark —— 点击事件
-(void)sendBtnClickEvent:(UIButton *)sender{
    [self.view endEditing:YES];
    NSLog(@"赠送");
    if ([NSString isNullString:self.User_phone]) {
        Toast(@"请填写用户id");
    }else if ([NSString isNullString:self.value]){
        Toast(@"请填写赠送数量");
    }else{
        [self netWorking];
    }
}

-(void)cancelBtnClickEvent:(UIButton *)sender{
    NSLog(@"取消赠送");
    [self backBtnClickEvent:sender];
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    GiftTBViewForHeader *viewForHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:ReuseIdentifier];
    if (!viewForHeader) {
        viewForHeader = [[GiftTBViewForHeader alloc]initWithReuseIdentifier:ReuseIdentifier
                                                                   withData:@"可以赠送的喵粮数量:10 g"];//
//        [viewForHeader headerViewWithModel:nil];
    }return viewForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return 0;
    return [GiftTBViewForHeader headerViewHeightWithModel:nil];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCALING_RATIO(50);
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    return;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GiftTBVCell *cell = [GiftTBVCell cellWith:tableView];
    if (self.btnTitleDataMutArr.count &&
        self.placeHolderDataMutArr.count) {
        [cell richElementsInCellWithModel:@{self.btnTitleDataMutArr[indexPath.row]:self.placeHolderDataMutArr[indexPath.row]}];
        [cell actionBlock:^(id data) {
            if ([data isKindOfClass:[UITextField class]]) {
                UITextField *tf = (UITextField *)data;
                if ([tf.placeholder isEqualToString:self.placeHolderDataMutArr[0]]) {
                    self.User_phone = tf.text;
                }else if ([tf.placeholder isEqualToString:self.placeHolderDataMutArr[1]]){
                    self.value = tf.text;
                }
            }
        }];
    }return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = UIView.new;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//推荐该方法
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }return _tableView;
}

-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = UIButton.new;
        _sendBtn.backgroundColor = AppMainThemeColor;
        [_sendBtn setTitleColor:kWhiteColor
                       forState:UIControlStateNormal];
        [UIView cornerCutToCircleWithView:_sendBtn
                          AndCornerRadius:5];
        [_sendBtn setTitle:@"赠送"
                  forState:UIControlStateNormal];
        [_sendBtn addTarget:self
                     action:@selector(sendBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_sendBtn];
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SCALING_RATIO(100),
                                             SCALING_RATIO(50)));
            make.top.equalTo(self.view).offset(300);
        }];
    }return _sendBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = UIButton.new;
        [_cancelBtn setTitle:@"取消"
                    forState:UIControlStateNormal];
        [_cancelBtn addTarget:self
                       action:@selector(cancelBtnClickEvent:)
             forControlEvents:UIControlEventTouchUpInside];
    }return _cancelBtn;
}

-(NSMutableArray<NSString *> *)placeHolderDataMutArr{
    if (!_placeHolderDataMutArr) {
        _placeHolderDataMutArr = NSMutableArray.array;
        [_placeHolderDataMutArr addObject:@"在此输入用户id"];
        [_placeHolderDataMutArr addObject:@"在此输入用户数量"];
    }return _placeHolderDataMutArr;
}

-(NSMutableArray<NSString *> *)btnTitleDataMutArr{
    if (!_btnTitleDataMutArr) {
        _btnTitleDataMutArr = NSMutableArray.array;
        [_btnTitleDataMutArr addObject:@"用户id:"];
        [_btnTitleDataMutArr addObject:@"赠送数量:"];
    }return _btnTitleDataMutArr;
}

@end

@implementation GiftTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    GiftTBVCell *cell = (GiftTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[GiftTBVCell alloc] initWithStyle:UITableViewCellStyleValue1
                                  reuseIdentifier:ReuseIdentifier
                                           margin:SCALING_RATIO(5)];
        cell.backgroundColor = kWhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [UIView cornerCutToCircleWithView:cell.contentView
//                          AndCornerRadius:5.f];
//        [UIView colourToLayerOfView:cell.contentView
//                         WithColour:KGreenColor
//                     AndBorderWidth:.1f];
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCREEN_HEIGHT / 15;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    if ([model isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)model;
        self.btnTitleStr = dic.allKeys[0];
        self.textFieldPlaceHolderStr = dic.allValues[0];
    }
}

-(void)drawRect:(CGRect)rect{
//    self.cancelBtn.alpha = 1;
//    self.giftBtn.alpha = 1;
    self.btn.alpha = 1;
    self.textField.alpha = 1;
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
#pragma mark —— lazyLoad
-(UIButton *)btn{
    if (!_btn) {
        _btn = UIButton.new;
        [_btn setTitleColor:kBlackColor
                   forState:UIControlStateNormal];
        [_btn setTitle:self.btnTitleStr
              forState:UIControlStateNormal];
        [self.contentView addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(SCALING_RATIO(10));
            make.width.mas_equalTo(SCALING_RATIO(80));
        }];
    }return _btn;
}

-(ZYTextField *)textField{
    if (!_textField) {
        _textField = ZYTextField.new;
//        [UIView cornerCutToCircleWithView:_textField
//                          AndCornerRadius:3];
//        [UIView colourToLayerOfView:_textField
//                         WithColour:KLightGrayColor
//                     AndBorderWidth:1.f];
        _textField.placeholder = self.textFieldPlaceHolderStr;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.delegate = self;
        [self.contentView addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.btn.mas_right);
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-10));
        }];
        [self.contentView layoutIfNeeded];
        [self setBorderWithView:_textField
                    borderColor:kRedColor
                    borderWidth:1.f borderType:UIBorderSideTypeBottom];
    }return _textField;
}


@end


