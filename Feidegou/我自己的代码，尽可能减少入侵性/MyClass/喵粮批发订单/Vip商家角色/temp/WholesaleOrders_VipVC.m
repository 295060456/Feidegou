//
//  WholesaleOrders_VipVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/13.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleOrders_VipVC.h"
#import "WholesaleMarket_AdvanceVC.h"
#import "WholesaleOrders_VipVC+VM.h"

@interface WholesaleOrders_VipVC ()

<
UITableViewDelegate,
UITableViewDataSource,
TZImagePickerControllerDelegate
>

@property(nonatomic,weak)TZImagePickerController *imagePickerVC;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;
@property(nonatomic,strong)__block UIImage *img;

@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;

@end

@implementation WholesaleOrders_VipVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    WholesaleOrders_VipVC *vc = WholesaleOrders_VipVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;//购买的数量、付款的方式、订单ID
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
    self.gk_navTitle = @"喵粮批发购买订单";
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.paidBtn.alpha = 1;
    self.cancelBtn.alpha = 1;
    self.isFirstComing = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark —— 截取返回手势
- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
    if(!parent){
      NSLog(@"页面pop成功了");
        [self removeWholesaleMarket_AdvancePopView];
    }
}
#pragma mark —— 私有方法
// 下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    [self netWorking];
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
   [self.tableView.mj_footer endRefreshing];
}
#pragma mark —— 点击事件
-(void)paidBtnClickEvent:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"上传付款凭证"]) {
        NSLog(@"上传付款凭证");
        @weakify(self)
        [ECAuthorizationTools checkAndRequestAccessForType:ECPrivacyType_Photos
                                              accessStatus:^(ECAuthorizationStatus status,
                                                             ECPrivacyType type) {
            @strongify(self)
            // status 即为权限状态，
            //状态类型参考：ECAuthorizationStatus
            NSLog(@"%lu",(unsigned long)status);
            if (status == ECAuthorizationStatus_Authorized) {
                [self presentViewController:self.imagePickerVC
                                         animated:YES
                                       completion:nil];
            }else{
                NSLog(@"相册不可用:%lu",(unsigned long)status);
                [self showAlertViewTitle:@"获取相册权限"
                                       message:@""
                                   btnTitleArr:@[@"去获取"]
                                alertBtnAction:@[@"pushToSysConfig"]];
            }
        }];
    }else if ([sender.titleLabel.text isEqualToString:@"已付款"]){
        if (self.img) {
            NSLog(@"网络请求 传 self.img");
            [self.navigationController popViewControllerAnimated:YES];
            [self removeWholesaleMarket_AdvancePopView];
        }
    }
}

-(void)cancelBtnClickEvent:(UIButton *)sender{
    NSLog(@"取消");
    [self.navigationController popViewControllerAnimated:YES];
    [self removeWholesaleMarket_AdvancePopView];
}

-(void)backBtnClickEvent:(UIButton *)sender{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
    [self removeWholesaleMarket_AdvancePopView];
}
//取消状态走的方法
-(void)removeWholesaleMarket_AdvancePopView{
    WholesaleMarket_AdvancePopView *wholesaleMarket_AdvancePopView = [WholesaleMarket_AdvancePopView shareManager];
    [wholesaleMarket_AdvancePopView removeFromSuperview];
    wholesaleMarket_AdvancePopView = Nil;
    [self cancelOrder_netWorking];
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCALING_RATIO(30);
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.titleMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:ReuseIdentifier];
        cell.backgroundColor = kClearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.titleMutArr[indexPath.row];
    }
    cell.detailTextLabel.text = self.dataArr.count != 0 ? self.dataArr[indexPath.row] :@"";
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//给cell添加动画
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isFirstComing) {
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
    self.isFirstComing = NO;
}
#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                     style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.tableFooterView = UIView.new;
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//推荐该方法
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }return _tableView;
}

-(UIButton *)paidBtn{
    if (!_paidBtn) {
        _paidBtn = UIButton.new;
        _paidBtn.backgroundColor = kOrangeColor;
        [_paidBtn setTitle:@"上传付款凭证"
                    forState:UIControlStateNormal];
        [_paidBtn addTarget:self
                     action:@selector(paidBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
        [UIView cornerCutToCircleWithView:_paidBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_paidBtn
                         WithColour:KGreenColor
                     AndBorderWidth:.1f];
        [self.view addSubview:_paidBtn];
        [_paidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SCALING_RATIO(100),
                                             SCALING_RATIO(50)));
            make.top.equalTo(self.view).offset(self.gk_navigationBar.mj_h +
                                               self.titleMutArr.count * SCALING_RATIO(30) +
                                               SCALING_RATIO(50));
        }];
    }return _paidBtn;
}

-(UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = UIButton.new;
        _cancelBtn.backgroundColor = KLightGrayColor;
        [_cancelBtn setTitle:@"取消"
                    forState:UIControlStateNormal];
        [_cancelBtn addTarget:self
                       action:@selector(cancelBtnClickEvent:)
             forControlEvents:UIControlEventTouchUpInside];
        [UIView cornerCutToCircleWithView:_cancelBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_cancelBtn
                         WithColour:KGreenColor
                     AndBorderWidth:.1f];
        [self.view addSubview:_cancelBtn];
        [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - SCALING_RATIO(100),
                                             SCALING_RATIO(50)));
            make.top.equalTo(self.paidBtn.mas_bottom).offset(SCALING_RATIO(10));
        }];
    }return _cancelBtn;
}

-(void)prepareToUploadPic{
    [self showAlertViewTitle:@"是否确定上传此张图片？"
                     message:@"请再三核对不要选错啦"
                 btnTitleArr:@[@"继续上传",
                               @"我选错啦"]
              alertBtnAction:@[@"GoUploadPic",
                               @"sorry"]];
}

-(void)GoUploadPic{
    [self upLoadPic_netWorking:self.img];
}

-(void)sorry{
    [self paidBtnClickEvent:self.paidBtn];
}

-(TZImagePickerController *)imagePickerVC{
    if (!_imagePickerVC) {
        _imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9
                                                                        delegate:self];
        @weakify(self)
        [_imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,
                                                          NSArray *assets,
                                                          BOOL isSelectOriginalPhoto) {
            @strongify(self)
            if (photos.count == 1) {
                self.img = photos.lastObject;
                [self prepareToUploadPic];
            }else{
                [self showAlertViewTitle:@"选择一张相片就够啦"
                                 message:@"不要画蛇添足"
                             btnTitleArr:@[@"好的"]
                          alertBtnAction:@[@"OK"]];
            }
        }];
    }return _imagePickerVC;
}

-(NSMutableArray<NSString *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:@"商品"];
        [_titleMutArr addObject:@"数量"];
        [_titleMutArr addObject:@"单价"];
        [_titleMutArr addObject:@"总额"];
        [_titleMutArr addObject:@"支付方式"];
        [_titleMutArr addObject:@"状态"];
    }return _titleMutArr;
}

-(NSMutableArray<NSString *> *)dataArr{
    if (!_dataArr) {
        _dataArr = NSMutableArray.array;
    }return _dataArr;
}

@end
