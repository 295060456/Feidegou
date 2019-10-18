//
//  WebOnlyController.m
//  JiandaobaoVendor
//
//  Created by 谭自强 on 15/8/26.
//  Copyright (c) 2015年 朝花夕拾. All rights reserved.
//

#import "WebOnlyController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface WebOnlyController ()
<NJKWebViewProgressDelegate,
UIWebViewDelegate>
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIButton *btnShutDown;

@end

@implementation WebOnlyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnShutDown = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnShutDown setFrame:CGRectMake(0, 0, 40, 44)];
    [self.btnShutDown.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.btnShutDown setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.btnShutDown addTarget:self action:@selector(clickButtonShutDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnShutDown setTitle:@"关闭" forState:UIControlStateNormal];
    [self.btnShutDown setTitleColor:ColorBlack forState:UIControlStateNormal];
    [self.btnShutDown setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [self.btnShutDown setHidden:YES];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:self.btnShutDown];
    barButton.width = 40;
    self.navigationItem.rightBarButtonItem = barButton;
    // Do any additional setup after loading the view.
}
- (void)clickButtonShutDown:(UIButton *)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)clickButtonBack:(UIButton *)sender{
    if (self.webView.canGoBack) {
        [self.webView goBack];
    }else{
        if (self.navigationController) {
            [self.navigationController popViewControllerAnimated:!self.webView.canGoBack];
        }else{
            [self dismissViewControllerAnimated:!self.webView.canGoBack completion:nil];
        }
    }
}

- (void)locationControls{
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navigationBarBounds.size.height - progressBarHeight,
                                 navigationBarBounds.size.width,
                                 progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.type == enum_web_companyqualification){
        [self setTitle:@"公司资质"];
    }else if (self.type == enum_web_incomeInstruction){
        [self setTitle:@"收益说明"];
    }else if (self.type == enum_web_advertisementDetail){
        [self setTitle:@"广告详情"];
    }else if (self.type == enum_web_advertisementOfMoney){
        [self setTitle:@"广告计费说明"];
    }else if (self.type == enum_web_notice){
        [self setTitle:@"公告"];
    }else if (self.type == enum_web_EarnMore){
        [self setTitle:@"赚取更多"];
    }else if (self.type == enum_web_adverUrl){
        [self setTitle:@"看广告"];
    }else if (self.type == enum_web_rankingList){
        [self setTitle:@"规则"];
    }else if (self.type == enum_web_rankingDetail){
        [self setTitle:@"详情"];
    }else if (self.type == enum_web_shengji){
        [self setTitle:@"升级"];
    }else if (self.type == enum_web_regDelegete){
        [self setTitle:@"广告宝注册协议"];
    }else if (self.type == enum_web_vendorPrivilege){
        [self setTitle:@"广告商特权"];
    }
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
    if (self.type == enum_web_advertisementDetail||
        self.type ==  enum_web_adverUrl||
        self.type == enum_web_setName) {
        
        self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    [self.btnShutDown setHidden:!self.webView.canGoBack];
}

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error{
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress
        updateProgress:(float)progress{
    [_progressView setProgress:progress animated:YES];
}


@end
