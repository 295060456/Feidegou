//
//  UpLoadCancelReasonVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/22.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "UpLoadCancelReasonVC.h"
#import "SamplePicVC.h"
#import "UpLoadCancelReasonVC+VM.h"

@interface UpLoadCancelReasonTBVCell ()

@property(nonatomic,strong)MMButton *picBtn;
@property(nonatomic,strong)UIButton *upLoadbtn;
@property(nonatomic,strong)UIImageView *IMGV;
@property(nonatomic,copy)DataBlock picBtnBlock;
@property(nonatomic,copy)DataBlock upLoadbtnBlock;

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

@end

@interface UpLoadCancelReasonVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UIButton *demoPicBtn;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *tipLab;
@property(nonatomic,strong)UILabel *titleLab;

@property(nonatomic,strong)NSMutableArray <NSString *>*tipsMutArr;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,strong)__block UIImage *img;

@end

@implementation UpLoadCancelReasonVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated{
    UpLoadCancelReasonVC *vc = UpLoadCancelReasonVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    if ([requestParams isKindOfClass:[OrderListModel class]]) {
        vc.orderListModel = (OrderListModel *)requestParams;
    }else{}
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.imageView.alpha = 1;
    self.tableView.alpha = 1;
    self.demoPicBtn.alpha = 1;
    self.titleLab.alpha = 1;
    self.tipLab.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.gk_navTitle = @"上传凭证";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)DemoPicBtnClickEvent:(UIButton *)sender{
    NSLog(@"显示示例图");
    @weakify(self)
    [SamplePicVC pushFromVC:self_weak_
              requestParams:nil
                    success:^(id data) {}
                   animated:YES];
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
//    [self CancelDelivery_NetWorking];//#5
    if ([self.orderListModel.order_type intValue] == 3) {
        if ([self.orderListModel.order_status intValue] == 2 ||
            [self.orderListModel.order_status intValue] == 0) {
            //#8
            [self uploadPic_producingArea_havePaid_netWorking:self.img];
        }
    }else if ([self.orderListModel.order_type intValue] == 2){
        if ([self.orderListModel.identity isEqualToString:@"买家"]) {
            if ([self.orderListModel.order_status intValue] == 0) {
                //#17
                [self upLoadPic_wholesaleMarket_havePaid_netWorking:self.img];
            }
        }
    }else{}
}

-(void)sorry{
    [self picBtnClickEvent:Nil];
}

-(void)picBtnClickEvent:(UIButton *)sender{
    NSLog(@"相册");
    [self choosePic];
    @weakify(self)
    [self GettingPicBlock:^(id data) {
        @strongify(self)
        if ([data isKindOfClass:[NSArray class]]) {
            NSArray *arrData = (NSArray *)data;
            if (arrData.count == 1) {
                [self.cell reloadPicBtnIMG:arrData.lastObject];
                self.pic = arrData.lastObject;
            }else{
                [self showAlertViewTitle:@"选择一张相片就够啦"
                       message:@"不要画蛇添足"
                   btnTitleArr:@[@"好的"]
                alertBtnAction:@[@"OK"]];
            }
        }
    }];
}

-(void)OK{
    NSLog(@"OK");
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT / 2;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    return;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UpLoadCancelReasonTBVCell *cell = [UpLoadCancelReasonTBVCell cellWith:tableView];
    self.cell = cell;
    [cell richElementsInCellWithModel:nil];
    @weakify(self)
    [cell actionPicBtnBlock:^(id data) {
        @strongify(self)
        UIButton *btn = (UIButton *)data;
        [self picBtnClickEvent:btn];
    }];
    [cell actionUpLoadbtnBlock:^(id data) {
        @strongify(self)
        UIButton *btn = (UIButton *)data;
        [self upLoadbtnClickEvent:btn];
    }];return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark —— lazyLoad
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = UIImageView.new;
        _imageView.backgroundColor = COLOR_HEX(0x4870EF, 1);
        [self.view addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(SCALING_RATIO(150));
        }];
    }return _imageView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.backgroundColor = kClearColor;
        [_tableView setContentInset:UIEdgeInsetsMake(80,
                                                     0,
                                                     0,
                                                     0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = UIView.new;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
        }];
    }return _tableView;
}

