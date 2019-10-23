//
//  OrderListVC.m
//  My_BaseProj
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 Corp. All rights reserved.
//

#import "OrderListVC.h"
#import "OrderTBVCell.h"
#import "OrderDetailVC.h"

@interface SearchView ()
<
UITextFieldDelegate,
UIScrollViewDelegate
>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)MMButton *defaultBtn;
@property(nonatomic,strong)MMButton *timeBtn;//按时间
@property(nonatomic,strong)MMButton *typeBtn;//按类型（目前进行中(挂牌出售中)、已经取消的）
@property(nonatomic,strong)MMButton *tradeTypeBtn;//交易类型(买/卖)
@property(nonatomic,strong)UITextField *textfield;

@property(nonatomic,strong)NSMutableArray <UIView *>*viewMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*btnTitleMutArr;

@end

@implementation SearchView

- (instancetype)init{
    if (self = [super init]) {
        
    }return self;
}

- (void)drawRect:(CGRect)rect{
    [self layoutIfNeeded];
    [self createView];
}

-(void)createView{
    CGFloat offset = 0.f;
    //先赋值
    for (int i = 0; i < self.viewMutArr.count; i++) {
//        self.viewMutArr[i].backgroundColor = RandomColor;//
        id v = self.viewMutArr[i];
        if ([v isMemberOfClass:[MMButton class]]) {
            MMButton *btn = (MMButton *)v;
            [btn setTitle:self.btnTitleMutArr[i]
                 forState:UIControlStateNormal];
        }else if ([v isMemberOfClass:[UITextField class]]){
            UITextField *t = (UITextField *)v;
            t.placeholder = self.btnTitleMutArr[i];
        }
        [self layoutIfNeeded];
        offset = self.mj_w - self.textfield.mj_w - self.viewMutArr[i].mj_w;
    }
    self.scrollView.alpha = 1;
    offset = offset / self.viewMutArr.count;
    //撑开后再约束
    for (int i = 0; i < self.viewMutArr.count - 1; i++) {
        MMButton *v = (MMButton *)self.viewMutArr[i];
        if (i == 0) {
            NSLog(@"11");
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.scrollView);
                make.left.equalTo(self.scrollView).offset(offset / 2);
            }];
        }else{
            [v mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.scrollView);
                make.left.equalTo(self.viewMutArr[i - 1].mas_right).offset(offset);
            }];
        }
    }
    [self layoutIfNeeded];
    NSLog(@"");
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

#pragma mark —— 点击事件
-(void)defaultBtnClickEvent:(UIButton *)sender{
    NSLog(@"默认");
}

-(void)timeBtnClickEvent:(UIButton *)sender{
    NSLog(@"时间");
}

-(void)typeBtnClickEvent:(UIButton *)sender{
    NSLog(@"买卖");
}

-(void)tradeTypeBtnClickEvent:(UIButton *)sender{
    NSLog(@"交易状态");
}

#pragma mark —— lazyLoad
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = UIScrollView.new;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH + SCALING_RATIO(50), self.mj_h);
//        _scrollView.backgroundColor = KYellowColor;
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.right.equalTo(self.textfield.mas_left).offset(SCALING_RATIO(-10));
        }];
    }return _scrollView;
}

-(MMButton *)defaultBtn{
    if (!_defaultBtn) {
        _defaultBtn = MMButton.new;
        [_defaultBtn addTarget:self
                        action:@selector(defaultBtnClickEvent:)
              forControlEvents:UIControlEventTouchUpInside];
        [_defaultBtn setImage:kIMG(@"双向箭头_2")
                     forState:UIControlStateNormal];
        [_defaultBtn setTitleColor:kBlackColor
                          forState:UIControlStateNormal];
        [UIView cornerCutToCircleWithView:_defaultBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_defaultBtn
                         WithColour:kBlackColor
                     AndBorderWidth:0.1f];
        _defaultBtn.imageAlignment = MMImageAlignmentRight;
        _defaultBtn.spaceBetweenTitleAndImage = SCALING_RATIO(2);
        [_defaultBtn.titleLabel sizeToFit];
        _defaultBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.scrollView addSubview:_defaultBtn];
    }return _defaultBtn;
}

