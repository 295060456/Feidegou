//
//  WholesaleOrders_AdvanceVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/1.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleOrders_AdvanceVC.h"
#import "WholesaleMarket_AdvanceVC.h"

@interface WholesaleOrders_AdvanceVC ()
<
UITableViewDelegate,
UITableViewDataSource,
TZImagePickerControllerDelegate
>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,weak)TZImagePickerController *imagePickerVC;
@property(nonatomic,strong)UIButton *paidBtn;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;
@property(nonatomic,strong)__block UIImage *img;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation WholesaleOrders_AdvanceVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    WholesaleOrders_AdvanceVC *vc = WholesaleOrders_AdvanceVC.new;
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
    self.gk_navTitle = @"喵粮批发订单";
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.tableView.alpha = 1;
    self.paidBtn.alpha = 1;
    self.cancelBtn.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
#pragma mark —— 私有方法
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
                
    //            [self presentViewController:TestVC.new
    //                               animated:YES
    //                             completion:Nil];

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
            [[WholesaleMarket_AdvancePopView shareManager] removeFromSuperview];
            WholesaleMarket_AdvancePopView *wholesaleMarket_AdvancePopView = [WholesaleMarket_AdvancePopView shareManager];
            wholesaleMarket_AdvancePopView = nil;
        }
    }
}

-(void)cancelBtnClickEvent:(UIButton *)sender{
    NSLog(@"取消");
}

-(void)backBtnClickEvent:(UIButton *)sender{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
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
        cell.detailTextLabel.text = @"temp";
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"喵粮";
        }
    }return cell;
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
                                                     style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
                self.img = photos.lastObject;//拿到值
                [self.paidBtn setTitle:@"已付款"
                              forState:UIControlStateNormal];
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
    
@end
