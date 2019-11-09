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
        [self.contentView layoutIfNeeded];
        [UIView cornerCutToCircleWithView:_textField
                          AndCornerRadius:3.f];
        [UIView colourToLayerOfView:_textField
                         WithColour:kOrangeColor
                     AndBorderWidth:1.f];
    }return _textField;
}

@end

@interface ThroughTrainToPromoteVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *btn;
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

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated{
    ThroughTrainToPromoteVC *vc = ThroughTrainToPromoteVC.new;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navTitle = @"喵粮直通车";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.tableView.alpha = 1;
    self.btn.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnClickEvent:(UIButton *)sender{
    NSLog(@"开启直通车抢摊位")
    [self.view endEditing:YES];
    @weakify(self)
    if (![NSString isNullString:self.quantity]) {
        [StallListVC pushFromVC:self_weak_
                  requestParams:self.quantity
                        success:^(id data) {}
                        animated:YES];
    }else{
        Toast(@"请输入您要抢摊位的数量");
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
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        ThroughTrainToPromoteTBVCell *cell = [ThroughTrainToPromoteTBVCell cellWith:tableView];
        [cell richElementsInCellWithModel:nil];
        cell.textLabel.text = self.titleMutArr[indexPath.row];
        cell.detailTextLabel.text = self.detailTitleMutArr[indexPath.row];
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
-(UIButton *)btn{
    if (!_btn) {
        _btn = UIButton.new;
        [_btn addTarget:self
                 action:@selector(btnClickEvent:)
       forControlEvents:UIControlEventTouchUpInside];
        [_btn setTitle:@"开启直通车抢摊位"
              forState:UIControlStateNormal];
        _btn.backgroundColor = kOrangeColor;
        [self.view addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SCALING_RATIO(100), SCALING_RATIO(100)));
            make.center.equalTo(self.view);
        }];
        [self.view layoutIfNeeded];
        [UIView cornerCutToCircleWithView:_btn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_btn
                         WithColour:KLightGrayColor
                     AndBorderWidth:1.f];
    }return _btn;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.tableFooterView = UIView.new;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
        [_titleMutArr addObject:@"参与抢摊位的数量"];
        [_titleMutArr addObject:@"市场价"];
    }return _titleMutArr;
}

-(NSMutableArray<NSString *> *)detailTitleMutArr{
    if (!_detailTitleMutArr) {
        _detailTitleMutArr = NSMutableArray.array;
        [_detailTitleMutArr addObject:@"喵粮"];
        [_detailTitleMutArr addObject:@"g"];
        [_detailTitleMutArr addObject:@"1g/元"];
    }return _detailTitleMutArr;
}

@end
