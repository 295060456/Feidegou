//
//  OrderListVC.m
//  My_BaseProj
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 Corp. All rights reserved.
//

#import "OrderListVC.h"
#import "OrderDetail_SellerVC.h"
#import "OrderListVC+VM.h"

#pragma mark —— OrderTBVCell
@interface OrderTBVCell ()

@property(nonatomic,strong)UIImageView *imgV;
@property(nonatomic,strong)UIImageView *typeImgV;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *timeLab;

@end

@implementation OrderTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    OrderTBVCell *cell = (OrderTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OrderTBVCell alloc] initWithStyle:UITableViewCellStyleDefault
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
    return SCREEN_HEIGHT / 10;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    if ([model isKindOfClass:[OrderListModel class]]) {
        OrderListModel *orderListModel = (OrderListModel *)model;
        self.titleLab.text = [NSString stringWithFormat:@"喵粮:%@ g",[NSString ensureNonnullString:orderListModel.quantity ReplaceStr:@"无"]];
        self.timeLab.text = [NSString ensureNonnullString:orderListModel.addTime ReplaceStr:@"无"];
        if ([orderListModel.seller intValue] == 1) {//APQ
            self.typeImgV.image = kIMG(@"Mf_旌旗_红色");
            self.imgV.backgroundColor = kRedColor;
        }else{
            self.typeImgV.image = kIMG(@"Mf_旌旗_绿色");
            self.imgV.backgroundColor = KGreenColor;
        }
    }
}
#pragma mark —— lazyLoad
-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = UIImageView.new;
        [UIView cornerCutToCircleWithView:_imgV
                          AndCornerRadius:SCALING_RATIO(5) / 2];
        [self.contentView addSubview:_imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(SCALING_RATIO(10));
            make.size.mas_equalTo(CGSizeMake(SCALING_RATIO(5), SCALING_RATIO(5)));
        }];
    }return _imgV;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgV.mas_right).offset(SCALING_RATIO(5));
            make.top.equalTo(self.contentView).offset(SCALING_RATIO(5));
            make.bottom.equalTo(self.contentView).offset(SCALING_RATIO(-5));
        }];
        _titleLab.numberOfLines = 0;
        [_titleLab sizeToFit];
    }return _titleLab;
}

-(UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = UILabel.new;
        _timeLab.numberOfLines = 0;
        [_timeLab sizeToFit];
        [self.contentView addSubview:_timeLab];
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-5));
            make.bottom.equalTo(self.contentView).offset(SCALING_RATIO(-5));
        }];
    }return _timeLab;
}

-(UIImageView *)typeImgV{
    if (!_typeImgV) {
        _typeImgV = UIImageView.new;
        [self.contentView addSubview:_typeImgV];
        [_typeImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-30));
            make.top.equalTo(self.contentView);
            make.width.mas_equalTo(SCALING_RATIO(30));
            make.bottom.equalTo(self.contentView.mas_centerY);
        }];
    }return _typeImgV;
}

@end

#pragma mark —— SearchView

@interface SearchView ()
<
UITextFieldDelegate,
UIScrollViewDelegate
>
{
    CGFloat scrollViewContentOffsetX;
}

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)HistoryDataListTBV *historyDataListTBV;
@property(nonatomic,strong)MMButton *defaultBtn;
@property(nonatomic,strong)MMButton *timeBtn;//按时间
@property(nonatomic,strong)MMButton *typeBtn;//按类型（目前进行中(挂牌出售中)、已经取消的）
@property(nonatomic,strong)MMButton *tradeTypeBtn;//交易类型(买/卖)
@property(nonatomic,strong)UITextField *textfield;
@property(nonatomic,copy)TwoDataBlock block;//
@property(nonatomic,strong)NSMutableArray <UIView *>*viewMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*tempMutArr;
@property(nonatomic,strong)UIButton *tempBtn;//触发点

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
}

