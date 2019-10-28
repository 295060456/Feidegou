//
//  OrderesComfilmController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/15.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "OrderesComfilmController.h"
#import "CellOrderAddressNo.h"
#import "CellOrderAddressYes.h"
#import "CellOrderGiftNo.h"
#import "CellOrderGiftYes.h"
#import "CellDistributionInfo.h"
#import "CellBilInfo.h"
#import "CellMsgForVendor.h"
#import "CellGoodMoney.h"
#import "OrderesAddressController.h"
#import "OrderSendWayController.h"
#import "OrderAttribute.h"
#import "BillSelectedController.h"
#import "JJHttpClient+FourZero.h"
#import "JJHttpClient+ShopGood.h"
#import "PayMonyForGoodController.h"
#import "CellOrderConfilm.h"
#import "JJDBHelper+ShopCart.h"

@interface OrderesComfilmController ()<DidClickOrderDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tabOrder;
@property (weak, nonatomic) IBOutlet UIButton *btnConfilmOrder;
@property (weak, nonatomic) IBOutlet UILabel *lblPriceAll;
@property (strong, nonatomic) OrderAttribute *orderAttribute;

@property (strong, nonatomic) NSDictionary *dicCartFee;
@property (strong, nonatomic) NSMutableArray *arrCartGood;
@end

@implementation OrderesComfilmController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    [self registerLJWKeyboardHandler];
    [self.lblPriceAll setTextColor:ColorHeader];
    [self.tabOrder setBackgroundColor:ColorBackground];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellOrderConfilm" bundle:nil] forCellReuseIdentifier:@"CellOrderConfilm"];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellOrderAddressNo" bundle:nil] forCellReuseIdentifier:@"CellOrderAddressNo"];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellOrderAddressYes" bundle:nil] forCellReuseIdentifier:@"CellOrderAddressYes"];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellOrderGiftNo" bundle:nil] forCellReuseIdentifier:@"CellOrderGiftNo"];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellOrderGiftYes" bundle:nil] forCellReuseIdentifier:@"CellOrderGiftYes"];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellDistributionInfo" bundle:nil] forCellReuseIdentifier:@"CellDistributionInfo"];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellBilInfo" bundle:nil] forCellReuseIdentifier:@"CellBilInfo"];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellMsgForVendor" bundle:nil] forCellReuseIdentifier:@"CellMsgForVendor"];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellGoodMoney" bundle:nil] forCellReuseIdentifier:@"CellGoodMoney"];
    self.orderAttribute = [[OrderAttribute alloc] init];
    
    ModelAddress *modelAddress = [[JJDBHelper sharedInstance] fetchAddressDefault];
    self.orderAttribute.strAddressId = modelAddress.ID;
    self.orderAttribute.strAddressName = modelAddress.trueName;
    self.orderAttribute.strAddressPhone = modelAddress.mobile;
    self.orderAttribute.strAddressErea = modelAddress.area;
    self.orderAttribute.strAddressDetail = modelAddress.area_info;
    
    //    为yes的时候表示要买家承担运费(默认快递)，为no时表示不用付邮费
    if (self.isCart) {
        [self requestOrderBysc_id];
    }else{
        ModelOrderGoodList *model = [MTLJSONAdapter modelOfClass:[ModelOrderGoodList class] fromJSONDictionary:self.dicFromDetial error:nil];
        model.strPayway = TransformString(self.outLine);
        model.billType = enum_billType_no;
        
        if ([model.isPackageMail boolValue]) {
            model.sendWay = enum_sendWay_express;
        }else{
            model.sendWay = enum_sendWay_no;
        }
        self.arrCartGood = [NSMutableArray arrayWithObject:model];
    }
    //    else{
    //        if ([self.dicDetail[@"isPackageMail"] boolValue]) {
    //            self.orderAttribute.sendWay = enum_sendWay_express;
    //        }else{
    //            self.orderAttribute.sendWay = enum_sendWay_no;
    //        }
    //    }
    
    //    self.orderAttribute.billType = enum_billType_no;
    
}

