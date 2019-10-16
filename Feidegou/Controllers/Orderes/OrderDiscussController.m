//
//  OrderDiscussController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/8/31.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "OrderDiscussController.h"
#import "JJHttpClient+FourZero.h"

@interface OrderDiscussController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UITextView *textMsg;
@property (weak, nonatomic) IBOutlet UIButton *btnCommit;
@property (strong,nonatomic) UILabel *lblPlaceholder;
@property (copy,nonatomic) NSString *strDiscuss;
@property (copy,nonatomic) NSString *strMSXF;
@property (copy,nonatomic) NSString *strFHSU;
@property (copy,nonatomic) NSString *strFWTD;

@end

@implementation OrderDiscussController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self.btnCommit setBackgroundColor:ColorRed];
    [self.imgHead setImagePathHead:self.strImage];
    [self.lblName setTextNull:self.strGoodsName];
    self.strDiscuss = @"1";
    self.strMSXF = @"5";
    self.strFHSU = @"5";
    self.strFWTD = @"5";
    self.lblPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(5,
                                                                    8,
                                                                    CGRectGetWidth(self.textMsg.frame)-20,
                                                                    self.textMsg.frame.size.height)];
    [self.lblPlaceholder setText:@"写下您购买和使用的感受来帮助其他小伙伴"];
    [self.lblPlaceholder setNumberOfLines:0];
    [self.lblPlaceholder setFont:[UIFont systemFontOfSize:12.0]];
    [self.lblPlaceholder setTextColor:[UIColor darkGrayColor]];
    [self.lblPlaceholder setBackgroundColor:[UIColor clearColor]];
    [self.lblPlaceholder setEnabled:NO];
    [self.lblPlaceholder sizeToFit];
    [self.textMsg addSubview:self.lblPlaceholder];
}

- (void)textViewDidChange:(UITextView *)textView{
    NSString *str = textView.text;
    if (str.length==0) {
        [self.lblPlaceholder setHidden:NO];
    }else{
        [self.lblPlaceholder setHidden:YES];
    }
}

- (IBAction)clickButtonScore:(UIButton *)sender {
    [self.view endEditing:YES];
    D_NSLog(@"tag is %ld",(long)sender.tag);
    if (sender.tag<200) {
        [self refreshButtonImage:100 andSelect:(int)sender.tag];
        if (sender.tag == 100) {
            self.strDiscuss = @"1";
        }
        if (sender.tag == 101) {
            self.strDiscuss = @"0";
        }
        if (sender.tag == 102) {
            self.strDiscuss = @"-1";
        }
    }else if (sender.tag<300){
        [self refreshButtonImage:200 andSelect:(int)sender.tag];
        
        self.strMSXF = StringFormat(@"%d",(int)sender.tag-199);
    }else if (sender.tag<400){
        [self refreshButtonImage:300 andSelect:(int)sender.tag];
        self.strFHSU = StringFormat(@"%d",(int)sender.tag-299);
    }else if (sender.tag<500){
        [self refreshButtonImage:400 andSelect:(int)sender.tag];
        self.strFWTD = StringFormat(@"%d",(int)sender.tag-399);
    }
    D_NSLog(@"strDiscuss is %@,msxf is %@,fhsd is %@,wftd is %@",_strDiscuss,_strMSXF,_strFHSU,_strFWTD);
}

- (void)refreshButtonImage:(int)intMix
                 andSelect:(int)intseleted{
    int intMax = intMix+5;
    if (intMix==100) {
        intMax = 103;
        for (int i = intMix; i<=intMax; i++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            if (i==intseleted) {
                [button setSelected:YES];
            }else{
                [button setSelected:NO];
            }
        }
    }else{
        for (int i = intMix; i<=intMax; i++) {
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            if (i<=intseleted) {
                [button setSelected:YES];
            }else{
                [button setSelected:NO];
            }
        }
    }
}
- (IBAction)clickButtonCommit:(UIButton *)sender {
    [SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeBlack];
    [self.view endEditing:YES];
    __weak OrderDiscussController *myself = self;
    self.disposable = [[[JJHttpClient new] requestFourZeroCommitDiscussevaluate_seller_val:self.strDiscuss
                                                                          andevaluate_info:[NSString stringStandard:self.textMsg.text]
                                                                      andevaluate_goods_id:[NSString stringStandard:self.strGoodsId]
                                                                       andevaluate_user_id:[NSString stringStandard:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId]
                                                                                  andof_id:[NSString stringStandard:self.strOrderId]
                                                                   anddescription_evaluate:self.strMSXF
                                                                       andservice_evaluate:self.strFWTD
                                                                          andship_evaluate:self.strFHSU]
                       subscribeNext:^(NSDictionary*dictionary) {
        if ([dictionary[@"code"] intValue]==1) {
            [SVProgressHUD showSuccessWithStatus:dictionary[@"msg"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameDiscussSucceed object:self.strOrderId];
            [myself.navigationController popViewControllerAnimated:YES];
        }else{
            [SVProgressHUD showErrorWithStatus:dictionary[@"msg"]];
        }
    }error:^(NSError *error) {
        myself.disposable = nil;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }completed:^{
        myself.disposable = nil;
    }];
}

- (IBAction)clickScorviewEditing:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