-(void)conditionalQueryBlock:(TwoDataBlock)block{
    _block = block;
}
#pragma mark —— UITextFieldDelegate
//询问委托人是否应该在指定的文本字段中开始编辑
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
//告诉委托人在指定的文本字段中开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"");
    [self.historyDataListTBV removeFromSuperview];
    self.tradeTypeBtn.selected = NO;
}
//询问委托人是否应在指定的文本字段中停止编辑
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
//告诉委托人对指定的文本字段停止编辑
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.block) {
        self.block(textField, @"");
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
#pragma mark —— UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    scrollViewContentOffsetX = scrollView.contentOffset.x;
    [_historyDataListTBV removeFromSuperview];
}
#pragma mark —— 点击事件
-(void)platformTypeBtnClickEvent:(UIButton *)sender{//
    NSLog(@"平台类型");
    if (!sender.selected) {//首次进 sender.selected == NO
        self.tempBtn = sender;
        self.tempMutArr = Nil;
        self.tempMutArr = [self.listTitlePlatformStyleDataMutArr copy];
        if (_historyDataListTBV) {
            [_historyDataListTBV removeFromSuperview];
            _historyDataListTBV = Nil;
        }
        [self addSubview:self.historyDataListTBV];
        self.historyDataListTBV.frame = CGRectMake(self.defaultBtn.mj_x - scrollViewContentOffsetX,
                                                   self.defaultBtn.mj_y + self.defaultBtn.mj_h,
                                                   self.defaultBtn.mj_w,
                                                   self.listTitlePlatformStyleDataMutArr.count * [HistoryDataListTBVCell cellHeightWithModel:Nil]);
    }else{
        [self.historyDataListTBV removeFromSuperview];
    }
    sender.selected = !sender.selected;
}

-(void)timeBtnClickEvent:(UIButton *)sender{
    NSLog(@"时间");
    if (self.block) {
        self.block(sender,@"");
    }
    sender.selected = !sender.selected;
}

-(void)typeBtnClickEvent:(UIButton *)sender{
    NSLog(@"买卖");
    if (self.block) {
        self.block(sender,@"");
    }
    sender.selected = !sender.selected;
}

-(void)tradeTypeBtnClickEvent:(UIButton *)sender{
    NSLog(@"交易状态");
    NSLog(@"KKK = %d",sender.selected);
    if (!sender.selected) {
        self.tempBtn = sender;
        self.tempMutArr = Nil;
        self.tempMutArr = [self.listTitleDataMutArr copy];
        if (_historyDataListTBV) {
            [_historyDataListTBV removeFromSuperview];
            _historyDataListTBV = Nil;
        }
        [self addSubview:self.historyDataListTBV];
        self.historyDataListTBV.frame = CGRectMake(self.tradeTypeBtn.mj_x - scrollViewContentOffsetX,
                                                   self.tradeTypeBtn.mj_y + self.tradeTypeBtn.mj_h,
                                                   self.tradeTypeBtn.mj_w,
                                                   self.listTitleDataMutArr.count * [HistoryDataListTBVCell cellHeightWithModel:Nil]);
    }else{
        [self.historyDataListTBV removeFromSuperview];
    }
    sender.selected = !sender.selected;
}
//超出父控件点击事件响应链断裂解决方案
//若A是父视图,B是子视图,（B加在A上）,B超出A的范围,把这个方法写在A上
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (!view) {
        //将坐标由当前视图发送到 指定视图 fromView是无法响应的范围小父视图
        CGPoint stationPoint = [self.historyDataListTBV convertPoint:point
                                                                     fromView:self];
        if (CGRectContainsPoint(self.historyDataListTBV.bounds, stationPoint)){
            view = self.historyDataListTBV;
        }
    }return view;
}
#pragma mark —— lazyLoad
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = UIScrollView.new;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH + SCALING_RATIO(150), self.mj_h);
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

-(HistoryDataListTBV *)historyDataListTBV{
    if (!_historyDataListTBV) {
        _historyDataListTBV = [HistoryDataListTBV initWithRequestParams:self.tempMutArr
                                                              triggerBy:self.tempBtn];
        _historyDataListTBV.tableFooterView = UIView.new;
        @weakify(self)
        [_historyDataListTBV showSelectedData:^(id data, id data2) {//点击哪条信息、触发者
            @strongify(self)
            [self.historyDataListTBV removeFromSuperview];
            self.tradeTypeBtn.selected = !self.tradeTypeBtn.selected;
            self.defaultBtn.selected = !self.defaultBtn.selected;
            if (self.block) {
                self.block(data,data2);
            }
        }];
    }return _historyDataListTBV;
}

