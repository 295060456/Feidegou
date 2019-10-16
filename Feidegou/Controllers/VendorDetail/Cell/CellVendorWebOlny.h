//
//  CellVendorWebOlny.h
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/30.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellVendorWebOlny : UITableViewCell<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic ,copy)void(^webViewHeight)(CGFloat fWebHeight);
- (void)populataData:(NSString *)strWebUrl;
@end
