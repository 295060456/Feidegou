//
//  ShopReceiptQRcodeVC.m
//  Feidegou
//
//  Created by Kite on 2019/10/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "ShopReceiptQRcodeVC.h"

@interface ShopReceiptQRcodeVC ()

@property(nonatomic,strong)UIImageView *QRcodeIMGV;
@property(nonatomic,assign)int tap;
@property(nonatomic,copy)NSString *QRcodeStr;

//Q宠
@property(nonatomic,strong)Q_Pet *pet;

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    [self QRcode];
    self.pet.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(UIEvent *)event{
    self.tap++;
    [self QRcode];
}

-(void)QRcode{
    
    NSLog(@"A = %d",self.tap);
    NSLog(@"B = %d",self.tap % 4);
    
    
    switch (self.tap % 4) {
            
        case 0:{
//            NSLog(@"0");
            self.QRcodeIMGV.image = [SGQRCodeObtain generateQRCodeWithData:self.QRcodeStr
                                                                      size:SCREEN_WIDTH / 2
                                                                     color:kRedColor
                                                           backgroundColor:KYellowColor];
        }break;
        case 1:{
//            NSLog(@"1");
            self.QRcodeIMGV.image = [SGQRCodeObtain generateQRCodeWithData:self.QRcodeStr
                                                                      size:SCREEN_WIDTH / 2
                                                                 logoImage:kIMG(@"喵猫")
                                                                     ratio:5];
        }break;
        case 2:{
//            NSLog(@"2");
            self.QRcodeIMGV.image = [SGQRCodeObtain generateQRCodeWithData:@"https://github.com/KeenTeam1990/SGQRCode.git"
                                                                      size:SCREEN_WIDTH / 2];
        }break;
        case 3:{
//            NSLog(@"3");
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
//        [_pet setContent:kIMG(@"新机器猫")
//             contentType:MISFloatingBallContentTypeImage];
        [_pet show];
    }return _pet;
}

@end