-(NSMutableArray<NSString *> *)listTitleDataMutArr{
    if (!_listTitleDataMutArr) {
        _listTitleDataMutArr = NSMutableArray.array;
        [_listTitleDataMutArr addObject:@"已支付"];
        [_listTitleDataMutArr addObject:@"已发单"];
        [_listTitleDataMutArr addObject:@"已接单"];
        [_listTitleDataMutArr addObject:@"已作废"];
        [_listTitleDataMutArr addObject:@"已发货"];
        [_listTitleDataMutArr addObject:@"已完成"];
    }return _listTitleDataMutArr;
}

-(NSMutableArray<NSString *> *)listTitlePlatformStyleDataMutArr{
    if (!_listTitlePlatformStyleDataMutArr) {
        _listTitlePlatformStyleDataMutArr = NSMutableArray.array;
        [_listTitlePlatformStyleDataMutArr addObject:@"厂家直销"];
        [_listTitlePlatformStyleDataMutArr addObject:@"批发市场"];
        [_listTitlePlatformStyleDataMutArr addObject:@"摊位抢购"];
    }return _listTitlePlatformStyleDataMutArr;
}

-(MMButton *)defaultBtn{
    if (!_defaultBtn) {
        _defaultBtn = MMButton.new;
        [_defaultBtn addTarget:self
                        action:@selector(platformTypeBtnClickEvent:)
              forControlEvents:UIControlEventTouchUpInside];
        [_defaultBtn setImage:kIMG(@"双向箭头_1")
                     forState:UIControlStateNormal];
        [_defaultBtn setImage:kIMG(@"双向箭头_2")
                     forState:UIControlStateSelected];
        [_defaultBtn setTitleColor:kBlackColor
                          forState:UIControlStateNormal];
        [UIView cornerCutToCircleWithView:_defaultBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_defaultBtn
                         WithColour:kBlackColor
                     AndBorderWidth:0.1f];
        _defaultBtn.imageAlignment = MMImageAlignmentRight;
        _defaultBtn.spaceBetweenTitleAndImage = SCALING_RATIO(2);
//        _defaultBtn.frame = CGRectMake(0,
//                                       0,
//                                       SCALING_RATIO(200),
//                                       SCALING_RATIO(10));
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
        [_timeBtn setImage:kIMG(@"双向箭头_1")
                  forState:UIControlStateNormal];
        [_timeBtn setImage:kIMG(@"双向箭头_2")
                  forState:UIControlStateSelected];
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
        [_typeBtn setImage:kIMG(@"双向箭头_1")
                  forState:UIControlStateNormal];
        [_typeBtn setImage:kIMG(@"双向箭头_2")
                  forState:UIControlStateSelected];
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
        [_tradeTypeBtn setImage:kIMG(@"双向箭头_1")
                       forState:UIControlStateNormal];
        [_tradeTypeBtn setImage:kIMG(@"双向箭头_2")
                       forState:UIControlStateSelected];
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
        [UIView colourToLayerOfView:_textfield
                         WithColour:kBlackColor
                     AndBorderWidth:0.5f];
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
        [_btnTitleMutArr addObject:@"平台类型"];
        [_btnTitleMutArr addObject:@"按时间"];
        [_btnTitleMutArr addObject:@"按买/卖"];
        [_btnTitleMutArr addObject:@"交易状态"];
        [_btnTitleMutArr addObject:@"在此输入查询的订单ID"];
    }return _btnTitleMutArr;
}

@end

#pragma mark —— OrderListVC

@interface OrderListVC ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    Networking_tpye networking_tpye;
    NSUInteger r;//所选的交易状态类型
    NSUInteger w;//所选的交易状态类型
}

