//
//  AreaOrderComfilmController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/9/9.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "AreaOrderComfilmController.h"
#import "CellOrderAddressNo.h"
#import "CellOrderAddressYes.h"
#import "CellOrderGiftNo.h"
#import "CellMsgForVendor.h"
#import "CellGoodMoney.h"
#import "OrderAttribute.h"
#import "OrderesAddressController.h"
#import "JJHttpClient+FourZero.h"
#import "PayMonyForGoodController.h"

@interface AreaOrderComfilmController ()
@property (weak, nonatomic) IBOutlet UITableView *tabOrder;
@property (weak, nonatomic) IBOutlet UIButton *btnComfirlm;
@property (weak, nonatomic) IBOutlet UILabel *lblPirceAll;
@property (strong, nonatomic) OrderAttribute *orderAttribute;

@end

@implementation AreaOrderComfilmController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self registerLJWKeyboardHandler];
    [self.tabOrder setBackgroundColor:ColorBackground];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellOrderAddressNo" bundle:nil] forCellReuseIdentifier:@"CellOrderAddressNo"];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellOrderAddressYes" bundle:nil] forCellReuseIdentifier:@"CellOrderAddressYes"];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellOrderGiftNo" bundle:nil] forCellReuseIdentifier:@"CellOrderGiftNo"];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellMsgForVendor" bundle:nil] forCellReuseIdentifier:@"CellMsgForVendor"];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellGoodMoney" bundle:nil] forCellReuseIdentifier:@"CellGoodMoney"];
    self.orderAttribute = [[OrderAttribute alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabOrder reloadData];
    
    NSString *strMoney = StringFormat(@"合计:%d积分+%@(含运费)",[self.modelDetail.ig_goods_integral intValue]*self.intNum,[NSString stringStandardFloatTwo:self.modelDetail.ig_transfee]);
    [self.lblPirceAll setTextNull:strMoney];
    if ([NSString isNullString:self.orderAttribute.strAddressId]) {
        [self.btnComfirlm setBackgroundColor:ColorGary];
    }else{
        [self.btnComfirlm setBackgroundColor:ColorHeader];
    }
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70.0f;
    }
    if (indexPath.section == 1) {
        return 90.0f;
    }
    if (indexPath.section == 2) {
        return 30;
    }
    if (indexPath.section == 3) {
        return 65;
    }return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *strAddressId = self.orderAttribute.strAddressId;
        if ([NSString isNullString:strAddressId]) {
            CellOrderAddressNo *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderAddressNo"];
            return cell;
        }else{
            CellOrderAddressYes *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderAddressYes"];
            [cell.lblName setTextNull:StringFormat(@"%@ %@",self.orderAttribute.strAddressName,self.orderAttribute.strAddressPhone)];
            [cell.lblTip setTextNull:StringFormat(@"%@ %@",self.orderAttribute.strAddressErea,self.orderAttribute.strAddressDetail)];
            return cell;
        }
    }
    if (indexPath.section == 1) {
        
        CellOrderGiftNo *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderGiftNo"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.lblName setTextNull:self.modelDetail.ig_goods_name];
        [cell.imgHead setImagePathListSquare:self.modelDetail.img];
        [cell.lblAttributeName setTextNull:StringFormat(@"数量:%d",self.intNum)];
        [cell.lblPrice setTextNull:StringFormat(@"%@积分",self.modelDetail.ig_goods_integral)];
        return cell;
    }
    
    if (indexPath.section == 2) {
        CellMsgForVendor *cell=[tableView dequeueReusableCellWithIdentifier:@"CellMsgForVendor"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.integerMost = 45;
        [cell.txtMsg setText:self.orderAttribute.strMsg];
        [cell.txtMsg addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }
    CellGoodMoney *cell=[tableView dequeueReusableCellWithIdentifier:@"CellGoodMoney"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.lblMoneyUp setTextColor:ColorRed];
    [cell.lblMoneyDown setTextColor:ColorRed];
    [cell.lblLeftUp setTextColor:ColorBlack];
    [cell.lblMoneyDown setTextColor:ColorGary];
    [cell.lblLeftUp setTextNull:@"商品金额"];
    [cell.lblLeftDown setTextNull:@"+运费"];
    NSString *strMoney = StringFormat(@"%d",[self.modelDetail.ig_goods_integral intValue]*self.intNum);
    [cell.lblMoneyUp setTextNull:StringFormat(@"%@积分",strMoney)];
    [cell.lblMoneyDown setTextNull:StringFormat(@"+￥%@",[NSString stringStandardFloatTwo:self.modelDetail.ig_transfee])];
    return cell;
}

- (void)textFiledEditChanged:(UITextField *)textField{
    self.orderAttribute.strMsg = textField.text;
    D_NSLog(@"text is %@",self.orderAttribute.strMsg);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 10;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    return viHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view endEditing:YES];
    
    if (indexPath.section == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
        OrderesAddressController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderesAddressController"];
        controller.orderAttribute = self.orderAttribute;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (IBAction)clickButtonCommit:(UIButton *)sender {
    if ([NSString isNullString:self.orderAttribute.strAddressId]) {
        [SVProgressHUD showErrorWithStatus:@"请选择收货地址"];
        return;
    }
    [self.view endEditing:YES];
    [SVProgressHUD showWithStatus:@"正在兑换..."];
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestFourZeroAreaExchangeOrderComfilmig_goods_id:[NSString stringStandard:self.modelDetail.ig_goods_id]
                                                                                 andgoodsCont:StringFormat(@"%d",self.intNum)
                                                                                   andigo_msg:[NSString stringStandard:self.orderAttribute.strMsg]
                                                                                    andshopId:[NSString stringStandard:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId]
                                                                                    anduserId:[NSString stringStandard:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId]
                                                                                    andaddrid:[NSString stringStandard:self.orderAttribute.strAddressId]]
                       subscribeNext:^(NSDictionary*dictioanry) {
        @strongify(self)
        [SVProgressHUD dismiss];
        if ([dictioanry[@"code"] intValue] == 1) {
            NSDictionary *dicMiddel = dictioanry[@"data"];
            if ([dicMiddel[@"isFinish"] boolValue]) {
                [JJAlertViewOneButton.new showAlertView:self
                                               andTitle:nil
                                             andMessage:dictioanry[@"msg"]
                                              andCancel:@"确定"
                                          andCanelIsRed:YES
                                                andBack:^{
                    D_NSLog(@"点击了确定");
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
                PayMonyForGoodController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PayMonyForGoodController"];
                controller.strOrderId = [NSString stringStandard:dicMiddel[@"order_id"]];
                controller.strTotalPrice = [NSString stringStandard:dicMiddel[@"total"]];
                controller.not_cash_total = [NSString stringStandard:dicMiddel[@"not_cash_total"]];
                controller.isJifen = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }else{
            [JJAlertViewOneButton.new showAlertView:self
                                           andTitle:nil
                                         andMessage:dictioanry[@"msg"]
                                          andCancel:@"确定"
                                      andCanelIsRed:YES
                                            andBack:^{
                D_NSLog(@"点击了确定");
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }error:^(NSError *error) {
        @strongify(self)
        self.disposable = nil;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }completed:^{
        @strongify(self)
        self.disposable = nil;
    }];
}

@end