-(UIButton *)demoPicBtn{
    if (!_demoPicBtn) {
        _demoPicBtn = UIButton.new;
        [_demoPicBtn sizeToFit];
        [_demoPicBtn.titleLabel adjustsFontSizeToFitWidth];
        _demoPicBtn.backgroundColor = COLOR_HEX(0xFFFFFF, 1);
        [_demoPicBtn setTitleColor:COLOR_HEX(0x4870EF, 1)
                          forState:UIControlStateNormal];
        [_demoPicBtn setTitle:@"    示例图   "
                     forState:UIControlStateNormal];
        [_demoPicBtn addTarget:self
                        action:@selector(DemoPicBtnClickEvent:)
              forControlEvents:UIControlEventTouchUpInside];
        [self.imageView addSubview:_demoPicBtn];
        [_demoPicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.imageView);
            make.top.equalTo(self.imageView).offset(SCALING_RATIO(20));
        }];
        [self.view layoutIfNeeded];
        [UIView appointCornerCutToCircleWithTargetView:_demoPicBtn
                                           cornerRadii:CGSizeMake(SCALING_RATIO(20),
                                                                  SCALING_RATIO(20))
                                  TargetCorner_TopLeft:UIRectCornerTopLeft
                                 TargetCorner_TopRight:4
                               TargetCorner_BottomLeft:UIRectCornerBottomLeft
                              TargetCorner_BottomRight:4];
    }return _demoPicBtn;
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = UILabel.new;
        _titleLab.text = @"上传截图";
        _titleLab.textColor = COLOR_HEX(0xFFFFFF, 1);
        [self.imageView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.imageView);
            make.centerY.equalTo(self.imageView.mas_centerY).offset(SCALING_RATIO(-20));
        }];
    }return _titleLab;
}

-(UILabel *)tipLab{
    if (!_tipLab) {
        _tipLab = UILabel.new;
        _tipLab.numberOfLines = 0;
        _tipLab.textColor = KLightGrayColor;
        _tipLab.font = kFontSize(10);
        NSString *str = @"";//前
        NSString *resultStr = @"";
        for (int i = 0; i < self.tipsMutArr.count; i++) {
            str = [NSString stringWithFormat:@" * %@ \n ",self.tipsMutArr[i]];
            resultStr = [resultStr stringByAppendingString:str];
        }
        NSLog(@"%@",resultStr);
        _tipLab.text = resultStr;
        [self.view addSubview:_tipLab];
        [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(isiPhoneX_series() ? SCALING_RATIO(-80) : SCALING_RATIO(-50));
        }];
    }return _tipLab;
}

-(NSMutableArray<NSString *> *)tipsMutArr{
    if (!_tipsMutArr) {
        _tipsMutArr = NSMutableArray.array;
        [_tipsMutArr addObject:@"请上传您截取的图片，上传时请传原图"];
        [_tipsMutArr addObject:@"当日上传图片错误次数不可以超过三次"];
        [_tipsMutArr addObject:@"同笔账单切勿重复上传，若造成资金损失，平台概不负责"];
    }return _tipsMutArr;
}

@end

@implementation UpLoadCancelReasonTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    UpLoadCancelReasonTBVCell *cell = (UpLoadCancelReasonTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[UpLoadCancelReasonTBVCell alloc]initWithStyle:UITableViewCellStyleValue1
                                               reuseIdentifier:ReuseIdentifier
                                                        margin:SCALING_RATIO(10)];
        [UIView cornerCutToCircleWithView:cell
                          AndCornerRadius:10.f];
        [UIView colourToLayerOfView:cell
                         WithColour:kWhiteColor
                     AndBorderWidth:0.3f];
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCREEN_HEIGHT / 2;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    self.picBtn.alpha = 1;
    self.upLoadbtn.alpha = 1;

}