- (void)requestOrderBysc_id{
    [self showException];
    [NSString stringStandard:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId];
    __weak OrderesComfilmController *myself = self;
    self.disposable = [[[JJHttpClient new] requestShopGoodCartToOrderDetailsc_list:self.arrCart anduser_id:[NSString stringStandard:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId]] subscribeNext:^(NSArray*array) {
        myself.arrCartGood = [NSMutableArray arrayWithArray:array];
        
        [myself refreTab];
    }error:^(NSError *error) {
        myself.disposable = nil;
        [myself failedRequestException:enum_exception_timeout];
    }completed:^{
        myself.disposable = nil;
        [myself hideException];
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self refreTab];
}

- (void)refreTab{
    double doubleSendMoney = 0;
    for (int i = 0; i<self.arrCartGood.count; i++) {
        ModelOrderGoodList *model = self.arrCartGood[i];
        doubleSendMoney += [model.storeCart[@"total_price"] doubleValue];
    }
    doubleSendMoney += [[self getSendMoney] doubleValue];
    [self.lblPriceAll setTextNull:StringFormat(@"合计:￥%.2f",doubleSendMoney)];
    //邮费有可能根据用户选择而变化，所以每次进入页面都要更新
    //    if (self.isCart) {
    //        NSString *strMoneyAll = [NSString stringStandardFloatTwo:StringFormat(@"%f",[self.dicCart[@"total_price"] floatValue]+[[self getSendMoney] floatValue])];
    //        [self.lblPriceAll setTextNull:StringFormat(@"合计:￥%@",strMoneyAll)];
    //    }else{
    //
    //        NSString *strMoneyAll = [NSString stringStandardFloatTwo:StringFormat(@"%f",[self.strGoodPrice floatValue]*self.intBuyNum+[[self getSendMoney] floatValue])];
    //        [self.lblPriceAll setTextNull:StringFormat(@"合计:￥%@",strMoneyAll)];
    //    }
    
    [self.tabOrder reloadData];
    //查看是否有收获地址
    if ([NSString isNullString:self.orderAttribute.strAddressId]) {
        [self.btnConfilmOrder setBackgroundColor:ColorGaryButtom];
    }else{
        [self.btnConfilmOrder setBackgroundColor:ColorHeader];
    }
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.arrCartGood.count==0) {
            return 0;
        }
        return 1;
    }
    if (section == 1) {
        return self.arrCartGood.count;
    }
    
    return 0;
    
    //    if (section == 0) {
    //        return 1;
    //    }
    //    if (section == 1) {
    //        if (self.isCart) {
    //            NSArray *array = [NSArray arrayWithArray:self.dicCartFee[@"goods"]];
    //            return array.count;
    //        }
    //        return 1;
    //    }
    //    if (section == 2) {
    //        return 2;
    //    }
    //    if (section == 3) {
    //        if ([self.dicDetail[@"goods"][@"good_area"] intValue]==1&&[NSString isNullString:[[PersonalInfo sharedInstance] fetchLoginUserInfo].service_user]) {
    //            return 2;
    //        }else{
    //            return 1;
    //        }
    //    }
    //    if (section == 4) {
    //        return 1;
    //    }
    //    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70.0f;
    }
    
    //    return 500;
    ModelOrderGoodList *model = self.arrCartGood[indexPath.row];
    CGFloat fHeight = 40+90*model.goodsCart.count+75+40+40+65+10;
    if ([model.goodsCart[0][@"good_area"] intValue]==1) {
        fHeight+=40;
    }
    return fHeight;
    
    //    if (indexPath.section == 1) {
    //
    //        NSDictionary *dicDeliveryGoods = self.dicDetail[@"deliveryGoods"];
    //        if ([dicDeliveryGoods isKindOfClass:[NSDictionary class]]) {
    //            return 110.0f;
    //        }else{
    //            return 90.0f;
    //        }
    //    }
    //    if (indexPath.section == 2) {
    //        if (indexPath.row == 0) {
    //            return 75.0f;
    //        }
    //        if (indexPath.row == 1) {
    //            return 40.0f;
    //        }
    //    }
    //    if (indexPath.section == 3) {
    //        return 40;
    //    }
    //    if (indexPath.section == 4) {
    //        return 65;
    //    }
    //    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    CellOrderConfilm *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderConfilm"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell populateData:self.arrCartGood[indexPath.row] andRow:indexPath.row];
    [cell setDelegete:self];
    return cell;
    //    if (indexPath.section == 1) {
    //        CellOrderGiftNo *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderGiftNo"];
    //        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //        if (self.isCart) {
    //
    //            NSDictionary *dictionray = [NSDictionary dictionaryWithDictionary:self.dicCartFee[@"goods"][indexPath.row]];
    //            [cell populateData:dictionray];
    //        }else{
    //            [cell populateData:self.dicDetail andAttributeName:self.strAttributeName andPirce:self.strGoodPrice andNum:self.intBuyNum];
    //        }
    //        return cell;
    //    }
    //    if (indexPath.section == 2) {
    //
    //        if (indexPath.row == 0) {
    //            CellDistributionInfo *cell=[tableView dequeueReusableCellWithIdentifier:@"CellDistributionInfo"];
    //            [cell.lblPinkage setTextNull:[self getSendIsPinkage]];
    //            [cell.lblSendWay setTextNull:[self getSendWay]];
    //            if ([self.strPayWay intValue]==1) {
    //                [cell.lblPayWay setText:@"线下支付"];
    //            }else{
    //                [cell.lblPayWay setText:@"线上支付"];
    //            }
    //            return cell;
    //        }
    //        if (indexPath.row == 1) {
    //            CellBilInfo *cell=[tableView dequeueReusableCellWithIdentifier:@"CellBilInfo"];
    //            if (self.orderAttribute.billType == enum_billType_personal) {
    //                [cell.lblTip setTextNull:@"个人发票"];
    //            }else if (self.orderAttribute.billType == enum_billType_company) {
    //                [cell.lblTip setTextNull:@"公司发票"];
    //            }else{
    //                [cell.lblTip setTextNull:@"不开发票"];
    //            }
    //            return cell;
    //        }
    //    }
    //    if (indexPath.section == 3) {
    //        CellMsgForVendor *cell=[tableView dequeueReusableCellWithIdentifier:@"CellMsgForVendor"];
    //        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //        if (indexPath.row == 0) {
    //            cell.integerMost = 45;
    //            [cell.txtMsg setPlaceholder:@"选填:给商家留言(45字以内)"];
    //            [cell.txtMsg setText:self.orderAttribute.strMsg];
    //            [cell.txtMsg addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
    //        }else{
    //            cell.integerMost = 20;
    //            [cell.txtMsg setPlaceholder:@"选填:服务人账号"];
    //            [cell.txtMsg setText:self.orderAttribute.strInviter];
    //            [cell.txtMsg addTarget:self action:@selector(textFiledEditChangedInviter:) forControlEvents:UIControlEventEditingChanged];
    //        }
    //        return cell;
    //    }
    //    CellGoodMoney *cell=[tableView dequeueReusableCellWithIdentifier:@"CellGoodMoney"];
    //    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //    [cell.lblMoneyUp setTextColor:ColorRed];
    //    [cell.lblMoneyDown setTextColor:ColorRed];
    //    [cell.lblLeftUp setTextColor:ColorBlack];
    //    [cell.lblMoneyDown setTextColor:ColorGary];
    //    [cell.lblLeftUp setTextNull:@"商品金额"];
    //    [cell.lblLeftDown setTextNull:@"+运费"];
    //
    //    NSString *strMoney;
    //    if (self.isCart) {
    //        strMoney = [NSString stringStandardFloatTwo:StringFormat(@"%@",self.dicCart[@"total_price"])];
    //    }else{
    //        strMoney = [NSString stringStandardFloatTwo:StringFormat(@"%f",[self.strGoodPrice floatValue]*self.intBuyNum)];
    //    }
    //    [cell.lblMoneyUp setTextNull:StringFormat(@"￥%@",strMoney)];
    //    [cell.lblMoneyDown setTextNull:StringFormat(@"+￥%@",[self getSendMoney])];
    //    return cell;
}