-(MMButton *)timeBtn{
    if (!_timeBtn) {
        _timeBtn = MMButton.new;
        [_timeBtn addTarget:self
                     action:@selector(timeBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        [_timeBtn setImage:kIMG(@"双向箭头_2")
                  forState:UIControlStateNormal];
        [_timeBtn setTitleColor:kBlackColor
                       forState:UIControlStateNormal];
        [UIView cornerCutToCircleWithView:_timeBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_timeBtn
                         WithColour:kBlackColor
                     AndBorderWidth:0.1f];
        _timeBtn.imageAlignment = MMImageAlignmentRight;
        _timeBtn.spaceBetweenTitleAndImage = SCALING_RATIO(2);
        [_timeBtn.titleLabel sizeToFit];
        _timeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.scrollView addSubview:_timeBtn];
    }return _timeBtn;
}

-(MMButton *)typeBtn{
    if (!_typeBtn) {
        _typeBtn = MMButton.new;
        [_typeBtn addTarget:self
                     action:@selector(typeBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        [_typeBtn setImage:kIMG(@"双向箭头_2")
                  forState:UIControlStateNormal];
        [_typeBtn setTitleColor:kBlackColor
                       forState:UIControlStateNormal];
        [UIView cornerCutToCircleWithView:_typeBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_typeBtn
                         WithColour:kBlackColor
                     AndBorderWidth:0.1f];
        _typeBtn.imageAlignment = MMImageAlignmentRight;
        _typeBtn.spaceBetweenTitleAndImage = SCALING_RATIO(2);
        [_typeBtn.titleLabel sizeToFit];
        _typeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.scrollView addSubview:_typeBtn];
    }return _typeBtn;
}

-(MMButton *)tradeTypeBtn{
    if (!_tradeTypeBtn) {
        _tradeTypeBtn = MMButton.new;
        [_tradeTypeBtn addTarget:self
                          action:@selector(tradeTypeBtnClickEvent:)
                forControlEvents:UIControlEventTouchUpInside];
        [_tradeTypeBtn setImage:kIMG(@"双向箭头_2")
                       forState:UIControlStateNormal];
        [_tradeTypeBtn setTitleColor:kBlackColor
                            forState:UIControlStateNormal];
        [UIView cornerCutToCircleWithView:_tradeTypeBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_tradeTypeBtn
                         WithColour:kBlackColor
                     AndBorderWidth:0.1f];
        _tradeTypeBtn.imageAlignment = MMImageAlignmentRight;
        _tradeTypeBtn.spaceBetweenTitleAndImage = SCALING_RATIO(2);
        [_tradeTypeBtn.titleLabel sizeToFit];
        _tradeTypeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.scrollView addSubview:_tradeTypeBtn];
    }return _tradeTypeBtn;
}

-(UITextField *)textfield{
    if (!_textfield) {
        _textfield = UITextField.new;
        _textfield.delegate = self;
        [self addSubview:_textfield];
        [_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(SCALING_RATIO(-10));
            [self layoutIfNeeded];
            make.height.mas_equalTo(self.mj_h / 2);
        }];
    }return _textfield;
}

-(NSMutableArray<UIView *> *)viewMutArr{
    if (!_viewMutArr) {
        _viewMutArr = NSMutableArray.array;
        [_viewMutArr addObject:self.defaultBtn];
        [_viewMutArr addObject:self.timeBtn];
        [_viewMutArr addObject:self.typeBtn];
        [_viewMutArr addObject:self.tradeTypeBtn];
        [_viewMutArr addObject:self.textfield];
    }return _viewMutArr;
}

-(NSMutableArray<NSString *> *)btnTitleMutArr{
    if (!_btnTitleMutArr) {
        _btnTitleMutArr = NSMutableArray.array;
        [_btnTitleMutArr addObject:@"默认排序"];
        [_btnTitleMutArr addObject:@"按时间"];
        [_btnTitleMutArr addObject:@"按买/卖"];
        [_btnTitleMutArr addObject:@"交易状态"];
        [_btnTitleMutArr addObject:@"在此输入查询ID"];
    }return _btnTitleMutArr;
}

@end

@interface OrderListVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)SearchView *viewer;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *filterBtn;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation OrderListVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated{
    
    OrderListVC *vc = OrderListVC.new;
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
//    self.navigationItem.title = @"订单管理";
    self.gk_navTitle = @"订单管理";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.filterBtn];
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark —— 私有方法
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    [self.tableView.mj_header endRefreshing];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    [self.tableView.mj_header endRefreshing];
}
#pragma mark —— 点击事件
-(void)filterBtnClickEvent:(UIButton *)sender{
    @weakify(self)
    UIEdgeInsets inset = [self.tableView contentInset];
    if (!sender.selected) {
        inset.top = SCALING_RATIO(50);
        [UIView animateWithDuration:1.f
                              delay:0.f
                            options:UIViewAnimationOptionTransitionCurlDown
                         animations:^{
            @strongify(self)
            self.viewer.alpha = 1;
        }
                         completion:^(BOOL finished) {
            
        }];
    }else{
        inset.top = SCALING_RATIO(0);
        [UIView animateWithDuration:1.f
                              delay:0.f
                            options:UIViewAnimationOptionTransitionCurlUp
                         animations:^{
            @strongify(self)
            self.viewer.alpha = 0;
        }
                         completion:^(BOOL finished) {
            
        }];
    }
    [self.tableView setContentInset:inset];
    //获取到需要跳转位置的行数
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0
                                                      inSection:0];
    //滚动到其相应的位置
    [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
            atScrollPosition:UITableViewScrollPositionBottom
                                    animated:YES];
    sender.selected = !sender.selected;
}

#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [OrderTBVCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    [OrderDetailVC pushFromVC:self
                requestParams:nil
                      success:^(id data) {}
                     animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderTBVCell *cell = [OrderTBVCell cellWith:tableView];
    [cell richElementsInCellWithModel:nil];
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
-(SearchView *)viewer{
    if (!_viewer) {
        _viewer = SearchView.new;
        _viewer.backgroundColor = kWhiteColor;
        [self.view addSubview:_viewer];
        [_viewer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
            make.height.mas_equalTo(SCALING_RATIO(50));
        }];
    }return _viewer;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.mj_footer.hidden = YES;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }return _tableView;
}

-(UIButton *)filterBtn{
    if (!_filterBtn) {
        _filterBtn = UIButton.new;
        [_filterBtn setImage:kIMG(@"放大镜")
                    forState:UIControlStateNormal];
        [_filterBtn addTarget:self
                       action:@selector(filterBtnClickEvent:)
             forControlEvents:UIControlEventTouchUpInside];
    }return _filterBtn;
}



@end
