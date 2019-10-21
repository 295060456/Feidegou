//
//  OrderDetailVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderDetailVC.h"
#pragma mark —— InfoView
@interface OrderDetailTBVCell_01 ()

@property(nonatomic,strong)UIButton *A_Btn;
@property(nonatomic,strong)UIButton *B_Btn;
@property(nonatomic,strong)UIButton *directionBtn;

@end

@implementation OrderDetailTBVCell_01

+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetailTBVCell_01 *cell = (OrderDetailTBVCell_01 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];//
    if (!cell) {
        cell = [[OrderDetailTBVCell_01 alloc] initWithStyle:UITableViewCellStyleDefault
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
    self.A_Btn.alpha = 1;
    self.B_Btn.alpha = 1;
    self.directionBtn.alpha = 1;
}

#pragma mark —— lazyLoad
-(UIButton *)A_Btn{
    if (!_A_Btn) {
        _A_Btn = UIButton.new;
        _A_Btn.titleLabel.text = @"1234567";
        _A_Btn.backgroundColor = kBlueColor;
        [_A_Btn.titleLabel sizeToFit];
        _A_Btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_A_Btn];
        [_A_Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(SCALING_RATIO(10));
            if (self.mj_h < SCREEN_HEIGHT / 10) {//
                make.top.equalTo(self.contentView).offset(SCALING_RATIO(10));
                make.bottom.equalTo(self.contentView).offset(SCALING_RATIO(-10));
            }else{
                make.height.mas_equalTo(self.contentView.mj_h / 2);
            }
        }];
    }return _A_Btn;
}

-(UIButton *)B_Btn{
    if (!_B_Btn) {
        _B_Btn = UIButton.new;
        _B_Btn.titleLabel.text = @"1234567";
        [_B_Btn.titleLabel sizeToFit];
        _B_Btn.backgroundColor = kRedColor;
        _B_Btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_B_Btn];
        [_B_Btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-10));
            if (self.mj_h < SCREEN_HEIGHT / 10) {//
                make.top.equalTo(self.contentView).offset(SCALING_RATIO(10));
                make.bottom.equalTo(self.contentView).offset(SCALING_RATIO(-10));
            }else{
                make.height.mas_equalTo(self.contentView.mj_h / 2);
            }
        }];
    }return _B_Btn;
}

-(UIButton *)directionBtn{
    if (!_directionBtn) {
        _directionBtn = UIButton.new;
        [_directionBtn setImage:kIMG(@"双向箭头")
                       forState:UIControlStateNormal];
        [self addSubview:_directionBtn];
        [_directionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.A_Btn.mas_right).offset(SCALING_RATIO(5));
            make.right.equalTo(self.B_Btn.mas_left).offset(SCALING_RATIO(-5));
            make.height.mas_equalTo(SCALING_RATIO(20));
        }];
    }return _directionBtn;
}

@end

@interface OrderDetailTBVCell_02 ()
<UITableViewDelegate,
UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*tempMutArr;

@end

@implementation OrderDetailTBVCell_02
+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetailTBVCell_02 *cell = (OrderDetailTBVCell_02 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OrderDetailTBVCell_02 alloc] initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:ReuseIdentifier
                                                     margin:SCALING_RATIO(5)];
        [UIView cornerCutToCircleWithView:cell.contentView
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:cell.contentView
                         WithColour:KGreenColor
                     AndBorderWidth:.1f];
    }return cell;
}

-(CGFloat)cellHeightWithModel:(id _Nullable)model{//大
    return self.titleMutArr.count * [OrderDetailTBVCell_03 cellHeightWithModel:NULL];
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.tableView.alpha = 1;
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [OrderDetailTBVCell_03 cellHeightWithModel:Nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    return;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.titleMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailTBVCell_03 *cell = [OrderDetailTBVCell_03 cellWith:tableView];
    cell.textLabel.text = self.titleMutArr[indexPath.row];
    cell.detailTextLabel.text = self.tempMutArr[indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.contentView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }return _tableView;
}

-(NSMutableArray<NSString *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:@"订单:"];
        [_titleMutArr addObject:@"单价:"];
        [_titleMutArr addObject:@"总价:"];
        [_titleMutArr addObject:@"账号:"];
        [_titleMutArr addObject:@"支付方式:"];
        [_titleMutArr addObject:@"参考号:"];
        [_titleMutArr addObject:@"下单时间:"];
    }return _titleMutArr;
}

-(NSMutableArray<NSString *> *)tempMutArr{
    if (!_tempMutArr) {
        _tempMutArr = NSMutableArray.array;
        [_tempMutArr addObject:@"1234567890"];
        [_tempMutArr addObject:@"12.0 CNY"];
        [_tempMutArr addObject:@"200.00 CNY"];
        [_tempMutArr addObject:@"账号"];
        [_tempMutArr addObject:@"银行卡"];
        [_tempMutArr addObject:@"dsjaihoufex"];
        [_tempMutArr addObject:@"2019/09/26 23:22:23 "];
    }return _tempMutArr;
}

