//
//  GiftVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/22.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "GiftVC.h"
#import "GiftVC+VM.h"

#pragma mark —— GiftTBVCell
//输入用户🆔 & 手机号码
@interface GiftTBVCell_01 ()
<
UITextFieldDelegate
>

@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)ZYTextField *textField;
@property(nonatomic,copy)DataBlock block;

@property(nonatomic,strong)NSMutableArray <NSString *>*mutArr;

@end

@implementation GiftTBVCell_01

+(instancetype)cellWith:(UITableView *)tableView{
    GiftTBVCell_01 *cell = (GiftTBVCell_01 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[GiftTBVCell_01 alloc] initWithStyle:UITableViewCellStyleValue1
                                     reuseIdentifier:ReuseIdentifier
                                              margin:SCALING_RATIO(5)];
        cell.backgroundColor = kClearColor;
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

}

-(void)actionBlock:(DataBlock)block{
    _block = block;
}

-(void)drawRect:(CGRect)rect{
    self.btn.alpha = 1;
    self.textField.alpha = 1;
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
#pragma mark —— 点击事件
-(void)btnClickEvent:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.textField.placeholder = [NSString stringWithFormat:@"在此输入%@",self.mutArr[1]];
    }else{
        self.textField.placeholder = [NSString stringWithFormat:@"在此输入%@",self.mutArr[0]];
    }
}

#pragma mark —— lazyLoad
-(UIButton *)btn{
    if (!_btn) {
        _btn = UIButton.new;
        [UIView colourToLayerOfView:_btn
                         WithColour:KLightGrayColor
                     AndBorderWidth:0.5f];
        [UIView cornerCutToCircleWithView:_btn
                          AndCornerRadius:3.f];
        [_btn setTitleColor:KLightGrayColor
                   forState:UIControlStateNormal];
        [_btn sizeToFit];
        _btn.titleLabel.adjustsFontSizeToFitWidth = YES;
//        [_btn addTarget:self
//                 action:@selector(btnClickEvent:)
//       forControlEvents:UIControlEventTouchUpInside];
        [UIView cornerCutToCircleWithView:_btn
                          AndCornerRadius:3];
        [UIView colourToLayerOfView:_btn
                         WithColour:KLightGrayColor
                     AndBorderWidth:0.01f];
        [_btn setTitle:self.mutArr[0]
              forState:UIControlStateNormal];
        [_btn setTitle:self.mutArr[1]
              forState:UIControlStateSelected];
        [self.contentView addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(SCALING_RATIO(5));
        }];
    }return _btn;
}

-(ZYTextField *)textField{
    if (!_textField) {
        _textField = ZYTextField.new;
        _textField.delegate = self;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
//        [UIView colourToLayerOfView:_textField
//                         WithColour:KLightGrayColor
//                     AndBorderWidth:1.f];
//        [UIView cornerCutToCircleWithView:_textField
//                          AndCornerRadius:3.f];
        _textField.placeholder = [NSString stringWithFormat:@"在此输入%@",self.mutArr[0]];
        [self.contentView addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(SCALING_RATIO(-5));
            make.left.equalTo(self.btn.mas_right).offset(SCALING_RATIO(5));
            make.top.bottom.equalTo(self.btn);
        }];
        [self.contentView layoutIfNeeded];
        [self setBorderWithView:_textField
                    borderColor:kRedColor
                    borderWidth:1.f
                     borderType:UIBorderSideTypeBottom];
    }return _textField;
}

-(NSMutableArray<NSString *> *)mutArr{
    if (!_mutArr) {
        _mutArr = NSMutableArray.array;
        [_mutArr addObject:@"用户id"];
        [_mutArr addObject:@"手机号码"];
    }return _mutArr;
}

@end

@interface GiftTBVCell_02 ()
<
UITextFieldDelegate
>

@property(nonatomic,strong)ZYTextField *textField;
@property(nonatomic,copy)DataBlock block;

@end

@implementation GiftTBVCell_02

