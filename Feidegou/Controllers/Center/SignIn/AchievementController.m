//
//  AchievementController.m
//  guanggaobao
//
//  Created by 谭自强 on 2018/4/18.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "AchievementController.h"
#import "ButtonShare.h"
#import "JJHttpClient+ShopGood.h"
//#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "AppDelegate.h"

@interface AchievementController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scBack;
@property (weak, nonatomic) IBOutlet UIImageView *imgShare;
@property (strong, nonatomic) NSDictionary *dicInfo;
@property (weak, nonatomic) IBOutlet ButtonShare *btnPyq;
@property (weak, nonatomic) IBOutlet ButtonShare *btnWx;

@end

@implementation AchievementController
- (IBAction)clickBack:(UIButton *)sender {
    [self clickButtonBack:sender];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([WXApi isWXAppInstalled]) {
        [self.btnPyq setImage:ImageNamed(@"img_thb_pyq") forState:UIControlStateNormal];
        [self.btnWx setImage:ImageNamed(@"img_thb_wx") forState:UIControlStateNormal];
    }else{
        [self.btnPyq setImage:ImageNamed(@"img_thb_pyq_n") forState:UIControlStateNormal];
        [self.btnWx setImage:ImageNamed(@"img_thb_wx_n") forState:UIControlStateNormal];
    }
    [self setTitle:@""];
    [self.scBack setBackgroundColor:ColorFromRGB(240, 205, 170)];
    if (@available(iOS 11.0, *)) {
        self.scBack.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    [self refreshView];
    // Do any additional setup after loading the view.
}
- (void)refreshView{
    UIImage *image = [PublicFunction fetchImageForShareAchievement:self.dicInfo];
    self.layoutConstraintHeight.constant = SCREEN_WIDTH*image.size.height/image.size.width;
    [self.imgShare setImage:image];
}
- (void)locationControls{
    [self showExceptionNoHead];
    __weak AchievementController *myself = self;
    self.disposable = [[[JJHttpClient new] requestShopGoodSignInShare] subscribeNext:^(NSDictionary*dictionary) {        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            myself.dicInfo = [NSDictionary dictionaryWithDictionary:dictionary];
            [myself refreshView];
        }
    }error:^(NSError *error) {
        myself.disposable = nil;
        [myself failedRequestException:enum_exception_timeout];
    }completed:^{
        myself.disposable = nil;
        [myself hideException];
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:self.isHadTitle];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:self.isHadTitle];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickButtonShage:(ButtonShare *)sender {
//    NSArray* imageArray = @[[PublicFunction fetchImageForShareAchievement:self.dicInfo]];
    UIImage *imageShare = [PublicFunction fetchImageForShareAchievement:self.dicInfo];
    NSArray* imageArray = @[imageShare];
    
    
//    SSDKPlatformType type = SSDKPlatformSubTypeWechatTimeline;
//    if (sender.tag == 11) {
//        type = SSDKPlatformSubTypeWechatSession;
//    }
//    if (imageArray) {
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"一键分享"
//                                         images:imageArray
//                                            url:nil
//                                          title:@"shop7"
//                                           type:SSDKContentTypeImage];
//        
//        [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state,NSDictionary *userData,SSDKContentEntity *contentEntity,NSError *error){
//            
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            [appDelegate shareSucceed];
            
//            switch (state) {
//                case SSDKResponseStateSuccess:
//                {
//                    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
//                    break;
//                }
//                case SSDKResponseStateFail:
//                {
//                    [SVProgressHUD showErrorWithStatus:@"分享失败"];
//                    break;
//                }
//                case SSDKResponseStateCancel:
//                {
//                    [SVProgressHUD showErrorWithStatus:@"取消分享"];
//                    break;
//                }
//                default:
//                    break;
//            }
//        }];
//    }

    
//    UIImage *shareImage = [PublicFunction fetchImageForShareAchievement:self.dicInfo];
//    shareImage = [self compressImage:shareImage toByte:32];
//    WXMediaMessage *message = [WXMediaMessage message];
//    [message setThumbImage:shareImage];
//
//    WXImageObject *imageObject=[WXImageObject object];
////    imageObject.imageData=UIImagePNGRepresentation(shareImage);
//    imageObject.imageData=UIImageJPEGRepresentation(shareImage, 0.2);
//    message.mediaObject=imageObject;
//
//    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    req.message = message;
//    req.scene = WXSceneSession;
//    if (sender.tag == 10) {
//        req.scene = WXSceneTimeline;
//    }
//    [WXApi sendReq:req];
}

- (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
