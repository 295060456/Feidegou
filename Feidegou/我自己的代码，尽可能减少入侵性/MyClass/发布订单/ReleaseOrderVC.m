//
//  RealeaseOrderVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/30.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ReleaseOrderVC.h"

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

@interface ReleaseOrderTBVCell (){}

@property(nonatomic,strong)UITextField *textfield;
@property(nonatomic,strong)UILabel *lab;
@property(nonatomic,strong)UIButton *btn;

@end

@implementation ReleaseOrderTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    ReleaseOrderTBVCell *cell = (ReleaseOrderTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[ReleaseOrderTBVCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier:ReuseIdentifier
                                                   margin:SCALING_RATIO(5)];
        cell.backgroundColor = RandomColor;//kClearColor;
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

- (void)richElementsInCellWithModel:(id _Nullable)model{
    
}

@end

@interface ReleaseOrderVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isDelCell;

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
    self.gk_navTitle = @"发布订单";
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    return self.titleMutArr.count - 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReleaseOrderTBVCell *cell = [ReleaseOrderTBVCell cellWith:tableView];
    cell.textLabel.text = self.titleMutArr[indexPath.row + 2];
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
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
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

-(NSMutableArray<NSString *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:@"商品"];
        [_titleMutArr addObject:@"喵粮"];
        [_titleMutArr addObject:@"数量"];
        [_titleMutArr addObject:@"最低限额"];
        [_titleMutArr addObject:@"最高限额"];
        [_titleMutArr addObject:@"单价"];
        [_titleMutArr addObject:@"付款方式"];
        [_titleMutArr addObject:@"发布"];
    }return _titleMutArr;
}

@end
