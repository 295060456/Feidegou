//
//  CatFoodsManagementVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "CatFoodsManagementVC.h"
#import "OrderListVC.h"//订单
#import "ShopReceiptQRcodeVC.h"//店铺收款码"
#import "GiftVC.h"//赠送
#import "CatFoodProducingAreaVC.h"//喵粮产地
#import "ThroughTrainToPromoteVC.h"//喵粮直通车
#import "WholesaleMarket_AdvanceVC.h"//喵粮批发市场_仅高级商家可见
#import "WholesaleMarket_VipVC.h"//喵粮批发市场_仅Vip可见

#import "CatFoodsManagementVC+VM.h"

@interface CatFoodsManagementVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)NSMutableArray <NSArray *>*titleMutArr;
@property(nonatomic,strong)NSMutableArray <NSArray *>*imgMutArr;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;

@end

@implementation CatFoodsManagementVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    CatFoodsManagementVC *vc = CatFoodsManagementVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;

    if (rootVC.navigationController) {
        vc.isPush = YES;
        vc.isPresent = NO;
        vc.isFirstComing = YES;
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

#pragma mark - Lifecycle
-(instancetype)init{
    if (self = [super init]) {
    }return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.gk_navTitle = @"喵粮管理";
    self.tableView.alpha = 1;
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
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
    [self networking];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
    [self networking];
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCALING_RATIO(50);
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    @weakify(self)
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1){
            
        }else{
            
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [OrderListVC pushFromVC:self_weak_
                      requestParams:Nil
                            success:^(id data) {
                
            }
                           animated:YES];
        }else if (indexPath.row == 1){
            [ShopReceiptQRcodeVC pushFromVC:self_weak_
                              requestParams:Nil
                                    success:^(id data) {
            }
                                   animated:YES];
        }else if (indexPath.row == 2){
            [GiftVC pushFromVC:self_weak_
                 requestParams:nil
                       success:^(id data) {}
                      animated:YES];
        }else if (indexPath.row == 3){
            [CatFoodProducingAreaVC pushFromVC:self_weak_
                                 requestParams:nil
                                       success:^(id data) {}
                                      animated:YES];
        }else if (indexPath.row == 4){
            [ThroughTrainToPromoteVC pushFromVC:self_weak_
                                  requestParams:nil
                                        success:^(id data) {}
                                       animated:YES];
        }else if (indexPath.row == 5){
            //切换
//            [WholesaleMarket_AdvanceVC pushFromVC:self_weak_
//                                    requestParams:nil
//                                          success:^(id data) {}
//                                         animated:YES];
            
            [WholesaleMarket_VipVC pushFromVC:self_weak_
                                requestParams:nil
                                      success:^(id data) {}
                                     animated:YES];
        }else{}
    }else{}
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return self.titleMutArr[0].count;
        }
            break;
        case 1:{
            return self.titleMutArr[1].count;
        }
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                             reuseIdentifier:ReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.titleMutArr[indexPath.section][indexPath.row];
        cell.imageView.image = kIMG(self.imgMutArr[indexPath.section][indexPath.row]);
        cell.detailTextLabel.textColor = kBlueColor;
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = self.dataMutArr.count != 0 ? self.dataMutArr[0] : @"";
        }else{
            cell.detailTextLabel.text = self.dataMutArr.count != 0 ? self.dataMutArr[1] : @"";
        }
    }return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleMutArr.count;
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
    }self.isFirstComing = NO;
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
//            make.edges.equalTo(self.view);
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
        }];
    }return _tableView;
}

-(NSMutableArray<NSArray *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:@[@"余额",
                                  @"出售中"]];
        [_titleMutArr addObject:@[@"喵粮订单管理",
                                  @"店铺收款码",
                                  @"赠送",
                                  @"喵粮产地",
                                  @"喵粮直通车",
                                  @"喵粮批发市场"]];
    }return _titleMutArr;
}

-(NSMutableArray<NSArray *> *)imgMutArr{
    if (!_imgMutArr) {
        _imgMutArr = NSMutableArray.array;
        [_imgMutArr addObject:@[@"余额",
                                @"出售中"]];
        [_imgMutArr addObject:@[@"喵粮订单管理",
                                @"店铺收款码",
                                @"赠送",
                                @"喵粮产地",
                                @"喵粮直通车",
                                @"喵粮批发市场"]];
    }return _imgMutArr;
}

-(NSMutableArray *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

@end