-(void)reloadPicBtnIMG:(UIImage *)IMG{
    [self.IMGV setImage:IMG];
    [self.picBtn setImage:kIMG(@"透明图标")
                 forState:UIControlStateNormal];
}

-(void)actionPicBtnBlock:(DataBlock)block{
    _picBtnBlock = block;
}

-(void)actionUpLoadbtnBlock:(DataBlock)block{
    _upLoadbtnBlock = block;
}

#pragma mark —— 点击事件
-(void)upLoadbtnClickEvent:(UIButton *)sender{
//    NSLog(@"上传");
    if (_upLoadbtnBlock) {
        _upLoadbtnBlock(sender);
    }
}

-(void)picBtnClickEvent:(UIButton *)sender{
//    NSLog(@"相册");
    if (_picBtnBlock) {
        _picBtnBlock(sender);
    }
}

#pragma mark —— lazyLoad
-(MMButton *)picBtn{
    if (!_picBtn) {
        _picBtn = MMButton.new;
        [_picBtn setImage:kIMG(@"相册")
                 forState:UIControlStateNormal];
        [_picBtn addTarget:self
                    action:@selector(picBtnClickEvent:)
          forControlEvents:UIControlEventTouchUpInside];
        _picBtn.imageAlignment = MMImageAlignmentTop;
        _picBtn.spaceBetweenTitleAndImage = SCALING_RATIO(30);
        [_picBtn setTitleColor:COLOR_HEX(0x7D7D7D, 1)
                      forState:UIControlStateNormal];
        [_picBtn setTitle:@"上传图片必须为原图"
                 forState:UIControlStateNormal];
        [self.contentView addSubview:_picBtn];
        [_picBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }return _picBtn;
}

-(UIButton *)upLoadbtn{
    if (!_upLoadbtn) {
        _upLoadbtn = UIButton.new;
        _upLoadbtn.backgroundColor = COLOR_HEX(0x4870EF, 1);
        [_upLoadbtn addTarget:self
                       action:@selector(upLoadbtnClickEvent:)
             forControlEvents:UIControlEventTouchUpInside];
        [_upLoadbtn setTitleColor:kWhiteColor
                         forState:UIControlStateNormal];
        [_upLoadbtn setTitle:@"立即上传"
                    forState:UIControlStateNormal];
        [self.contentView addSubview:_upLoadbtn];
        [_upLoadbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.height.mas_equalTo(SCALING_RATIO(50));
            make.bottom.equalTo(self.contentView).offset(SCALING_RATIO(-25));
            make.width.mas_equalTo(SCREEN_WIDTH - SCALING_RATIO(100));
        }];
        [self.contentView layoutIfNeeded];
        [UIView appointCornerCutToCircleWithTargetView:_upLoadbtn
                                           cornerRadii:CGSizeMake(SCALING_RATIO(20),
                                                                  SCALING_RATIO(20))
                                  TargetCorner_TopLeft:UIRectCornerTopLeft
                                 TargetCorner_TopRight:UIRectCornerTopRight
                               TargetCorner_BottomLeft:UIRectCornerBottomLeft
                              TargetCorner_BottomRight:UIRectCornerBottomRight];
    }return _upLoadbtn;
}

-(UIImageView *)IMGV{
    if (!_IMGV) {
        _IMGV = UIImageView.new;
        [self.contentView addSubview:_IMGV];
        [_IMGV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.upLoadbtn.mas_top).offset(SCALING_RATIO(-50));
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 1.5,
                                             SCREEN_WIDTH / 2));
        }];
    }return _IMGV;
}

@end