@property(nonatomic,strong)SearchView *viewer;
@property(nonatomic,strong)UIButton *filterBtn;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isDelCell;
@property(nonatomic,assign)BOOL isSelected;//防止TableViewCell重复点击

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
    vc.requestParams = requestParams;//nil
    vc.page = 1;
    vc.isSelected = NO;
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
    self.gk_navTitle = @"订单管理";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.filterBtn];
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    networking_tpye = NetworkingTpye_default;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark —— 私有方法
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
    switch (networking_tpye) {
        case NetworkingTpye_default:{//默认
            [self networking_default];
        }break;
        case NetworkingTpye_time:{//时间
            [self networking_time:self.viewer.timeBtn];
        }break;
        case NetworkingTpye_tradeType:{//买卖
            [self networking_tradeType:self.viewer.tradeTypeBtn];
        }break;
        case NetworkingTpye_businessType:{//交易状态
            [self networking_type:r];
        }break;
        case NetworkingTpye_ID:{//ID查询
            [self networking_ID:self.viewer.textfield.text];
        }break;
        case NetworkingTpye_ProducingArea:{//产地
            [self networking_platformType:w];
        }break;
        default:
            break;
    }[self.tableView.mj_header endRefreshing];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    self.page++;
    [self pullToRefresh];
    [self.tableView.mj_footer endRefreshing];
}
#pragma mark —— 点击事件
-(void)filterBtnClickEvent:(UIButton *)sender{
    if (self.dataMutArr.count) {//不加这个判断会崩
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
    //
    //先移除数据源
    //
    self.isDelCell = YES;
    
//    [self.dataMutArr removeObjectAtIndex:indexPath.row];
//
//    [self.tableView beginUpdates];
//    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                            withRowAnimation:UITableViewRowAnimationMiddle];
//    [self.tableView endUpdates];
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
//                    withRowAnimation:UITableViewRowAnimationNone];
    
    @weakify(self)
    OrderListModel *orderListModel = self.dataMutArr[indexPath.row];
    [OrderDetail_SellerVC pushFromVC:self_weak_
                       requestParams:@{
                           @"OrderListModel":orderListModel
                       }
                             success:^(id data) {}
                            animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.dataMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderTBVCell *cell = [OrderTBVCell cellWith:tableView];
    if (self.dataMutArr.count) {
        [cell richElementsInCellWithModel:self.dataMutArr[indexPath.row]];
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
    if (!self.isDelCell) {
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
#pragma mark —— lazyLoad
-(SearchView *)viewer{
    if (!_viewer) {
        _viewer = SearchView.new;
        _viewer.backgroundColor = kWhiteColor;
        @weakify(self)
        [_viewer conditionalQueryBlock:^(id data, id data2) {
            @strongify(self)
            if ([data isKindOfClass:[UIButton class]]) {//点击的是UIButton
                UIButton *btn = (UIButton *)data;
                if ([btn.titleLabel.text isEqualToString:self->_viewer.btnTitleMutArr[1]]){//按时间
                    self->networking_tpye = NetworkingTpye_time;
                }else if ([btn.titleLabel.text isEqualToString:self->_viewer.btnTitleMutArr[2]]){//按按买/卖
                    self->networking_tpye = NetworkingTpye_tradeType;
                }else{}
            }else if ([data isKindOfClass:[UITextField class]]){//点击的是UITextField
                UITextField *textField = (UITextField *)data;
                if ([textField.placeholder isEqualToString:self->_viewer.btnTitleMutArr[4]]) {//输入的🆔
                    self->networking_tpye = NetworkingTpye_ID;
                }
            }else if([data isKindOfClass:[NSString class]]){//点击的是列表 传过来的是字符
                if ([data2 isKindOfClass:[MMButton class]]) {
                    MMButton *btn = (MMButton *)data2;
                    [btn setTitle:data forState:UIControlStateNormal];
                }
                if ([self->_viewer.listTitleDataMutArr containsObject:data]) {//按交易状态
                    self->r = 0;
                    for (int d = 0; d < self->_viewer.listTitleDataMutArr.count; d++) {
                        if ([data isEqualToString:self->_viewer.listTitleDataMutArr[d]]) {
                            self->r = d;
                            self->networking_tpye = NetworkingTpye_businessType;
                        }
                    }
                }else if ([self->_viewer.listTitlePlatformStyleDataMutArr containsObject:data]){//按平台类型
                    self->w = 0;
                    for (int d = 0; d < self->_viewer.listTitlePlatformStyleDataMutArr.count; d++) {
                        if ([data isEqualToString:self->_viewer.listTitlePlatformStyleDataMutArr[d]]) {
                            self->w = d;
                            self->networking_tpye = NetworkingTpye_ProducingArea;
                        }
                    }
                }else{}
            }else{}
            [self.tableView.mj_header beginRefreshing];
        }];
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

-(NSMutableArray<OrderListModel *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

@end
