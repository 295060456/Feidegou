//
//  CatFoodProducingAreaVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/22.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "CatFoodProducingAreaVC.h"
#import "CatFoodProducingAreaVC+VM.h"

@interface CatFoodProducingAreaTBVCell ()

@property(nonatomic,strong)UILabel *sellerNameLab;//卖家名称
@property(nonatomic,strong)UILabel *priceLab;//单价
@property(nonatomic,strong)UILabel *numLab;//数量
@property(nonatomic,strong)UILabel *buyTipsLab;

@end

@interface CatFoodProducingAreaVC ()
<
UITableViewDelegate,
UITableViewDataSource
>
{
    CGFloat CatFoodProducingAreaTBVCellHeight;
}

@property(nonatomic,strong)UIButton *fleshBtn;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isDelCell;

@end

@implementation CatFoodProducingAreaVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated{
    CatFoodProducingAreaVC *vc = CatFoodProducingAreaVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    vc.isDelCell = NO;
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
    self.gk_navTitle = @"喵粮产地";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.fleshBtn];
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.currentpage = 1;
    self.tableView.alpha = 1;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark —— 点击事件
-(void)fleshBtnClickEvent:(UIButton *)sender{
    NSLog(@"刷新");
    [self.tableView.mj_header beginRefreshing];
}

-(void)backBtnClickEvent:(UIButton *)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark —— 私有方法
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    if (self.dataMutArr.count) {
        [self.dataMutArr removeAllObjects];
    }
    [self netWorking];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    self.currentpage++;
    [self netWorking];
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CatFoodProducingAreaTBVCellHeight;
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
    //点击进行购买
    [self purchase_netWorking:self.dataMutArr[indexPath.row]];//购买完在上传凭证，可以不要凭证
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.dataMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CatFoodProducingAreaTBVCell *cell = [CatFoodProducingAreaTBVCell cellWith:tableView];
//    cell.backgroundColor = RandomColor;
    if (self.dataMutArr.count) {
        [cell richElementsInCellWithModel:self.dataMutArr[indexPath.row]];
    }
    CatFoodProducingAreaTBVCellHeight = [cell cellHeightWithModel:nil];
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
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = UIView.new;
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.mj_footer.hidden = YES;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                            titleStr:@"暂无数据"
                                                           detailStr:@""];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//推荐该方法
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }return _tableView;
}

-(UIButton *)fleshBtn{
    if (!_fleshBtn) {
        _fleshBtn = UIButton.new;
        [_fleshBtn addTarget:self
                      action:@selector(fleshBtnClickEvent:)
            forControlEvents:UIControlEventTouchUpInside];
        [_fleshBtn setImage:kIMG(@"刷新")
                   forState:UIControlStateNormal];
    }return _fleshBtn;
}

-(NSMutableArray<CatFoodProducingAreaModel *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

@end

@implementation CatFoodProducingAreaTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    CatFoodProducingAreaTBVCell *cell = (CatFoodProducingAreaTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[CatFoodProducingAreaTBVCell alloc]initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:ReuseIdentifier
                                                        margin:SCALING_RATIO(10)];
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"猫和鱼")];
        [UIView cornerCutToCircleWithView:cell
                          AndCornerRadius:10.f];
        [UIView colourToLayerOfView:cell
                         WithColour:kWhiteColor
                     AndBorderWidth:0.3f];
        [UIView cornerCutToCircleWithView:cell.contentView
                          AndCornerRadius:10.f];
        [UIView colourToLayerOfView:cell.contentView
                         WithColour:kWhiteColor
                     AndBorderWidth:0.3f];
    }return cell;
}

-(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(80);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    if ([model isKindOfClass:[CatFoodProducingAreaModel class]]) {
        CatFoodProducingAreaModel *catFoodProducingAreaModel = model;
        self.sellerNameLab.text = [NSString stringWithFormat:@"厂家:%@",[NSString ensureNonnullString:catFoodProducingAreaModel.seller ReplaceStr:@"无"]];
        self.priceLab.text = [NSString stringWithFormat:@"单价:%@",[NSString ensureNonnullString:catFoodProducingAreaModel.price ReplaceStr:@"无"]];
        self.numLab.text = [NSString stringWithFormat:@"数量:%@",[NSString ensureNonnullString:catFoodProducingAreaModel.quantity ReplaceStr:@"无"]];
        self.buyTipsLab.text = @"点击购买";
        [self.sellerNameLab sizeToFit];
        [self.priceLab sizeToFit];
        [self.numLab sizeToFit];
        [self.buyTipsLab sizeToFit];
    }
}
#pragma mark —— lazyLoad
-(UILabel *)sellerNameLab{
    if (!_sellerNameLab) {
        _sellerNameLab = UILabel.new;
//        _sellerNameLab.backgroundColor = kRedColor;
        [self.contentView addSubview:_sellerNameLab];
        [_sellerNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(SCALING_RATIO(10));
        }];
    }return _sellerNameLab;
}

-(UILabel *)priceLab{
    if (!_priceLab) {
        _priceLab = UILabel.new;
//        _priceLab.backgroundColor = kBlueColor;
        [self.contentView addSubview:_priceLab];
        [_priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(SCALING_RATIO(10));
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-10));
        }];
    }return _priceLab;
}

-(UILabel *)numLab{
    if (!_numLab) {
        _numLab = UILabel.new;
//        _numLab.backgroundColor = KGreenColor;
        [self.contentView addSubview:_numLab];
        [_numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(SCALING_RATIO(-10));
            make.left.equalTo(self.contentView).offset(SCALING_RATIO(10));
            make.top.equalTo(self.sellerNameLab.mas_bottom).offset(SCALING_RATIO(5));
        }];
    }return _numLab;
}

-(UILabel *)buyTipsLab{
    if (!_buyTipsLab) {
        _buyTipsLab = UILabel.new;
        [self.contentView addSubview:_buyTipsLab];
        [_buyTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(SCALING_RATIO(-10));
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-10));
            make.top.equalTo(self.sellerNameLab.mas_bottom).offset(SCALING_RATIO(5));
        }];
    }return _buyTipsLab;
}

@end
