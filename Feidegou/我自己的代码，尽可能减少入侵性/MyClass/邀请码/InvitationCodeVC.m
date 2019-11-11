//
//  InvitationCodeVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/11.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "InvitationCodeVC.h"
#import "InvitationCodeVC+VM.h"

@interface InvitationCodeVC ()
<
UITextFieldDelegate
>

@property(nonatomic,strong)UIButton *sendBtn;
@property(nonatomic,strong)ZYTextField *textField;
@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation InvitationCodeVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated{
    
    InvitationCodeVC *vc = InvitationCodeVC.new;
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

-(void)viewDidLoad{
    [super viewDidLoad];
    self.gk_navTitle = @"邀请码";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.sendBtn];
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    self.textField.alpha = 1;
}
#pragma mark —— UITextFieldDelegate
//询问委托人是否应该在指定的文本字段中开始编辑
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
//告诉委托人在指定的文本字段中开始编辑
- (void)textFieldDidBeginEditing:(UITextField *)textField{

}
//询问委托人是否应在指定的文本字段中停止编辑
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
//告诉委托人对指定的文本字段停止编辑
- (void)textFieldDidEndEditing:(UITextField *)textField{

}
//告诉委托人对指定的文本字段停止编辑
//- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason;
//询问委托人是否应该更改指定的文本
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
//询问委托人是否应删除文本字段的当前内容
//- (BOOL)textFieldShouldClear:(UITextField *)textField;
//询问委托人文本字段是否应处理按下返回按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
#pragma mark —— 点击事件
-(void)sendBtnClickEvent:(UIButton *)sender{
    NSLog(@"发送");
}

-(void)backBtnClickEvent:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark —— lazyLoad
-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = UIButton.new;
        [_sendBtn setTitle:@"点我发送"
                  forState:UIControlStateNormal];
        [_sendBtn setTitleColor:kBlackColor
                       forState:UIControlStateNormal];
        [_sendBtn addTarget:self
                     action:@selector(sendBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
    }return _sendBtn;
}

-(ZYTextField *)textField{
    if (!_textField) {
        _textField = ZYTextField.new;
        _textField.placeholder = @"在此输入邀请码";
        _textField.delegate = self;
        [self.view addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(SCALING_RATIO(10));
            make.right.equalTo(self.view).offset(SCALING_RATIO(-10));
            make.top.equalTo(self.gk_navigationBar.mas_bottom).offset(SCALING_RATIO(10));
            make.height.mas_equalTo(SCALING_RATIO(50));
        }];
        [self.view layoutSubviews];
        [self.view setBorderWithView:_textField
                          borderColor:kBlackColor
                          borderWidth:0.5f
                           borderType:UIBorderSideTypeBottom];
        
    }return _textField;
}


@end
