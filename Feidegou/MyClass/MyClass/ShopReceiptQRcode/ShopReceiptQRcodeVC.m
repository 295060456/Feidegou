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
UIScrollViewDelegate
>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UILabel *wechatPayLab;
@property(nonatomic,strong)UILabel *alipayLab;
@property(nonatomic,strong)UILabel *wechatPayTipsLab;
@property(nonatomic,strong)UILabel *alipayTipsLab;
@property(nonatomic,strong)UIButton *upLoadBtn;
@property(nonatomic,strong)__block UIImage *img;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation ShopReceiptQRcodeVC
- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    ShopReceiptQRcodeVC *vc = ShopReceiptQRcodeVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    switch (comingStyle) {
        case ComingStyle_PUSH:{
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
            }
        }break;
        case ComingStyle_PRESENT:{
            vc.isPush = NO;
            vc.isPresent = YES;
            [rootVC presentViewController:vc
                                 animated:animated
                               completion:^{}];
        }break;
        default:
            NSLog(@"错误的推进方式");
            break;
    }return vc;
}
#pragma mark - Lifecycle
-(instancetype)init{
    if (self = [super init]) {

    }return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.gk_navTitle = @"店铺收款码";
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    
    self.scrollView.alpha = 1;
    self.wechatPayLab.alpha = 1;
    self.qrCodeIMGV_wechatPay.alpha = 1;
    self.alipayLab.alpha = 1;
    self.qrCodeIMGV_alipay.alpha = 1;
    
    extern NSString *alipay_qr_img;//支付宝收款二维码
    extern NSString *weixin_qr_img;//微信收款二维码
    if ([alipay_qr_img isEqualToString:@"-1"]) {
        self.alipayTipsLab.alpha = 1;
    }else if ([weixin_qr_img isEqualToString:@"-1"]){
        self.wechatPayTipsLab.alpha = 1;
    }
    [self netWorking];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark —— 内部方法
-(void)wechatPay{
    @weakify(self)
    [self choosePic];
    [self GettingPicBlock:^(id data) {
        @strongify(self)
        if ([data isKindOfClass:[NSArray class]]) {
            NSArray *arrData = (NSArray *)data;
            if (arrData.count == 1) {
                self.img = arrData.lastObject;
                [self showAlertViewTitle:@"是否确定上传此张微信二维码图片？"
                                 message:@"请再三核对不要选错啦"
                             btnTitleArr:@[@"继续上传",
                                           @"我选错啦"]
                          alertBtnAction:@[@"GoUploadPic_wechatPay",
                                           @"sorry_wechatPay"]];
            }
        }
    }];
}

-(void)aliPay{
    @weakify(self)
    [self choosePic];
    [self GettingPicBlock:^(id data) {
        @strongify(self)
        if ([data isKindOfClass:[NSArray class]]) {
            NSArray *arrData = (NSArray *)data;
            if (arrData.count == 1) {
                self.img = arrData.lastObject;
                [self showAlertViewTitle:@"是否确定上传此张支付宝二维码图片？"
                                 message:@"请再三核对不要选错啦"
                             btnTitleArr:@[@"继续上传",
                                           @"我选错啦"]
                          alertBtnAction:@[@"GoUploadPic_alipay",
                                           @"sorry_alipay"]];
            }
        }
    }];
}

-(void)GoUploadPic_wechatPay{
    [self uploadQRcodePic:self.img
                withStyle:PaywayTypeWX];//微信
}

-(void)GoUploadPic_alipay{
    [self uploadQRcodePic:self.img
                withStyle:PaywayTypeZFB];//微信
}

-(void)sorry_wechatPay{
    [self wechatPay];
}

-(void)sorry_alipay{
    [self aliPay];
}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark —— UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}
//- (void)scrollViewDidZoom:(UIScrollView *)scrollView API_AVAILABLE(ios(3.2)); // any zoom scale changes
//
//// called on start of dragging (may require some time and or distance to move)
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
//// called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset API_AVAILABLE(ios(5.0));
//// called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;   // called on finger up as we are moving
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;      // called when scroll view grinds to a halt
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView; // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
//
//- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;     // return a view that will be scaled. if delegate returns nil, nothing happens
//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view API_AVAILABLE(ios(3.2)); // called before the scroll view begins zooming its content
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale; // scale between minimum and maximum. called after any 'bounce' animations
//
//- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;   // return a yes if you want to scroll to the top. if not defined, assumes YES
//- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;      // called when scrolling animation finished. may be called immediately if already at top
//
///* Also see -[UIScrollView adjustedContentInsetDidChange]
// */
//- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView API_AVAILABLE(ios(11.0), tvos(11.0));

#pragma mark —— lazyLoad
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = UIScrollView.new;
        _scrollView.delegate = self;
        _scrollView.mj_header = self.tableViewHeader;
        _scrollView.mj_footer = self.tableViewFooter;
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 50);
        _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.view addSubview:_scrollView];
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
        }];
    }return _scrollView;
}