+(instancetype)cellWith:(UITableView *)tableView{
    GiftTBVCell_02 *cell = (GiftTBVCell_02 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[GiftTBVCell_02 alloc] initWithStyle:UITableViewCellStyleValue1
                                     reuseIdentifier:ReuseIdentifier
                                              margin:SCALING_RATIO(5)];
        cell.backgroundColor = kClearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [UIView cornerCutToCircleWithView:cell.contentView
//                          AndCornerRadius:5.f];
//        [UIView colourToLayerOfView:cell.contentView
//                         WithColour:KGreenColor
//                     AndBorderWidth:.1f];
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCREEN_HEIGHT / 18;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
   
}

-(void)actionBlock:(DataBlock)block{
    _block = block;
}

-(void)drawRect:(CGRect)rect{
     self.textField.alpha = 1;
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
//        [UIView cornerCutToCircleWithView:_textField
//                          AndCornerRadius:3];
//        [UIView colourToLayerOfView:_textField
//                         WithColour:KLightGrayColor
//                     AndBorderWidth:1.f];
        _textField.placeholder = @"赠送数量";
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        _textField.delegate = self;
        [self.contentView addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.contentView layoutIfNeeded];
        [self setBorderWithView:_textField
                    borderColor:kRedColor
                    borderWidth:1.f borderType:UIBorderSideTypeBottom];
    }return _textField;
}

@end

@interface GiftTBVCell_03 ()

@property(nonatomic,strong)UILabel *lab;

@end

@implementation GiftTBVCell_03

+(instancetype)cellWith:(UITableView *)tableView{
    GiftTBVCell_03 *cell = (GiftTBVCell_03 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[GiftTBVCell_03 alloc] initWithStyle:UITableViewCellStyleValue1
                                     reuseIdentifier:ReuseIdentifier
                                              margin:SCALING_RATIO(5)];
        cell.backgroundColor = kClearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [UIView cornerCutToCircleWithView:cell.contentView
//                          AndCornerRadius:5.f];
//        [UIView colourToLayerOfView:cell.contentView
//                         WithColour:KGreenColor
//                     AndBorderWidth:.1f];
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCREEN_HEIGHT / 10;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.lab.alpha = 1;
}

-(void)drawRect:(CGRect)rect{
    self.lab.alpha = 1;
}
#pragma mark —— lazyLoad
-(UILabel *)lab{
    if (!_lab) {
        _lab = UILabel.new;
        extern NSString *Foodstuff;
        _lab.text = [NSString stringWithFormat:@"可以赠送的喵粮数量:%@",Foodstuff];
        [self.contentView addSubview:_lab];
        [_lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }return _lab;
}

@end

@interface GiftTBVCell_04 ()

@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIButton *giftBtn;
@property(nonatomic,copy)DataBlock block;

@end

@implementation GiftTBVCell_04

+(instancetype)cellWith:(UITableView *)tableView{
    GiftTBVCell_04 *cell = (GiftTBVCell_04 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[GiftTBVCell_04 alloc] initWithStyle:UITableViewCellStyleValue1
                                     reuseIdentifier:ReuseIdentifier
                                              margin:SCALING_RATIO(5)];
        cell.backgroundColor = kClearColor;
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

}

-(void)drawRect:(CGRect)rect{
    self.cancelBtn.alpha = 1;
    self.giftBtn.alpha = 1;
}

-(void)actionBlock:(DataBlock)block{
    _block = block;
}

-(void)cancelBtnClickEvent:(UIButton *)sender{
    NSLog(@"取消");
    if (self.block) {
        self.block(sender);
    }
}

-(void)giftBtnclickEvent:(UIButton *)sender{
    NSLog(@"赠送");
    if (self.block) {
        self.block(sender);
    }
}

#pragma mark —— lazyLaod
-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = UIButton.new;
        _cancelBtn.uxy_acceptEventInterval = 0.5f;
        [_cancelBtn setTitle:@"取消"
                    forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = KLightGrayColor;
        [_cancelBtn setTitleColor:kOrangeColor
                         forState:UIControlStateNormal];
        [_cancelBtn addTarget:self
                       action:@selector(cancelBtnClickEvent:)
             forControlEvents:UIControlEventTouchUpInside];
        [UIView cornerCutToCircleWithView:_cancelBtn
                          AndCornerRadius:5];
        [UIView colourToLayerOfView:_cancelBtn
                         WithColour:KLightGrayColor
                     AndBorderWidth:1.f];
        [self.contentView addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(SCALING_RATIO(20));
            make.width.mas_equalTo(self.contentView.mj_w / 2 - SCALING_RATIO(80));
        }];
    }return _cancelBtn;
}

