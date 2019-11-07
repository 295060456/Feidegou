//
//  SettingPaymentWayVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/7.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "SettingPaymentWayVC.h"
#import "SettingPaymentWayVC+VM.h"
#import "SettingPaymentWayTBViewForHeader.h"

@interface SettingPaymentWayVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)NSMutableArray <NSArray *>*dataMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*headViewTitleMutArr;
@property(nonatomic,strong)NSMutableArray <NSArray *>*placeholderMutArr;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation SettingPaymentWayVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    SettingPaymentWayVC *vc = SettingPaymentWayVC.new;
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
//    [self netWorking];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableView.mj_header beginRefreshing];
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    SettingPaymentWayTBViewForHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ReuseIdentifier];
    if (!headerView) {
        headerView = [[SettingPaymentWayTBViewForHeader alloc]initWithReuseIdentifier:ReuseIdentifier
                                                                             withData:self.headViewTitleMutArr[section]];
    }return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return SCALING_RATIO(40);
}
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCALING_RATIO(50);
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.dataMutArr[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                             reuseIdentifier:ReuseIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.textColor = kBlueColor;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataMutArr.count;
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
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.dataSource = self;
        _tableView.delegate = self;
//        _tableView.mj_header = self.tableViewHeader;
//        _tableView.mj_footer = self.tableViewFooter;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view);
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
        }];
    }return _tableView;
}

-(NSMutableArray<NSArray *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
        [_dataMutArr addObject:@[@"微信账号"]];
        [_dataMutArr addObject:@[@"支付宝账号"]];
        [_dataMutArr addObject:@[@"银行卡姓名",@"银行卡账号",@"银行卡类型",@"支行信息"]];
    }return _dataMutArr;
}

-(NSMutableArray<NSArray *> *)placeholderMutArr{
    if (!_placeholderMutArr) {
        [_placeholderMutArr addObject:@[@"输入微信账号"]];
        [_placeholderMutArr addObject:@[@"输入支付宝账号"]];
        [_placeholderMutArr addObject:@[@"输入账户姓名",@"输入银行卡账号",@"输入开户行",@"输入支行信息"]];
    }return _placeholderMutArr;
}

-(NSMutableArray<NSString *> *)headViewTitleMutArr{
    if (!_headViewTitleMutArr) {
        _headViewTitleMutArr = NSMutableArray.array;
        [_headViewTitleMutArr addObject:@"微信"];
        [_headViewTitleMutArr addObject:@"支付宝"];
        [_headViewTitleMutArr addObject:@"银行卡"];
    }return _headViewTitleMutArr;
}

@end
