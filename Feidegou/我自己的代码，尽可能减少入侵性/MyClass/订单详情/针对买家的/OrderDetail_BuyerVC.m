//
//  OrderDetail_BuyerVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/23.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "OrderDetail_BuyerVC.h"

@interface OrderDetail_BuyerTBVCell_01 ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation OrderDetail_BuyerTBVCell_01

+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetail_BuyerTBVCell_01 *cell = (OrderDetail_BuyerTBVCell_01 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OrderDetail_BuyerTBVCell_01 alloc] initWithStyle:UITableViewCellStyleValue1
                                                  reuseIdentifier:ReuseIdentifier
                                                           margin:SCALING_RATIO(5)];
        cell.backgroundColor = kRedColor;//kClearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [UIView cornerCutToCircleWithView:cell.contentView
//                          AndCornerRadius:5.f];
//        [UIView colourToLayerOfView:cell.contentView
//                         WithColour:KGreenColor
//                     AndBorderWidth:.1f];
    }return cell;
}

-(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return 80;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{

}

#pragma mark —— lazyload
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉cell下划线
        [self.contentView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }return _tableView;
}

@end

@interface OrderDetail_BuyerTBVCell_02 ()

@end

@implementation OrderDetail_BuyerTBVCell_02

+(instancetype)cellWith:(UITableView *)tableView{
    OrderDetail_BuyerTBVCell_02 *cell = (OrderDetail_BuyerTBVCell_02 *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[OrderDetail_BuyerTBVCell_02 alloc] initWithStyle:UITableViewCellStyleValue1
                                     reuseIdentifier:ReuseIdentifier
                                              margin:SCALING_RATIO(5)];
        cell.backgroundColor = KGreenColor;//kClearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [UIView cornerCutToCircleWithView:cell.contentView
//                          AndCornerRadius:5.f];
//        [UIView colourToLayerOfView:cell.contentView
//                         WithColour:KGreenColor
//                     AndBorderWidth:.1f];
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
     return 80;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{

}

@end

@interface OrderDetail_BuyerVC ()
<
UITableViewDelegate,
UITableViewDataSource
>{
    CGFloat OrderDetail_BuyerTBVCell_01_Hight;
}

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation OrderDetail_BuyerVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated{
    
    OrderDetail_BuyerVC *vc = OrderDetail_BuyerVC.new;
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
    self.tableView.alpha = 1;
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
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
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 &&
        indexPath.row == 0) {
        return OrderDetail_BuyerTBVCell_01_Hight;
    }else if (indexPath.section == 1){
        return [OrderDetail_BuyerTBVCell_02 cellHeightWithModel:Nil];
    }else return 0.0f;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];

}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 &&
        indexPath.row == 0) {
        OrderDetail_BuyerTBVCell_01 *cell = [OrderDetail_BuyerTBVCell_01 cellWith:tableView];
        [cell richElementsInCellWithModel:nil];
        OrderDetail_BuyerTBVCell_01_Hight = [cell cellHeightWithModel:nil];
        return cell;
    }else if (indexPath.section == 1 &&
              indexPath.row == 0){
         OrderDetail_BuyerTBVCell_02 *cell = [OrderDetail_BuyerTBVCell_02 cellWith:tableView];
//        cell.backgroundColor = KGreenColor;
        [cell richElementsInCellWithModel:nil];
        return cell;
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
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉cell下划线
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }return _tableView;
}

@end