-(UIButton *)giftBtn{
    if (!_giftBtn) {
        _giftBtn = UIButton.new;
        _giftBtn.uxy_acceptEventInterval = 0.5f;
        [_giftBtn setTitle:@"赠送"
                  forState:UIControlStateNormal];
        [_giftBtn addTarget:self
                     action:@selector(giftBtnclickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        [_giftBtn setTitleColor:kRedColor
                       forState:UIControlStateNormal];
        [UIView cornerCutToCircleWithView:_giftBtn
                          AndCornerRadius:5];
        [UIView colourToLayerOfView:_giftBtn
                         WithColour:kWhiteColor
                     AndBorderWidth:0.01f];
        _giftBtn.backgroundColor = kOrangeColor;
        [self.contentView addSubview:_giftBtn];
        [_giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-20));
            make.width.mas_equalTo(self.contentView.mj_w / 2 - SCALING_RATIO(80));
        }];
    }return _giftBtn;
}

@end

#pragma mark —— GiftVC
@interface GiftVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation GiftVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated{
    
    GiftVC *vc = GiftVC.new;
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

-(void)viewDidLoad{
    [super viewDidLoad];
    self.gk_navTitle = @"赠送给他人";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.alpha = 1;
}

#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            return [GiftTBVCell_01 cellHeightWithModel:Nil];
        } break;
        case 1:{
            return [GiftTBVCell_02 cellHeightWithModel:Nil];
        } break;
        case 2:{
            return [GiftTBVCell_03 cellHeightWithModel:Nil];
        } break;
        case 3:{
            return [GiftTBVCell_04 cellHeightWithModel:Nil];
        } break;
        default:
            return 0.0f;
            break;
    }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    return;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            GiftTBVCell_01 *cell = [GiftTBVCell_01 cellWith:tableView];
            [cell richElementsInCellWithModel:nil];
            @weakify(self)
            [cell actionBlock:^(id data) {
                @strongify(self)
                if ([data isKindOfClass:[NSString class]]) {
                    self.User_phone = data;
                }
            }];
            return cell;
        }break;
        case 1:{
            GiftTBVCell_02 *cell = [GiftTBVCell_02 cellWith:tableView];
            [cell richElementsInCellWithModel:nil];
            @weakify(self)
            [cell actionBlock:^(id data) {
                 @strongify(self)
                if ([data isKindOfClass:[NSString class]]) {
                    self.value = data;
                }
            }];
            return cell;
        }break;
        case 2:{
            GiftTBVCell_03 *cell = [GiftTBVCell_03 cellWith:tableView];
            [cell richElementsInCellWithModel:nil];
            return cell;
        }break;
        case 3:{
            GiftTBVCell_04 *cell = [GiftTBVCell_04 cellWith:tableView];
            [cell richElementsInCellWithModel:nil];
            @weakify(self)
            [cell actionBlock:^(id data) {
                @strongify(self)
                if ([data isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)data;
                    if ([btn.titleLabel.text isEqualToString:@"取消"]) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else if ([btn.titleLabel.text isEqualToString:@"赠送"]){
                        [self netWorking];//
                    }
                }
            }];
            return cell;
        }break;
        default:
            return UITableViewCell.new;
            break;
    }
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


@end
