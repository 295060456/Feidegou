//
//  GoodShareController.m
//  Feidegou
//
//  Created by 谭自强 on 2018/10/14.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "GoodShareController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
//#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface GoodShareController ()<NJKWebViewProgressDelegate,UIWebViewDelegate>{
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (assign, nonatomic) BOOL isFinished;
@property (weak, nonatomic) IBOutlet UIView *viShare;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@end

@implementation GoodShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.btnShare setBackgroundColor:ColorButton];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self.strWebUrl rangeOfString:@"http"].location == NSNotFound) {
        self.strWebUrl = [NSString stringWithFormat:@"http://%@",self.strWebUrl];
    }
    NSLog(@"url is %@",self.strWebUrl);
    self.view.backgroundColor=[UIColor whiteColor];
    self.strWebUrl = [self.strWebUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:self.strWebUrl];
    //加载文件
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
    self.isFinished = YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}
- (IBAction)clickButtonShare:(UIButton *)sender {
    if (!self.isFinished) {
        return;
    }
    UIGraphicsBeginImageContextWithOptions(self.webView.bounds.size, YES, 0);     //设置截屏大小
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.webView.scrollView.contentSize.width, self.webView.scrollView.contentSize.height), YES, 0);     //设置截屏大小
    [[self.webView layer] renderInContext:UIGraphicsGetCurrentContext()];
     UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    self.dicDetail[@"goods"][@"goods_name"]
    
    NSArray* imageArray = @[image];
    //        （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"商品名称"
//                                         images:imageArray
//                                            url:[NSURL URLWithString:self.strWebUrl]
//                                          title:@"7商城"
//                                           type:SSDKContentTypeImage];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil customItems:nil shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//            switch (state) {
//                case SSDKResponseStateSuccess:
//                {
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                        message:nil
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"确定"
//                                                              otherButtonTitles:nil];
//                    [alertView show];
//                    break;
//                }
//                case SSDKResponseStateFail:
//                {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                    message:[NSString stringWithFormat:@"%@",error]
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"OK"
//                                                          otherButtonTitles:nil, nil];
//                    [alert show];
//                    break;
//                }
//                default:
//                    break;
//            }
//        }];
    }
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
