//
//  UpLoadCancelReasonVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/22.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "UpLoadCancelReasonVC.h"

@interface UpLoadCancelReasonTBVCell ()

@property(nonatomic,strong)MMButton *picBtn;
@property(nonatomic,strong)UIButton *upLoadbtn;

+(instancetype)cellWith:(UITableView *)tableView;
+(CGFloat)cellHeightWithModel:(id _Nullable)model;
- (void)richElementsInCellWithModel:(id _Nullable)model;

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
//    self.picBtn.alpha = 1;
//    self.upLoadbtn.alpha = 1;
    
//    self.backgroundColor = kRedColor;
}

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
@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

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
    self.gk_navTitle = @"上传取消凭证";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.imageView.alpha = 1;
    self.tableView.alpha = 1;
    self.demoPicBtn.alpha = 1;
    self.titleLab.alpha = 1;
    self.tipLab.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    [cell richElementsInCellWithModel:nil];
    return cell;
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
