//
//  WithDrawDepositController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/8/8.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "WithDrawDepositController.h"
#import "InputApliayController.h"
#import "JJHttpClient+FourZero.h"
#import "CLCellOneLbl.h"
#import "JJDBHelper+Center.h"

@interface WithDrawDepositController ()
@property (weak, nonatomic) IBOutlet UITextField *txtAlipay;
@property (weak, nonatomic) IBOutlet UIButton *btnAll;
@property (weak, nonatomic) IBOutlet UIButton *btnWithDraw;
@property (weak, nonatomic) IBOutlet UILabel *lblTipMoney;
@property (weak, nonatomic) IBOutlet UITextField *txtMony;
@property (strong, nonatomic) NSString *strMoney;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *arrType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintLeading;
@property (weak, nonatomic) IBOutlet UILabel *lblLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintWidth;
@property (weak, nonatomic) IBOutlet UILabel *lblError;
@property (assign, nonatomic) NSInteger intSelected;
@end

@implementation WithDrawDepositController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    self.intSelected = 0;
    [self.btnWithDraw setBackgroundColor:ColorHeader];
    self.arrType = [NSMutableArray arrayWithObjects:@"余额提现",@"业绩提成提现", nil];
    if ([[[JJDBHelper sharedInstance] fetchCenterMsg].store_status intValue]==2) {
        [self.arrType addObject:@"货款提现"];
    }
    self.layoutConstraintWidth.constant = 85;
    [self.collectionView registerClass:[CLCellOneLbl class] forCellWithReuseIdentifier:@"CLCellOneLbl"];
    [self.lblLine setBackgroundColor:ColorHeader];
}
- (void)refreshLayout{
    if ([NSString isNullString:[[JJDBHelper sharedInstance] fetchCenterMsg].alipay]) {
        [self.txtAlipay setText:@""];
    }else{
        [self.txtAlipay setText:StringFormat(@"%@:%@",[[JJDBHelper sharedInstance] fetchCenterMsg].alipayName,[[JJDBHelper sharedInstance] fetchCenterMsg].alipay)];
    }
//    [self.collectionView reloadData];
//    self.layoutConstraintLeading.constant = self.intSelected * SCREEN_WIDTH/self.arrType.count+(SCREEN_WIDTH/self.arrType.count-self.layoutConstraintWidth.constant)/self.arrType.count;
//    if (self.intSelected == 1) {
//        self.strMoney = [NSString stringStandardFloatTwo:[[JJDBHelper sharedInstance] fetchCenterMsg].redbags];
//    }else if (self.intSelected == 2) {
//        self.strMoney = [NSString stringStandardFloatTwo:[[JJDBHelper sharedInstance] fetchCenterMsg].redbags];
//    }else{
//        self.strMoney = [NSString stringStandardFloatTwo:[[JJDBHelper sharedInstance] fetchCenterMsg].availableBalance];
//    }
    self.strMoney = [NSString stringStandardFloatTwo:[[JJDBHelper sharedInstance] fetchCenterMsg].availableBalance];
    [self.lblTipMoney setTextNull:StringFormat(@"可提现金额%@元",self.strMoney)];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshLayout];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickButtonAll:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.txtMony setText:self.strMoney];
}
- (IBAction)clickButtonAlipay:(UIButton *)sender {
    [self.view endEditing:YES];
    InputApliayController *controller = [[UIStoryboard storyboardWithName:StoryboardWithdrawDeposit bundle:nil] instantiateViewControllerWithIdentifier:@"InputApliayController"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)clickButtonRuleOfWithDarw:(UIButton *)sender {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardWebService bundle:nil];
//    WebOnlyController *controller = [storyboard instantiateViewControllerWithIdentifier:@"WebOnlyController"];
//    [controller setTitle:@"提现规则"];
//    if (self.intSelected == 0) {
//        controller.strWebUrl = @"www.hao123.com";
//    }else{
//        controller.strWebUrl = @"www.baidu.com";
//    }
//    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)clickButtonWithDraw:(UIButton *)sender {
    
    NSString *strAlipay= self.txtAlipay.text;
    if ([NSString isNullString:strAlipay]) {
        [SVProgressHUD showErrorWithStatus:@"请填写您的支付宝"];
        return;
    }
    NSString *strMoney= self.txtMony.text;
    if ([NSString isNullString:strMoney]) {
        [SVProgressHUD showErrorWithStatus:@"请输入金额"];
        return;
    }
    if (![NSString isMoney:strMoney]) {
        [SVProgressHUD showErrorWithStatus:@"您输入的金额有误"];
        return;
    }
    
//    if ([strMoney floatValue]<5) {
//        [SVProgressHUD showErrorWithStatus:@"不能少于5元"];
//        return;
//    }
//    if ([self.strMoney floatValue]<[strMoney floatValue]) {
//        [SVProgressHUD showErrorWithStatus:@"金额不足"];
//        return;
//    }
    [self.view endEditing:YES];
    NSString *strType;
    if (self.intSelected == 0) {
        strType = @"1";
    }else if (self.intSelected == 1) {
        strType = @"2";
    }else{
        strType = @"3";
    }
    [SVProgressHUD showWithStatus:@"正在提交信息..."];
    __weak WithDrawDepositController *myself = self;
    self.disposable = [[[JJHttpClient new] requestFourZeroWithDrawUserId:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId andcash_account:[[JJDBHelper sharedInstance] fetchAlipayAccount] andcash_info:[[JJDBHelper sharedInstance] fetchAlipayName] andcash_amount:strMoney andcash_type:strType] subscribeNext:^(NSDictionary*dictionary) {
        
        
        [SVProgressHUD dismiss];
        if ([dictionary[@"code"] intValue]==1) {
            ModelCenter *modelCenter = [[JJDBHelper sharedInstance] fetchCenterMsg];
            if (myself.intSelected == 1) {
                modelCenter.redbags = StringFormat(@"%f",[modelCenter.redbags doubleValue]-[strMoney doubleValue]);
            }else{
                modelCenter.availableBalance = StringFormat(@"%f",[modelCenter.availableBalance doubleValue]-[strMoney doubleValue]);
            }
            [[JJDBHelper sharedInstance] saveCenterMsg:modelCenter];
            [myself refreshLayout];
        }
        JJAlertViewOneButton *alertView = [[JJAlertViewOneButton alloc] init];
        [alertView showAlertView:self andTitle:nil andMessage:dictionary[@"msg"] andCancel:@"确定" andCanelIsRed:YES andBack:^{
            [myself.navigationController popViewControllerAnimated:YES];
        }];
    }error:^(NSError *error) {
        myself.disposable = nil;
        [SVProgressHUD dismiss];
        JJAlertViewOneButton *alertView = [[JJAlertViewOneButton alloc] init];
        [alertView showAlertView:self andTitle:nil andMessage:error.localizedDescription andCancel:@"确定" andCanelIsRed:YES andBack:^{
        }];
    }completed:^{
        myself.disposable = nil;
    }];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (void)refreshLineLocation{
    self.layoutConstraintLeading.constant = self.intSelected * SCREEN_WIDTH/self.arrType.count+(SCREEN_WIDTH/self.arrType.count-self.layoutConstraintWidth.constant)/self.arrType.count;
}
#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrType.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CLCellOneLbl";
    CLCellOneLbl *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.lblContent setTextNull:self.arrType[indexPath.row]];
    [cell.lblLineDown setHidden:YES];
    [cell.lblLineRight setHidden:YES];
    if (self.intSelected == indexPath.row) {
        [cell.lblContent setTextColor:ColorRed];
    }else{
        [cell.lblContent setTextColor:ColorBlack];
    }
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/self.arrType.count,40);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.intSelected!=indexPath.row) {
        self.intSelected = indexPath.row;
        [self.txtMony setText:@""];
        [self refreshLayout];
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
