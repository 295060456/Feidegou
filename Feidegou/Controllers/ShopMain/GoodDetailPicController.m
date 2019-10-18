//
//  GoodDetailPicController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/27.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "GoodDetailPicController.h"

@interface GoodDetailPicController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation GoodDetailPicController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    [self.webView setScalesPageToFit:YES];
//    [self.webView loadHTMLString:self.dicDetail[@"goods"][@"goods_details"] baseURL:[[NSBundle mainBundle] bundleURL]];
    NSString *strUrl = self.dicDetail[@"goods"][@"detailURL"];
    if ([strUrl rangeOfString:@"http"].location == NSNotFound) {
        strUrl = [NSString stringWithFormat:@"http://%@",strUrl];
    }
    NSLog(@"url is %@",strUrl);
    self.view.backgroundColor=[UIColor whiteColor];
    strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:strUrl];
    //加载文件
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    
}


@end
