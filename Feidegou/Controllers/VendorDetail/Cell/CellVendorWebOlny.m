//
//  CellVendorWebOlny.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/30.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellVendorWebOlny.h"

@implementation CellVendorWebOlny

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)populataData:(NSString *)strWebUrl{
    [self.webView setDelegate:self];
    [self.webView.scrollView setScrollEnabled:NO];
    if ([strWebUrl rangeOfString:@"http"].location == NSNotFound) {
        strWebUrl = [NSString stringWithFormat:@"http://%@",strWebUrl];
    }
    NSLog(@"url is %@",strWebUrl);
    self.backgroundColor=[UIColor whiteColor];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strWebUrl]];
    [self.webView loadData:data MIMEType:@"text/html"
          textEncodingName:@"UTF-8"
                   baseURL:[NSURL URLWithString:strWebUrl]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    D_NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    D_NSLog(@"webViewDidFinishLoad须知的高度%f",webViewHeight);
    if (self.webViewHeight) {
        self.webViewHeight(webViewHeight);
    }
}

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error{
    
    D_NSLog(@"didFailLoadWithError");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
