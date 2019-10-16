//
//  UITextFieldPassWord.m
//  Vendor
//
//  Created by 谭自强 on 2016/12/8.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "UITextFieldPassWord.h"

@implementation UITextFieldPassWord

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setAttribute];
    }return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setAttribute];
}

- (void)setAttribute{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 40,
                                                                  0,
                                                                  40,
                                                                  self.frame.size.height)];
    [button setSelected:YES];
    [button setImage:ImageNamed(@"img_login_close") forState:UIControlStateNormal];
    [button setImage:ImageNamed(@"img_login_open") forState:UIControlStateSelected];
    [button addTarget:self action:@selector(clickButtonEntry:) forControlEvents:UIControlEventTouchUpInside];
    [self setRightView:button];
    [self setRightViewMode:UITextFieldViewModeAlways];
    [self clickButtonEntry:button];
}

- (void)clickButtonEntry:(UIButton *)sender{
    // 切换按钮的状态
    NSString *tempPwdStr = self.text;
    if (sender.selected) {
        // 按下去了就是明文
        self.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.secureTextEntry = YES;
        self.text = tempPwdStr;
    } else {
        // 暗文
        self.text = @"";
        self.secureTextEntry = NO;
        self.text = tempPwdStr;
    }
    sender.selected = !sender.selected;
}

@end
