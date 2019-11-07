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
XDMultTableViewDatasource,
XDMultTableViewDelegate
>

@property(nonatomic,strong)NSMutableArray <NSMutableArray *>*dataMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*headViewTitleMutArr;
@property(nonatomic,strong)NSMutableArray <NSMutableArray *>*placeholderMutArr;
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
    
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    
    self.tableView.alpha = 1;
//    [self netWorking];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableView.mj_header beginRefreshing];
}

#pragma mark —— XDMultTableViewDatasource & XDMultTableViewDelegate
- (NSInteger)mTableView:(XDMultTableView *)mTableView
  numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (XDMultTableViewCell *)mTableView:(XDMultTableView *)mTableView
              cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [mTableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:ReuseIdentifier];
    }
    UIView *view = [[UIView alloc] initWithFrame:cell.bounds] ;
    view.layer.backgroundColor  = [UIColor whiteColor].CGColor;
    view.layer.masksToBounds    = YES;
    view.layer.borderWidth      = 0.3;
    view.layer.borderColor      = [UIColor lightGrayColor].CGColor;
    
    cell.backgroundView = view;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(XDMultTableView *)mTableView{
    return self.dataMutArr.count;
}

-(NSString *)mTableView:(XDMultTableView *)mTableView
titleForHeaderInSection:(NSInteger)section{
    return self.headViewTitleMutArr[section];
}

- (CGFloat)mTableView:(XDMultTableView *)mTableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCALING_RATIO(50);
}

- (CGFloat)mTableView:(XDMultTableView *)mTableView
heightForHeaderInSection:(NSInteger)section{
    return SCALING_RATIO(40);
}

- (void)mTableView:(XDMultTableView *)mTableView
willOpenHeaderAtSection:(NSInteger)section{
    NSLog(@"即将展开");
}

- (void)mTableView:(XDMultTableView *)mTableView
willCloseHeaderAtSection:(NSInteger)section{
    NSLog(@"即将关闭");
}

- (void)mTableView:(XDMultTableView *)mTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击cell");
}
#pragma mark —— lazyLoad
-(XDMultTableView *)tableView{
    if (!_tableView) {
        _tableView = [[XDMultTableView alloc] initWithFrame:CGRectMake(0,
                                                                       self.gk_navigationBar.mj_h,
                                                                       self.view.frame.size.width,
                                                                       self.view.frame.size.height - self.gk_navigationBar.mj_h)];
//        _tableView.openSectionArray = [NSArray arrayWithObjects:@1,@2, nil];
        _tableView.delegate = self;
        _tableView.datasource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.autoAdjustOpenAndClose = NO;
        [self.view addSubview:_tableView];
    }return _tableView;
}

-(NSMutableArray<NSMutableArray *> *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
        [_dataMutArr addObject:[NSMutableArray arrayWithObjects:@"微信账号", nil]];
        [_dataMutArr addObject:[NSMutableArray arrayWithObjects:@"支付宝账号", nil]];
        [_dataMutArr addObject:[NSMutableArray arrayWithObjects:@"银行卡姓名",@"银行卡账号",@"银行卡类型",@"支行信息", nil]];
    }return _dataMutArr;
}

-(NSMutableArray<NSMutableArray *> *)placeholderMutArr{
    if (!_placeholderMutArr) {
        _placeholderMutArr = NSMutableArray.array;
        [_placeholderMutArr addObject:[NSMutableArray arrayWithObjects:@"输入微信账号", nil]];
        [_placeholderMutArr addObject:[NSMutableArray arrayWithObjects:@"输入支付宝账号", nil]];
        [_placeholderMutArr addObject:[NSMutableArray arrayWithObjects:@"输入账户姓名",@"输入银行卡账号",@"输入开户行",@"输入支行信息", nil]];
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