@end

@interface OrderDetailTBVCell_03 ()
@end

@implementation OrderDetailTBVCell_03

+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetailTBVCell_03 *cell = (OrderDetailTBVCell_03 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OrderDetailTBVCell_03 alloc] initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:ReuseIdentifier
                                                     margin:SCALING_RATIO(5)];
        [UIView cornerCutToCircleWithView:cell.contentView
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:cell.contentView
                         WithColour:KGreenColor
                     AndBorderWidth:.1f];
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{//小
    return SCALING_RATIO(40);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
}

@end

@interface OrderDetailTBVCell_04 ()

@property(nonatomic,strong)UILabel *titleLab;

@end

@implementation OrderDetailTBVCell_04

+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetailTBVCell_04 *cell = (OrderDetailTBVCell_04 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];//
    if (!cell) {
        cell = [[OrderDetailTBVCell_04 alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:ReuseIdentifier
                                                     margin:SCALING_RATIO(5)];
        [UIView cornerCutToCircleWithView:cell.contentView
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:cell.contentView
                         WithColour:KGreenColor
                     AndBorderWidth:.1f];
    }return cell;
}

-(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCREEN_HEIGHT / 10;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];

}

#pragma mark —— lazyLoad
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
        _titleLab.text = @"您向习近平购买43.22222222222";
        _titleLab.numberOfLines = 0;
        [_titleLab sizeToFit];
    }return _titleLab;
}

@end

#pragma mark —— OrderDetailVC
@interface OrderDetailVC ()
<
UITableViewDelegate,
UITableViewDataSource
>{
    CGFloat OrderDetailTBVCell_02_Height;
}

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *sureBtn;
@property(nonatomic,strong)UIButton *cancelBtn;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation OrderDetailVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated{
    
    OrderDetailVC *vc = OrderDetailVC.new;
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
    //    self.navigationItem.title = @"订单详情";
    self.gk_navTitle = @"订单详情";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
//    self.infoView.alpha = 1;
    self.tableView.alpha = 1;
    self.sureBtn.alpha = 1;
    self.cancelBtn.alpha = 1;
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
}
#pragma mark —— 点击事件
-(void)sureBtnClickEvent:(UIButton *)sender{
    
}

-(void)cancelBtnClickEvent:(UIButton *)sender{
    
    
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

#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0 &&
        indexPath.row == 0) {
        return [OrderDetailTBVCell_01 cellHeightWithModel:Nil];
    }else if(indexPath.section == 1 &&
             indexPath.row == 0){
        return OrderDetailTBVCell_02_Height;
    }else{}
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }else{}
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {

        }else{}
    }else{}
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            OrderDetailTBVCell_01 *cell = [OrderDetailTBVCell_01 cellWith:tableView];
            [cell richElementsInCellWithModel:nil];
            return cell;
        }else{}
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            OrderDetailTBVCell_02 *cell = [OrderDetailTBVCell_02 cellWith:tableView];
            OrderDetailTBVCell_02_Height = [cell cellHeightWithModel:NULL];
            cell.backgroundColor = KGreenColor;
            [cell richElementsInCellWithModel:nil];
            return cell;
        }
    }else{
        return UITableViewCell.new;
    }return UITableViewCell.new;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }return _tableView;
}

-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = UIButton.new;
        [_sureBtn setTitle:@"确认发货"
                  forState:UIControlStateNormal];
        [_sureBtn addTarget:self
                     action:@selector(sureBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.backgroundColor = kOrangeColor;
        [UIView cornerCutToCircleWithView:_sureBtn
                          AndCornerRadius:5];
        [self.view addSubview:_sureBtn];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(SCALING_RATIO(10));
            make.bottom.equalTo(self.view).offset(SCALING_RATIO(-100));
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 5,
                                             SCREEN_HEIGHT / 15));
        }];
    }return _sureBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = UIButton.new;
        [_cancelBtn setTitle:@"取消"
                    forState:UIControlStateNormal];
        [_cancelBtn addTarget:self
                       action:@selector(cancelBtnClickEvent:)
             forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.backgroundColor = KLightGrayColor;
        [UIView cornerCutToCircleWithView:_cancelBtn
                          AndCornerRadius:5];
        [self.view addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(SCALING_RATIO(-10));
            make.bottom.equalTo(self.view).offset(SCALING_RATIO(-100));
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 5,
                                             SCREEN_HEIGHT / 15));
        }];
    }return _cancelBtn;
}





@end