-(UILabel *)wechatPayLab{
    if (!_wechatPayLab) {
        _wechatPayLab = UILabel.new;
        _wechatPayLab.textAlignment = NSTextAlignmentCenter;
        _wechatPayLab.text = @"微信收款二维码";
        [self.scrollView addSubview:_wechatPayLab];
        [_wechatPayLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView).offset(SCALING_RATIO(5));
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2, SCALING_RATIO(50)));
            make.centerX.equalTo(self.view);
        }];
    }return _wechatPayLab;
}

-(QRcodeIMGV *)qrCodeIMGV_wechatPay{
    if (!_qrCodeIMGV_wechatPay) {
        _qrCodeIMGV_wechatPay = [[QRcodeIMGV alloc]initWithStyle:PaywayTypeWX];
        @weakify(self)
        [_qrCodeIMGV_wechatPay actionBlock:^(id data) {
            @strongify(self)
            [self wechatPay];
        }];
        _qrCodeIMGV_wechatPay.image = kIMG(@"uploadQRCode");//原始占位图
        [self.scrollView addSubview:_qrCodeIMGV_wechatPay];
        [_qrCodeIMGV_wechatPay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.wechatPayLab.mas_bottom).offset(SCALING_RATIO(5));
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2,
                                             SCREEN_WIDTH / 2));
        }];
    }return _qrCodeIMGV_wechatPay;
}

-(QRcodeIMGV *)qrCodeIMGV_alipay{
    if (!_qrCodeIMGV_alipay) {
        _qrCodeIMGV_alipay = [[QRcodeIMGV alloc]initWithStyle:PaywayTypeZFB];
        @weakify(self)
        [_qrCodeIMGV_alipay actionBlock:^(id data) {
            @strongify(self)
            extern NSString *weixin_qr_img;//微信收款二维码
            if ([weixin_qr_img isEqualToString:@"无"]) {
                Toast(@"请先上传微信收款码");
            }else{
                [self aliPay];
            }
        }];
        _qrCodeIMGV_alipay.image = kIMG(@"uploadQRCode");
        [self.scrollView addSubview:_qrCodeIMGV_alipay];
        [_qrCodeIMGV_alipay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.alipayLab.mas_bottom).offset(SCALING_RATIO(5));
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2,
                                             SCREEN_WIDTH / 2));
            make.centerX.equalTo(self.view);
        }];
    }return _qrCodeIMGV_alipay;
}

-(UILabel *)alipayLab{
    if (!_alipayLab) {
        _alipayLab = UILabel.new;
        _alipayLab.text = @"支付宝收款二维码";
        _alipayLab.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:_alipayLab];
        [_alipayLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.qrCodeIMGV_wechatPay.mas_bottom).offset(SCALING_RATIO(5));
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH / 2, SCALING_RATIO(50)));
            make.centerX.equalTo(self.view);
        }];
    }return _alipayLab;
}



-(UILabel *)wechatPayTipsLab{
    if (!_wechatPayTipsLab) {
        _wechatPayTipsLab = UILabel.new;
        [_wechatPayTipsLab setNumberOfLines:0];
        _wechatPayTipsLab.textColor = kRedColor;
        if (@available(iOS 8.2, *)) {
            _wechatPayTipsLab.font = [UIFont systemFontOfSize:8
                                                       weight:1];
        } else {
            _wechatPayTipsLab.font = [UIFont systemFontOfSize:8];
        }
        _wechatPayTipsLab.text = @"此\n微\n信\n收\n款\n码\n已\n经\n失\n效\n，\n请\n重\n新\n上\n传\n";
        [self.scrollView addSubview:_wechatPayTipsLab];
        [_wechatPayTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.scrollView).offset(SCALING_RATIO(-10));
            make.left.equalTo(self.qrCodeIMGV_wechatPay.mas_right).offset(SCALING_RATIO(10));
            make.top.bottom.equalTo(self.qrCodeIMGV_wechatPay);
        }];
    }return _wechatPayTipsLab;
}

-(UILabel *)alipayTipsLab{
    if (!_alipayTipsLab) {
        _alipayTipsLab = UILabel.new;
        [_alipayTipsLab setNumberOfLines:0];
        _alipayTipsLab.textColor = kRedColor;
        if (@available(iOS 8.2, *)) {
            _alipayTipsLab.font = [UIFont systemFontOfSize:7
                                                    weight:1];
        } else {
            _alipayTipsLab.font = [UIFont systemFontOfSize:7];
        }
        _alipayTipsLab.text = @"此\n支\n付\n宝\n收\n款\n码\n已\n经\n失\n效\n，\n请\n重\n新\n上\n传\n";
        [self.scrollView addSubview:_alipayTipsLab];
        [_alipayTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.scrollView).offset(SCALING_RATIO(-10));
            make.left.equalTo(self.qrCodeIMGV_alipay.mas_right).offset(SCALING_RATIO(10));
            make.top.bottom.equalTo(self.qrCodeIMGV_alipay);
        }];
    }return _alipayTipsLab;
}



@end
