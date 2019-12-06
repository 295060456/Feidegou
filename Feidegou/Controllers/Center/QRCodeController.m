//
//  QRCodeController.m
//  Vendor
//
//  Created by 谭自强 on 2017/5/3.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "QRCodeController.h"
#import "JJHttpClient+ShopGood.h"
//#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "AppDelegate.h"

@interface QRCodeController ()
@property (weak, nonatomic) IBOutlet UILabelBlackMiddle *lblTip;
@property (weak, nonatomic) IBOutlet UIImageView *imgCode;
@property (weak, nonatomic) IBOutlet UIButton *btnSend;
@property (strong, nonatomic) NSString *strImage;


@end

@implementation QRCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnSend setBackgroundColor:ColorRed];
//    NSString *strInviter = [[PersonalInfo sharedInstance] fetchLoginUserInfo].userId;
//    [self.lblTip setTextNull:@""];
//    [self.imgCode setImage:[UIImage createNonInterpolatedUIImageFormString:StringFormat(@"%@/register.htm?id=%@",BASE_URL,strInviter) withSize:SCREEN_WIDTH-80]];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    [self showException];
    __weak QRCodeController *myself = self;
    self.disposable = [[[JJHttpClient new] requestShopGoodInviteFriend] subscribeNext:^(NSString*string) {
        myself.strImage = string;
        [myself.imgCode setImagePathListSquare:string];
    }error:^(NSError *error) {
        myself.disposable = nil;
        [myself failedRequestException:enum_exception_timeout];
    }completed:^{
        myself.disposable = nil;
        [myself hideException];
    }];
}
- (IBAction)clickButtonSend:(UIButton *)sender {
    if ([NSString isNullString:self.strImage]) {
        return;
    }
    NSArray* imageArray = @[self.strImage];
    //        （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"邀请好友"
//                                         images:imageArray
//                                            url:nil
//                                          title:@"7商城"
//                                           type:SSDKContentTypeImage];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil customItems:nil shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//            
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            [appDelegate shareSucceed];
//        }];
    }
    
//    SSDKPlatformType type = SSDKPlatformSubTypeWechatSession;
//    if (sender.tag == 11) {
//        type = SSDKPlatformSubTypeWechatSession;
//    }
//    if (imageArray) {
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"非得购一键分享"
//                                         images:imageArray
//                                            url:nil
//                                          title:@"非得购"
//                                           type:SSDKContentTypeImage];
//
//        [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state,NSDictionary *userData,SSDKContentEntity *contentEntity,NSError *error){
//
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            [appDelegate shareSucceed];
//
////            switch (state) {
////                case SSDKResponseStateSuccess:
////                {
////                    [SVProgressHUD showSuccessWithStatus:@"分享成功"];
////                    break;
////                }
////                case SSDKResponseStateFail:
////                {
////                    [SVProgressHUD showErrorWithStatus:@"分享失败"];
////                    break;
////                }
////                case SSDKResponseStateCancel:
////                {
////                    [SVProgressHUD showErrorWithStatus:@"取消分享"];
////                    break;
////                }
////                default:
////                    break;
////            }
//        }];
//    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
