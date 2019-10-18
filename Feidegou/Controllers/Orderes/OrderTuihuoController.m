//
//  OrderTuihuoController.m
//  Feidegou
//
//  Created by 谭自强 on 2018/10/13.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "OrderTuihuoController.h"
#import "JJHttpClient+ShopGood.h"
#import "JJHttpClient+FourZero.h"
#import "UIButton+Joker.h"

@interface OrderTuihuoController ()
<
UIPickerViewDataSource,
UIPickerViewDelegate
>

@property (weak, nonatomic) IBOutlet UIButton *btnComfirlm;
@property (weak, nonatomic) IBOutlet UIView *viLine;
@property (weak, nonatomic) IBOutlet UITextField *txtNum;
@property (weak, nonatomic) IBOutlet UILabelDarkMiddel *lblName;
@property (strong, nonatomic) NSMutableArray *arrData;
@property(strong,nonatomic)UIPickerView *pickerView;
@property(strong,nonatomic)UIView *viBack;
@property(assign,nonatomic)NSInteger row;
@end

@implementation OrderTuihuoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.row = -1;
    if (![NSString isNullString:self.modelOrderDetail.return_shipCode]) {
        [self.lblName setTextNull:self.modelOrderDetail.return_company];
        [self.txtNum setText:self.modelOrderDetail.return_shipCode];
    }
    
    [self.viLine setBackgroundColor:ColorLine];
    [self.btnComfirlm setBackgroundColor:ColorButton];
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)initPinckerView{
    self.viBack = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                           0,
                                                           SCREEN_WIDTH,
                                                           SCREEN_HEIGHT)];
    [self.viBack setBackgroundColor:[UIColor colorWithWhite:0
                                                      alpha:0.4]];
    [self.view addSubview:self.viBack];
    UIButton *btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     SCREEN_WIDTH,
                                                                     CGRectGetHeight(self.viBack.frame))];
    [btnDelete handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self hideSelete];
    }];
    [self.viBack addSubview:btnDelete];
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetHeight(self.viBack.frame)-240,
                                                                     SCREEN_WIDTH,
                                                                     240)];
    [self.pickerView setBackgroundColor:[UIColor whiteColor]];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    [self.viBack addSubview:self.pickerView];
    UIView *viButton = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                CGRectGetMinY(self.pickerView.frame)-40,
                                                                SCREEN_WIDTH,
                                                                40)];
    [viButton setBackgroundColor:[UIColor whiteColor]];
    UIView *viLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              CGRectGetHeight(viButton.frame)-1,
                                                              SCREEN_WIDTH,
                                                              1)];
    [viLine setBackgroundColor:ColorLine];
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     60,
                                                                     CGRectGetHeight(viButton.frame))];
    [btnCancel.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:ColorGaryDark forState:UIControlStateNormal];
    [btnCancel handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self hideSelete];
    }];
    
    UIButton *btnConfilm = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60,
                                                                      0,
                                                                      60,
                                                                      CGRectGetHeight(viButton.frame))];
    [btnConfilm.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [btnConfilm setTitle:@"确定" forState:UIControlStateNormal];
    [btnConfilm setTitleColor:ColorButton forState:UIControlStateNormal];
    [btnConfilm handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        self.row =  [self.pickerView selectedRowInComponent:0];
        [self.lblName setText:self.arrData[self.row][@"company_name"]];
        [self hideSelete];
    }];
    [viButton addSubview:btnCancel];
    [viButton addSubview:btnConfilm];
    [viButton addSubview:viLine];
    [self.viBack addSubview:viButton];
}

- (void)hideSelete{
    [self.viBack removeFromSuperview];
    self.viBack = nil;
}

- (void)requestData{
    [self showException];
    
    __weak OrderTuihuoController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodWuliuList] subscribeNext:^(NSArray* array) {
        myself.arrData = [NSMutableArray arrayWithArray:array];
        [myself hideException];
    }error:^(NSError *error) {
        [myself failedRequestException:enum_exception_timeout];
        myself.disposable = nil;
    }completed:^{
        myself.disposable = nil;
    }];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//返回行数在每个组件(每一列)
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.arrData.count;
    
}
//每一列组件的行高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0;
}

// 返回每一列组件的每一行的标题内容
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)componen{
    return self.arrData[row][@"company_name"];
}

- (IBAction)clickButtonSelect:(UIButton *)sender {
    [self initPinckerView];
}

- (IBAction)clickButtonConfilm:(UIButton *)sender {
    
    if (self.row<0) {
        [SVProgressHUD showErrorWithStatus:@"请选择物流公司"];
        return;
    }
    if ([NSString isNullString:self.txtNum.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入物流单号"];
        return;
    }
    [SVProgressHUD showWithStatus:@"正在提交信息..."];
    __weak OrderTuihuoController *myself = self;
    self.disposable = [[[JJHttpClient new] requestFourZeroWuliuRefund_id:[NSString stringStandard:self.modelOrderDetail.refund[@"refund_id"]]
                                                           andcompany_id:[NSString stringStandard:self.arrData[self.row][@"id"]]
                                                            andship_code:self.txtNum.text]
                       subscribeNext:^(NSDictionary*dictionary) {
        [SVProgressHUD dismiss];
        if ([dictionary[@"code"] intValue]==1) {
            JJAlertViewOneButton *alertView = [[JJAlertViewOneButton alloc] init];
            [alertView showAlertView:self
                            andTitle:nil
                          andMessage:StringFormat(@"%@",dictionary[@"msg"])
                           andCancel:@"确定"
                       andCanelIsRed:YES
                             andBack:^{
                D_NSLog(@"点击了确定");
                [myself.navigationController popToRootViewControllerAnimated:YES];
            }];
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