- (void)didClickOnlyPeisongfangshiRow:(NSInteger)row{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
    OrderSendWayController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderSendWayController"];
    controller.model = self.arrCartGood[row];
    //    if (self.isCart) {
    //        NSMutableArray *arrImage = [NSMutableArray array];
    //        NSArray *arrFeeImage = self.dicCartFee[@"goods"];
    //        if ([arrFeeImage isKindOfClass:[NSArray class]]) {
    //            for (int i = 0 ; i<arrFeeImage.count; i++) {
    //                [arrImage addObject:arrFeeImage[i][@"path"]];
    //            }
    //        }
    //        controller.arrImage = arrImage;
    //        controller.strPingyou = self.dicCartFee[@"mail_trans_fee"];
    //        controller.strKuaidi = self.dicCartFee[@"express_trans_fee"];
    //        controller.strEMS = self.dicCartFee[@"ems_trans_fee"];
    //    }else{
    //        controller.arrImage = [NSArray arrayWithObject:self.dicDetail[@"goods"][@"icon"]];
    //        controller.strPingyou = self.dicDetail[@"goods"][@"mail_trans_fee"];
    //        controller.strKuaidi = self.dicDetail[@"goods"][@"express_trans_fee"];
    //        controller.strEMS = self.dicDetail[@"goods"][@"ems_trans_fee"];
    //    }
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)didClickOnlyFapiaoRow:(NSInteger)row{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
    BillSelectedController *controller = [storyboard instantiateViewControllerWithIdentifier:@"BillSelectedController"];
    controller.model = self.arrCartGood[row];
    [self.navigationController pushViewController:controller animated:YES];
}
- (void)textFiledEditChanged:(UITextField *)textField{
    self.orderAttribute.strMsg = textField.text;
    D_NSLog(@"text is %@",self.orderAttribute.strMsg);
}
- (void)textFiledEditChangedInviter:(UITextField *)textField{
    self.orderAttribute.strInviter = textField.text;
    D_NSLog(@"text is %@",self.orderAttribute.strMsg);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0||section == 2) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
        OrderesAddressController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderesAddressController"];
        NSArray *arrControllers = self.navigationController.viewControllers;
