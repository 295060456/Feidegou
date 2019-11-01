//
//  WholesaleOrdersVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/1.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "WholesaleOrdersVC.h"

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
//        [UIView cornerCutToCircleWithView:cell.contentView
//                          AndCornerRadius:5.f];
//        [UIView colourToLayerOfView:cell.contentView
//                         WithColour:KGreenColor
//                     AndBorderWidth:.1f];
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
        self.imageViewer.image = (UIImage *)model;
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

@interface WholesaleOrdersVC ()
<
UITableViewDelegate,
UITableViewDataSource,
TZImagePickerControllerDelegate
>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,weak)TZImagePickerController *imagePickerVC;
@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;
@property(nonatomic,strong)__block UIImage *img;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;

@end

@implementation WholesaleOrdersVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    WholesaleOrdersVC *vc = WholesaleOrdersVC.new;
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
    self.isFirstComing = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
#pragma mark —— 私有方法
-(void)backBtnClickEvent:(UIButton *)sender{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6) {
        return [WholesaleOrdersTBVCell cellHeightWithModel:self.img];
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
    if (indexPath.row == 6) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = @"点击选择凭证(原图)";
        [cell richElementsInCellWithModel:self.img];
    }else{
        [cell richElementsInCellWithModel:Nil];
    }return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6) {
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
                [self.tableView reloadData];
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
        [_titleMutArr addObject:@"订单号"];
        [_titleMutArr addObject:@"数量"];
        [_titleMutArr addObject:@"单价"];
        [_titleMutArr addObject:@"总额"];
        [_titleMutArr addObject:@"支付方式"];
        [_titleMutArr addObject:@"付款账户"];
        [_titleMutArr addObject:@"凭证"];
    }return _titleMutArr;
}

@end
