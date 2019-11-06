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
@property(nonatomic,copy)ThreeDataBlock block2;

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
//        [UIView cornerCutToCircleWithView:cell.contentView
//                          AndCornerRadius:5.f];
//        [UIView colourToLayerOfView:cell.contentView
//                         WithColour:KGreenColor
//                     AndBorderWidth:.1f];
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(50);
}

- (void)richElementsInCellWithModel:(id _Nullable)model
            ReleaseOrderTBVCellType:(ReleaseOrderTBVCellType)type{
    [self.textLabel sizeToFit];
    switch (type) {
        case ReleaseOrderTBVCellType_Textfield:{
            self.detailTextLabel.text = @"g";
            self.textfield.placeholder = model;
            [self layoutIfNeeded];
            if ([model isEqualToString:@"请输入数量"]) {
                [_textfield mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.equalTo(self.contentView);
                    make.left.equalTo(self.textLabel.mas_right).offset(SCALING_RATIO(40));
                    make.right.equalTo(self.detailTextLabel.mas_left).offset(SCALING_RATIO(-10));
                }];
            }else{}
        }break;
        case ReleaseOrderTBVCellType_Lab:{
            self.detailTextLabel.text = model;
        }break;
        case ReleaseOrderTBVCellType_Btn:{
            NSMutableArray <UILabel *>*labMutArr = NSMutableArray.array;
            for (int i = 0; i < self.listTitleDataMutArr.count ; i++) {//
                BEMCheckBox *checkBox = BEMCheckBox.new;
                UILabel *titleLab = UILabel.new;
                titleLab.text = self.listTitleDataMutArr[i];
//                titleLab.backgroundColor = RandomColor;
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
                
                [self.contentView addSubview:checkBox];
                [self.contentView addSubview:titleLab];

                if (self.btnMutArr.count == 0) {
                    checkBox.frame = CGRectMake(SCALING_RATIO(100),
                                                SCALING_RATIO(10),
                                                SCALING_RATIO(20),
                                                SCALING_RATIO(20));
                }else if (self.btnMutArr.count == 1) {
                    checkBox.frame = CGRectMake(SCALING_RATIO(170),
                                                SCALING_RATIO(10),
                                                SCALING_RATIO(20),
                                                SCALING_RATIO(20));
                }else if (self.btnMutArr.count == 2) {
                    checkBox.frame = CGRectMake(SCALING_RATIO(240),
                                                SCALING_RATIO(10),
                                                SCALING_RATIO(20),
                                                SCALING_RATIO(20));
                }
                [self.btnMutArr addObject:checkBox];//
                [labMutArr addObject:titleLab];//!!
                titleLab.frame = CGRectMake(checkBox.mj_x + checkBox.mj_w,
                                            checkBox.mj_y,
                                            SCALING_RATIO(50),
                                            SCALING_RATIO(20));
            }
        }break;
        case ReleaseOrderTBVCellType_TextfieldOnly:{
            self.textfield.placeholder = model;
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

-(void)dataBlock:(DataBlock)block{
    _dataBlock = block;
}
#pragma mark —— 点击事件

#pragma mark —— BEMCheckBoxDelegate
- (void)didTapCheckBox:(BEMCheckBox *)checkBox {
    NSLog(@"%@", self.listTitleDataMutArr[checkBox.tag]);
    checkBox.selected = !checkBox.selected;
    switch (checkBox.tag) {
        case 1:{
            
        }break;
        case 2:{
            
        }break;
        case 3:{
            
        }break;
            
        default:
            break;
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
        _textfield.backgroundColor = KLightGrayColor;
        _textfield.delegate = self;
        [self.contentView addSubview:_textfield];
        [_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.textLabel.mas_right).offset(SCALING_RATIO(10));
            make.right.equalTo(self.detailTextLabel.mas_left).offset(SCALING_RATIO(-10));
        }];
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

@end

@interface ReleaseOrderVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)BaseTableViewer *tableView;
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
    [self.tableView.mj_header endRefreshing];
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
    self.tableView.alpha = 1;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.releaseBtn.alpha = 1;
    [self.releaseBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.gk_navigationBar.mj_h +
                                           (self.titleMutArr.count - 2) * SCALING_RATIO(50) +
                                           SCALING_RATIO(40) +
                                           SCALING_RATIO(50));//附加值
    }];
}
#pragma mark —— 点击事件
-(void)releaseBtnClickEvent:(UIButton *)sender{
    NSLog(@"发布");
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
        [cell richElementsInCellWithModel:self.placeholderMutArr[indexPath.row]
                  ReleaseOrderTBVCellType:ReleaseOrderTBVCellType_Textfield];
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
                }
                
//                else if([textfield.placeholder isEqualToString:@""]){//请输入最高限额
//                    self.str_3 = textfield.text;
//                }
                
                
                
                else{}
            }     
        }];
        
    }else if(indexPath.row == 3){//单价
        [cell richElementsInCellWithModel:self.placeholderMutArr[indexPath.row]
                  ReleaseOrderTBVCellType:ReleaseOrderTBVCellType_Lab];
    }else if (indexPath.row == 4){//收款方式
        [cell richElementsInCellWithModel:self.placeholderMutArr[indexPath.row]
                  ReleaseOrderTBVCellType:ReleaseOrderTBVCellType_Btn];

    }else if(indexPath.row == 5){//
        [cell richElementsInCellWithModel:self.placeholderMutArr[indexPath.row]
                  ReleaseOrderTBVCellType:ReleaseOrderTBVCellType_TextfieldOnly];
    }else{//
        [cell richElementsInCellWithModel:self.placeholderMutArr[indexPath.row]
                  ReleaseOrderTBVCellType:ReleaseOrderTBVCellType_TextfieldOnly];
    }
    return cell;
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
        [_releaseBtn setTitle:@"发布"
                     forState:UIControlStateNormal];
        [_releaseBtn addTarget:self
                        action:@selector(releaseBtnClickEvent:)
              forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_releaseBtn];
        [_releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SCALING_RATIO(100), SCALING_RATIO(100)));
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