//        controller.contorller = arrControllers[arrControllers.count-1];
        controller.orderAttribute = self.orderAttribute;
        [self.navigationController pushViewController:controller animated:YES];
    }
    //    if (indexPath.section == 2) {
    //        if (indexPath.row == 0) {
    //            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
    //            OrderSendWayController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderSendWayController"];
    //            controller.orderAttribute = self.orderAttribute;
    //            if (self.isCart) {
    //                NSMutableArray *arrImage = [NSMutableArray array];
    //                NSArray *arrFeeImage = self.dicCartFee[@"goods"];
    //                if ([arrFeeImage isKindOfClass:[NSArray class]]) {
    //                    for (int i = 0 ; i<arrFeeImage.count; i++) {
    //                        [arrImage addObject:arrFeeImage[i][@"path"]];
    //                    }
    //                }
    //                controller.arrImage = arrImage;
    //                controller.strPingyou = self.dicCartFee[@"mail_trans_fee"];
    //                controller.strKuaidi = self.dicCartFee[@"express_trans_fee"];
    //                controller.strEMS = self.dicCartFee[@"ems_trans_fee"];
    //            }else{
    //                controller.arrImage = [NSArray arrayWithObject:self.dicDetail[@"goods"][@"icon"]];
    //                controller.strPingyou = self.dicDetail[@"goods"][@"mail_trans_fee"];
    //                controller.strKuaidi = self.dicDetail[@"goods"][@"express_trans_fee"];
    //                controller.strEMS = self.dicDetail[@"goods"][@"ems_trans_fee"];
    //            }
    //            [self.navigationController pushViewController:controller animated:YES];
    //        }
    //        if (indexPath.row == 1) {
    //            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
    //            BillSelectedController *controller = [storyboard instantiateViewControllerWithIdentifier:@"BillSelectedController"];
    //            controller.orderAttribute = self.orderAttribute;
    //            [self.navigationController pushViewController:controller animated:YES];
    //        }
    //    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickButtonConflimOrder:(UIButton *)sender {
    if ([NSString isNullString:self.orderAttribute.strAddressId]) {
        [SVProgressHUD showErrorWithStatus:@"请选择收货地址"];
        return;
    }
    
    
    //参数（接口编码：num，商品属性：spec_info，商品数量：count，发票类型：invoiceType          0：个人   1：公司   2:不开发票，  公司抬头：invoic， 留言：msg，  地址id：addr_id，用户id：user_id  商城的useridShop，送货方式：transport   平邮，快递，EMS ）支付方式：payType（1：微信  2：支付宝）商品id：goods_id
    [SVProgressHUD showWithStatus:@"正在生成订单..."];
    //    NSString *strSendWay = @"快递";
    //    if (self.orderAttribute.sendWay == enum_sendWay_mail) {
    //        strSendWay = @"平邮";
    //    }
    //    if (self.orderAttribute.sendWay == enum_sendWay_express) {
    //        strSendWay = @"快递";
    //    }
    //    if (self.orderAttribute.sendWay == enum_sendWay_ems) {
    //        strSendWay = @"ems";
    //    }
    __weak OrderesComfilmController *myself = self;
    if (self.isCart) {
        NSMutableDictionary *dicRequest = [NSMutableDictionary dictionary];
        [dicRequest setObject:self.orderAttribute.strAddressId forKey:@"addr_id"];
        [dicRequest setObject:@"weixin" forKey:@"isWxmini"];
        [dicRequest setObject:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId forKey:@"user_id"];
        //    {[sc_id=店铺购物车ID,invoicetype=发票类型,msg=留言,transport=配送方式,invoic=公司名称，ship_price=邮费，goodsid=[商品购物车id,商品购物车id,商品购物车id]]..}
        NSMutableArray *sc_list = [NSMutableArray array];
        for (int i = 0; i<self.arrCartGood.count; i++) {
            ModelOrderGoodList *model = self.arrCartGood[i];
            NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionary];
            [dicMiddle setObject:model.storeCart[@"id"] forKey:@"sc_id"];
            NSString *strSendWay = @"快递";
            if (model.sendWay == enum_sendWay_mail) {
                strSendWay = @"平邮";
            }
            if (model.sendWay == enum_sendWay_express) {
                strSendWay = @"快递";
            }
            if (model.sendWay == enum_sendWay_ems) {
                strSendWay = @"ems";
            }
            [dicMiddle setObject:strSendWay forKey:@"transport"];
            [dicMiddle setObject:StringFormat(@"%u",model.billType) forKey:@"invoiceType"];
            [dicMiddle setObject:[NSString stringStandard:model.strCompanyName] forKey:@"invoic"];
            [dicMiddle setObject:[NSString stringStandard:model.strMsg] forKey:@"msg"];
            double doubleSendMoney = 0;
            if (model.sendWay == enum_sendWay_no) {
                
            }else if (model.sendWay == enum_sendWay_ems){
                doubleSendMoney += [model.ems_trans_fee doubleValue];
            }else if (model.sendWay == enum_sendWay_express){
                doubleSendMoney += [model.express_trans_fee doubleValue];
            }else{
                doubleSendMoney += [model.mail_trans_fee doubleValue];
            }
            [dicMiddle setObject:StringFormat(@"%.2f",doubleSendMoney) forKey:@"ship_price"];
            NSMutableArray *goodsid = [NSMutableArray array];
            for (int j = 0; j<model.goodsCart.count; j++) {
                [goodsid addObject:model.goodsCart[j][@"id"]];
            }
            [dicMiddle setObject:goodsid forKey:@"goodsid"];
            [sc_list addObject:dicMiddle];
        }
        [dicRequest setObject:sc_list forKey:@"sc_list"];
        
        self.disposable = [[[JJHttpClient new] requestFourZeroCommitOrderCommit:dicRequest] subscribeNext:^(NSDictionary*dictinary) {
            D_NSLog(@"msg is %@",dictinary[@"msg"]);
            if ([dictinary[@"code"] intValue]==1) {
                [SVProgressHUD dismiss];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
                PayMonyForGoodController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PayMonyForGoodController"];
                controller.isCart = YES;
                controller.strOrderId = [NSString stringStandard:dictinary[@"order_id"]];
                controller.strTotalPrice = [NSString stringStandard:dictinary[@"totalPrice"]];
                controller.strOfId = [NSString stringStandard:dictinary[@"id"]];
                [self.navigationController pushViewController:controller animated:YES];
            }else{
                [SVProgressHUD showErrorWithStatus:dictinary[@"msg"]];
            }
            
        }error:^(NSError *error) {
            myself.disposable = nil;
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }completed:^{
            myself.disposable = nil;
        }];
    }else{
        
        ModelOrderGoodList *model = self.arrCartGood[0];
        NSString *strSendWay = @"快递";
        if (model.sendWay == enum_sendWay_mail) {
            strSendWay = @"平邮";
        }
        if (model.sendWay == enum_sendWay_express) {
            strSendWay = @"快递";
        }
        if (model.sendWay == enum_sendWay_ems) {
            strSendWay = @"ems";
        }
        self.disposable = [[[JJHttpClient new] requestFourZeroCommitOrderInvoiceType:StringFormat(@"%u",model.billType) andInvoic:[NSString stringStandard:model.strCompanyName] andMsg:[NSString stringStandard:model.strMsg] andAddr_id:[NSString stringStandard:self.orderAttribute.strAddressId] andUser_id:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId andTransport:strSendWay andCount:model.goodsCart[0][@"count"] andSpec_info:[NSString stringStandard:model.goodsCart[0][@"spec_info"]] andGoods_id:[NSString stringStandard:model.goodsCart[0][@"goods_id"]] andProperty:[NSString stringStandard:model.goodsCart[0][@"attribute"]] andservice_user:[NSString stringStandard:model.strInviter]] subscribeNext:^(NSDictionary*dictinary) {
            D_NSLog(@"msg is %@",dictinary[@"msg"]);
            if ([dictinary[@"code"] intValue]==1) {
                [SVProgressHUD dismiss];
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
                PayMonyForGoodController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PayMonyForGoodController"];
                controller.strOrderId = [NSString stringStandard:dictinary[@"order_id"]];
                controller.strTotalPrice = [NSString stringStandard:dictinary[@"totalPrice"]];
                controller.strOfId = [NSString stringStandard:dictinary[@"id"]];
                [self.navigationController pushViewController:controller animated:YES];
                
            }else{
                [SVProgressHUD showErrorWithStatus:dictinary[@"msg"]];
            }
            
        }error:^(NSError *error) {
            //            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
            //            PayMonyForGoodController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PayMonyForGoodController"];
            //            controller.strOrderId = [NSString stringStandard:dictinary[@"order_id"]];
            //            controller.strTotalPrice = [NSString stringStandard:dictinary[@"totalPrice"]];
            //            [self.navigationController pushViewController:controller animated:YES];
            myself.disposable = nil;
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }completed:^{
            myself.disposable = nil;
        }];
    }
}
- (NSString *)getSendIsPinkage{
    NSString *strSendWay = @"商家配送";
    //    为yes的时候表示要买家承担运费，为no时表示不用付邮费
    if (self.orderAttribute.sendWay == enum_sendWay_no) {
        strSendWay = @"商家配送";
    }else{
        strSendWay = @"买家承担";
        NSString *strTip;
        if (self.orderAttribute.sendWay == enum_sendWay_ems){
            strTip = @"EMS";
        }else if (self.orderAttribute.sendWay == enum_sendWay_express){
            strTip = @"快递";
        }else{
            strTip = @"平邮";
        }
        strSendWay = StringFormat(@"%@(%@)",strSendWay,strTip);
    }
    return strSendWay;
}
- (NSString *)getSendWay{
    NSString *strSendWay = @"由商家选择合作快递为您配送";
    
    return strSendWay;
}
- (NSString *)getSendMoney{
    double doubleSendMoney = 0;
    for (int i = 0; i<self.arrCartGood.count; i++) {
        ModelOrderGoodList *model = self.arrCartGood[i];
        if (model.sendWay == enum_sendWay_no) {
            
        }else if (model.sendWay == enum_sendWay_ems){
            doubleSendMoney += [model.ems_trans_fee doubleValue];
        }else if (model.sendWay == enum_sendWay_express){
            doubleSendMoney += [model.express_trans_fee doubleValue];
        }else{
            doubleSendMoney += [model.mail_trans_fee doubleValue];
        }
    }
    return StringFormat(@"%.2f",doubleSendMoney);
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
