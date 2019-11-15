//
//  WholesaleOrdersVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/1.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleOrders_VipVC.h"
#import "WholesaleOrders_VipVC+VM.h"

@interface WholesaleOrdersTBVCell ()

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIImageView *imageViewer;

@end
 
@implementation WholesaleOrdersTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    WholesaleOrdersTBVCell *cell = (WholesaleOrdersTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[WholesaleOrdersTBVCell alloc] initWithStyle:UITableViewCellStyleValue1
                                             reuseIdentifier:ReuseIdentifier
                                                      margin:SCALING_RATIO(5)];
        cell.backgroundColor = kClearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    if (model) {
        return SCALING_RATIO(150);
    }return SCALING_RATIO(50);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    if (model) {
        self.titleLab.text = self.textLabel.text;
        self.textLabel.text = @"";
        [self.titleLab sizeToFit];
        [self.imageViewer sd_setImageWithURL:[NSURL URLWithString:model]
                            placeholderImage:kIMG(@"暂无图片")];
        self.accessoryType = UITableViewCellAccessoryNone;
        self.detailTextLabel.text = @"";
    }
}
#pragma mark —— lazyLoad
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(SCALING_RATIO(15));
        }];
    }return _titleLab;
}

-(UIImageView *)imageViewer{
    if (!_imageViewer) {
        _imageViewer = UIImageView.new;
        [UIView cornerCutToCircleWithView:_imageViewer
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_imageViewer
                         WithColour:KGreenColor
                     AndBorderWidth:.1f];
        [self.contentView addSubview:_imageViewer];
        [_imageViewer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(SCALING_RATIO(15));
            make.bottom.equalTo(self.contentView).offset(SCALING_RATIO(-15));
            make.left.equalTo(self.titleLab.mas_right).offset(SCALING_RATIO(15));
            make.right.equalTo(self.contentView).offset(SCALING_RATIO(-15));
        }];
    }return _imageViewer;
}

@end

@interface WholesaleOrders_VipVC ()
<
UITableViewDelegate,
UITableViewDataSource,
TZImagePickerControllerDelegate
>

@property(nonatomic,weak)TZImagePickerController *imagePickerVC;
@property(nonatomic,strong)__block UIImage *img;

//@property(nonatomic,strong)UIButton *uploadPrintBtn;//上传支付凭证


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
    if ([self.requestParams[1] intValue] == 0) {
        self.cancelOrderBtn.alpha = 1;
        self.deliverBtn.alpha = 1;
    }
    self.isFirstComing = YES;
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    [_deliverBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.gk_navigationBar.mj_h +
                                           self.titleMutArr.count * [WholesaleOrdersTBVCell cellHeightWithModel:nil] +
                                           SCALING_RATIO(30));//附加值
    }];
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
    [self netWorking];
}
#pragma mark —— 点击事件
-(void)cancelOrderBtnClickEvent:(UIButton *)sender{
    NSLog(@"取消订单");
    //选择取消原因
}

//-(void)uploadPrintBtnClickEvent:(UIButton *)sender{
//    NSLog(@"选择支付凭证");
//    if ([sender.titleLabel.text isEqualToString:@"选择支付凭证"]) {
//        [self gettingPrintPic];
//    }else if ([sender.titleLabel.text isEqualToString:@"上传支付凭证"]){
//        [self upLoadbtnClickEvent:sender];
//    }
//}

-(void)deliverBtnClickEvent:(UIButton *)sender{
    NSLog(@"发货");
    //发货接口
}

-(void)backBtnClickEvent:(UIButton *)sender{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
    //取消订单
}

-(void)upLoadbtnClickEvent:(UIButton *)sender{
    NSLog(@"立即上传");//KKK 没有判断？？
    [self showAlertViewTitle:@"是否确定上传此张图片？"
                     message:@"请再三核对不要选错啦"
                 btnTitleArr:@[@"继续上传",
                               @"我选错啦"]
              alertBtnAction:@[@"GoUploadPic",
                               @"sorry"]];
}

-(void)GoUploadPic{
    [self uploadPrint_netWorking:self.img];
}

-(void)sorry{
    [self gettingPrintPic];
}

#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6 && [self.requestParams[1] intValue] == 0) {
    return [WholesaleOrdersTBVCell cellHeightWithModel:self.detailTextMutArr.count == 0 ? nil : self.detailTextMutArr[indexPath.row]];
    }return [WholesaleOrdersTBVCell cellHeightWithModel:nil];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.titleMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WholesaleOrdersTBVCell *cell = [WholesaleOrdersTBVCell cellWith:tableView];
    cell.textLabel.text = self.titleMutArr[indexPath.row];
    if (self.detailTextMutArr.count) {
        cell.detailTextLabel.text = self.detailTextMutArr[indexPath.row];
    }
    if ([self.requestParams[1] intValue] == 0) {
        if (indexPath.row == 6) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (self.detailTextMutArr.count) {
                [cell richElementsInCellWithModel:self.detailTextMutArr[indexPath.row]];//self.img
            }
        }
    }
    [cell richElementsInCellWithModel:Nil];
    return cell;
}

