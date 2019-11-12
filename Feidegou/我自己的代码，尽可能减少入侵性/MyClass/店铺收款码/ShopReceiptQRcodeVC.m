//
//  ShopReceiptQRcodeVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ShopReceiptQRcodeVC.h"
#import "ShopReceiptQRcodeVC+VM.h"

@interface ShopReceiptQRcodeVC ()
<
TZImagePickerControllerDelegate
>
{}

@property(nonatomic,strong)UIButton *upLoadBtn;
@property(nonatomic,strong)UIImage *img;
@property(nonatomic,weak)TZImagePickerController *imagePickerVC;

@property(nonatomic,assign)int tap;
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
    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.gk_navTitle = @"店铺收款码";
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.upLoadBtn];
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    [self netWorking];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(UIEvent *)event{
    if (![NSString isNullString:self.QRcodeStr]) {
        self.tap++;
        [self QRcode];
    }
}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

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
//跳转系统设置
-(void)pushToSysConfig{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(void)upLoadbtnClickEvent{
    NSLog(@"立即上传");//KKK 没有判断？？
    [self showAlertViewTitle:@"是否确定上传此张图片？"
                     message:@"请再三核对不要选错啦"
                 btnTitleArr:@[@"继续上传",
                               @"我选错啦"]
              alertBtnAction:@[@"GoUploadPic",
                               @"sorry"]];
}

-(void)GoUploadPic{
    [self uploadQRcodePic:self.img];
}

-(void)sorry{
    [self upLoadBtnClickEvent:self.upLoadBtn];
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
                                                          NSArray *assets,
                                                          BOOL isSelectOriginalPhoto) {
            @strongify(self)
            if (photos.count == 1) {
                self.img = photos.lastObject;
                [self upLoadbtnClickEvent];
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
