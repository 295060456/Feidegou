//
//  ShopReceiptQRcodeVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ShopReceiptQRcodeVC.h"

@interface ShopReceiptQRcodeVC ()
<TZImagePickerControllerDelegate>

@property(nonatomic,strong)UIImageView *QRcodeIMGV;
@property(nonatomic,strong)TZImagePickerController *imagePickerVC;
@property(nonatomic,assign)int tap;
@property(nonatomic,copy)NSString *QRcodeStr;

//Q宠
@property(nonatomic,strong)Q_Pet *pet;
@property(nonatomic,strong)UIButton *upLoadBtn;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;


@end

@implementation ShopReceiptQRcodeVC
- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(nullable id)requestParams
                   success:(DataBlock)block
                  animated:(BOOL)animated{

    ShopReceiptQRcodeVC *vc = ShopReceiptQRcodeVC.new;
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
        self.tap = 0;
        self.QRcodeStr = @"https://github.com/KeenTeam1990/SGQRCode.git";
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navTitle = @"店铺收款码";
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.upLoadBtn];
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    [self QRcode];
    self.pet.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.pet hide];
    [self.pet.laAnimation removeFromSuperview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(UIEvent *)event{
    self.tap++;
    [self QRcode];
}
#pragma mark —— 点击事件
-(void)upLoadBtnClickEvent:(UIButton *)sender{
    NSLog(@"上传二维码");
    @weakify(self)
    [ECAuthorizationTools checkAndRequestAccessForType:ECPrivacyType_Photos
                                          accessStatus:^(ECAuthorizationStatus status,
                                                         ECPrivacyType type) {
        @strongify(self)
        // status 即为权限状态，
        //状态类型参考：ECAuthorizationStatus
        NSLog(@"%lu",(unsigned long)status);
        if (status == ECAuthorizationStatus_Authorized) {
//            self.isOpenMicrophone = YES;
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
}

//跳转系统设置
-(void)pushToSysConfig{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)QRcode{
    NSLog(@"A = %d",self.tap);
    NSLog(@"B = %d",self.tap % 4);
    switch (self.tap % 4) {
            
        case 0:{
            self.QRcodeIMGV.image = [SGQRCodeObtain generateQRCodeWithData:self.QRcodeStr
                                                                      size:SCREEN_WIDTH / 2
                                                                     color:kRedColor
                                                           backgroundColor:KYellowColor];
        }break;
        case 1:{
            self.QRcodeIMGV.image = [SGQRCodeObtain generateQRCodeWithData:self.QRcodeStr
                                                                      size:SCREEN_WIDTH / 2
                                                                 logoImage:kIMG(@"喵猫")
                                                                     ratio:5];
        }break;
        case 2:{
            self.QRcodeIMGV.image = [SGQRCodeObtain generateQRCodeWithData:@"https://github.com/KeenTeam1990/SGQRCode.git"
                                                                      size:SCREEN_WIDTH / 2];
        }break;
        case 3:{
            self.QRcodeIMGV.image = [SGQRCodeObtain generateQRCodeWithData:self.QRcodeStr
                                                                      size:SCREEN_WIDTH / 2
                                                                 logoImage:kIMG(@"喵猫")
                                                                     ratio:5
                                                     logoImageCornerRadius:5
                                                      logoImageBorderWidth:5
                                                      logoImageBorderColor:KLightGrayColor];
        }break;
        default:
            break;
    }
}

#pragma mark —— lazyLoad
-(UIImageView *)QRcodeIMGV{
    if (!_QRcodeIMGV) {
        _QRcodeIMGV = UIImageView.new;
        [self.view addSubview:_QRcodeIMGV];
        [_QRcodeIMGV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2,
                                             SCREEN_WIDTH / 2));
        }];
    }return _QRcodeIMGV;
}

-(Q_Pet *)pet{
    if (!_pet) {
        _pet = [[Q_Pet alloc]initWithFrame:CGRectMake(100,
                                                      100,
                                                      100,
                                                      100)];
        _pet.autoCloseEdge = YES;
        [_pet show];
    }return _pet;
}

-(UIButton *)upLoadBtn{
    if (!_upLoadBtn) {
        _upLoadBtn = UIButton.new;
        [_upLoadBtn setImage:kIMG(@"上传")
                    forState:UIControlStateNormal];
        [_upLoadBtn addTarget:self
                       action:@selector(upLoadBtnClickEvent:)
             forControlEvents:UIControlEventTouchUpInside];
    }return _upLoadBtn;
}

-(TZImagePickerController *)imagePickerVC{
    if (!_imagePickerVC) {
        _imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9
                                                                        delegate:self];
        @weakify(self)
        [_imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos,
                                                          NSArray *assets, BOOL isSelectOriginalPhoto) {
            @strongify(self)
            if (photos.count == 1) {
//                UIImageView *imgv = [[UIImageView alloc]initWithImage:photos.lastObject];
//                [self.view addSubview:imgv];
//                imgv.frame = CGRectMake(100, 100, 100, 100);
            }else{
                [self showAlertViewTitle:@"选择一张相片就够啦"
                                 message:@"不要画蛇添足"
                             btnTitleArr:@[@"好的"]
                          alertBtnAction:@[@"OK"]];
            }
        }];
    }return _imagePickerVC;
}

-(void)OK{
    NSLog(@"OK");
}


@end