-(void)gettingPrintPic{
    @weakify(self)
    [ECAuthorizationTools checkAndRequestAccessForType:ECPrivacyType_Photos
                                          accessStatus:^(ECAuthorizationStatus status,
                                                         ECPrivacyType type) {
        @strongify(self)
        // status 即为权限状态，
        //状态类型参考：ECAuthorizationStatus
        NSLog(@"%lu",(unsigned long)status);
        if (status == ECAuthorizationStatus_Authorized) {
            [self presentViewController:self_weak_.imagePickerVC
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
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6) {
        [self gettingPrintPic];
    }
}

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
        self.isFirstComing = NO;
    }
}
#pragma mark —— lazyLoad
-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = UIImageView.new;
        [self.tableView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(SCALING_RATIO(50));
            make.right.equalTo(self.view).offset(SCALING_RATIO(-50));
            make.height.mas_equalTo(SCALING_RATIO(150));
            make.top.equalTo(self.view).offset(self.gk_navigationBar.mj_h +
                                               (self.titleMutArr.count - 1) * [WholesaleOrdersTBVCell cellHeightWithModel:nil] +
                                               [WholesaleOrdersTBVCell cellHeightWithModel:nil] +
                                               0);//附加值
        }];
    }return _imgView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                     style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.mj_footer.hidden = YES;
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
//                upLoadbtnClickEvent
                [self.tableView reloadData];
                self.img = photos.lastObject;
                if ([self.requestParams[1] intValue] == 0) {
                    [self.deliverBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.view).offset(self.gk_navigationBar.mj_h +
                                                           (self.titleMutArr.count - 1) * [WholesaleOrdersTBVCell cellHeightWithModel:nil] +
                                                           [WholesaleOrdersTBVCell cellHeightWithModel:self.img] +
                                                           SCALING_RATIO(30));//附加值
                    }];
                    self.deliverBtn.alpha = 1;
                }else if ([self.requestParams[1] intValue] == 2){
                    self.imgView.image = photos.lastObject;
                }else{}
            }else{
                [self showAlertViewTitle:@"选择一张相片就够啦"
                                 message:@"不要画蛇添足"
                             btnTitleArr:@[@"好的"]
                          alertBtnAction:@[@"OK"]];
            }
        }];
    }return _imagePickerVC;
}

-(UIButton *)deliverBtn{
    if (!_deliverBtn) {
        _deliverBtn = UIButton.new;
        _deliverBtn.backgroundColor = kOrangeColor;
        [_deliverBtn addTarget:self
                        action:@selector(deliverBtnClickEvent:)
              forControlEvents:UIControlEventTouchUpInside];
        [_deliverBtn setTitle:@"发货"
                     forState:UIControlStateNormal];
        [UIView cornerCutToCircleWithView:_deliverBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_deliverBtn
                         WithColour:KGreenColor
                     AndBorderWidth:.1f];
        [self.tableView addSubview:_deliverBtn];
        [_deliverBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(self.gk_navigationBar.mj_h +
                                               (self.titleMutArr.count - 1) * [WholesaleOrdersTBVCell cellHeightWithModel:nil] +
                                               [WholesaleOrdersTBVCell cellHeightWithModel:self.img] +
                                               SCALING_RATIO(30));//附加值
            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - SCALING_RATIO(100)) / 2,
                                             SCALING_RATIO(50)));
            make.right.equalTo(self.view).offset(SCALING_RATIO(-30));
        }];
    }return _deliverBtn;
}

-(UIButton *)cancelOrderBtn{
    if (!_cancelOrderBtn) {
        _cancelOrderBtn = UIButton.new;
        _cancelOrderBtn.backgroundColor = KLightGrayColor;
        [_cancelOrderBtn setTitle:@"撤销订单"
                         forState:UIControlStateNormal];
        [_cancelOrderBtn addTarget:self
                            action:@selector(cancelOrderBtnClickEvent:)
                  forControlEvents:UIControlEventTouchUpInside];
        [UIView cornerCutToCircleWithView:_cancelOrderBtn
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:_cancelOrderBtn
                         WithColour:KGreenColor
                     AndBorderWidth:.1f];
        [self.tableView addSubview:_cancelOrderBtn];
        [_cancelOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(self.gk_navigationBar.mj_h +
                                               (self.titleMutArr.count - 1) * [WholesaleOrdersTBVCell cellHeightWithModel:nil] +
                                               [WholesaleOrdersTBVCell cellHeightWithModel:self.img] +
                                               SCALING_RATIO(30));//附加值
            make.size.mas_equalTo(CGSizeMake((SCREEN_WIDTH - SCALING_RATIO(100)) / 2,
                                             SCALING_RATIO(50)));
            make.left.equalTo(self.view).offset(SCALING_RATIO(30));
        }];
    }return _cancelOrderBtn;
}

-(NSMutableArray<NSString *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:@"订单号"];
        [_titleMutArr addObject:@"数量"];
        [_titleMutArr addObject:@"单价"];
        [_titleMutArr addObject:@"总额"];
        [_titleMutArr addObject:@"支付方式"];
        [_titleMutArr addObject:@"付款账户"];
        if ([self.requestParams[1] intValue] == 0) {
            [_titleMutArr addObject:@"凭证"];
        }
        [_titleMutArr addObject:@"状态"];//已付款/已完成/待购
    }return _titleMutArr;
}

-(NSMutableArray<NSString *> *)detailTextMutArr{
    if (!_detailTextMutArr) {
        _detailTextMutArr = NSMutableArray.array;
    }return _detailTextMutArr;
}

@end
