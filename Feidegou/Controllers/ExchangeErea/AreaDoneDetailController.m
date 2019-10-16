//
//  AreaDoneDetailController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/9/12.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "AreaDoneDetailController.h"
#import "CellOrderTwoLbl.h"
#import "CellOrderThreeLbl.h"
#import "CellOrderVendorTitle.h"
#import "CellOrderDetailGiftNo.h"
#import "CellOrderDetailGiftYes.h"
#import "CellOrderAddress.h"
#import "CellOrderMoney.h"
#import "CellGoodMoney.h"
#import "CellOrderDetailLogistics.h"
#import "CellOrderDetialNumber.h"
#import "OrderLogisticsDetailController.h"
#import "PayMonyForGoodController.h"
#import "JJHttpClient+ShopGood.h"
#import "OrderDiscussController.h"

@interface AreaDoneDetailController ()

@property (weak, nonatomic) IBOutlet UITableView *tabOrderDetail;
@property (weak, nonatomic) IBOutlet UIButton *btnOne;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintHeight;
@property (strong, nonatomic) NSDictionary *dicPost;
@property (strong, nonatomic) NSMutableArray *arrPost;
@property (strong, nonatomic) ModelAreaDetail *modelDetail;

@end

@implementation AreaDoneDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    self.layoutConstraintHeight.constant = 0;
    [self.tabOrderDetail setBackgroundColor:ColorBackground];
    [self.tabOrderDetail registerNib:[UINib nibWithNibName:@"CellOrderTwoLbl" bundle:nil] forCellReuseIdentifier:@"CellOrderTwoLbl"];
    [self.tabOrderDetail registerNib:[UINib nibWithNibName:@"CellOrderThreeLbl" bundle:nil] forCellReuseIdentifier:@"CellOrderThreeLbl"];
    [self.tabOrderDetail registerNib:[UINib nibWithNibName:@"CellOrderVendorTitle" bundle:nil] forCellReuseIdentifier:@"CellOrderVendorTitle"];
    [self.tabOrderDetail registerNib:[UINib nibWithNibName:@"CellOrderDetailGiftNo" bundle:nil] forCellReuseIdentifier:@"CellOrderDetailGiftNo"];
    [self.tabOrderDetail registerNib:[UINib nibWithNibName:@"CellOrderDetailGiftYes" bundle:nil] forCellReuseIdentifier:@"CellOrderDetailGiftYes"];
    [self.tabOrderDetail registerNib:[UINib nibWithNibName:@"CellOrderAddress" bundle:nil] forCellReuseIdentifier:@"CellOrderAddress"];
    [self.tabOrderDetail registerNib:[UINib nibWithNibName:@"CellOrderMoney" bundle:nil] forCellReuseIdentifier:@"CellOrderMoney"];
    [self.tabOrderDetail registerNib:[UINib nibWithNibName:@"CellGoodMoney" bundle:nil] forCellReuseIdentifier:@"CellGoodMoney"];
    [self.tabOrderDetail registerNib:[UINib nibWithNibName:@"CellOrderDetailLogistics" bundle:nil] forCellReuseIdentifier:@"CellOrderDetailLogistics"];
    [self.tabOrderDetail registerNib:[UINib nibWithNibName:@"CellOrderDetialNumber" bundle:nil] forCellReuseIdentifier:@"CellOrderDetialNumber"];
    [self.btnOne.layer setBorderWidth:0.5];
    [self.btnOne.layer setBorderColor:ColorRed.CGColor];
    [self.btnOne setTitleColor:ColorRed forState:UIControlStateNormal];
    [self.btnOne setBackgroundColor:[UIColor whiteColor]];
    [self requestData];
}

- (void)requestLogisticsInformation{
    if ([NSString isNullString:self.modelDetail.igo_ship_code]) {
        return;
    }
    self.layoutConstraintHeight.constant = 40;
    __weak AreaDoneDetailController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodOrderDetailLogisticsInformationType:[NSString stringStandard:self.modelDetail.ship_code]
                                                                                      andPostid:[NSString stringStandard:self.modelDetail.igo_ship_code]]
                         subscribeNext:^(NSDictionary* dictionary) {
        //        如果是字典，则表示有物流信息
        //        如果数组有数据，则表示有具体的物流信息
        myself.arrPost = [NSMutableArray array];
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            myself.dicPost = [NSDictionary dictionaryWithDictionary:dictionary];
            NSArray *array = dictionary[@"data"];
            if ([array isKindOfClass:[NSArray class]]&&array.count>0) {
                [myself.arrPost addObjectsFromArray:array];
            }
        }else{
            myself.dicPost = nil;
        }
        [myself.tabOrderDetail reloadData];
        
        
    }error:^(NSError *error) {
        myself.disposable = nil;
    }completed:^{
        myself.disposable = nil;
    }];
}

- (void)requestData{
    [self showException];
    
    __weak AreaDoneDetailController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodOrderDetailAreaExchangeorderId:self.modelList.orderId] subscribeNext:^(ModelAreaDetail *model) {
        myself.modelDetail = model;
        [myself requestLogisticsInformation];
        [myself.tabOrderDetail reloadData];
    }error:^(NSError *error) {
        [myself failedRequestException:enum_exception_timeout];
        myself.disposable = nil;
    }completed:^{
        myself.disposable = nil;
        [myself hideException];
    }];
}

#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 3;
    }
    if (section == 2) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (self.arrPost.count>0) {
                NSDictionary *dicInfo = self.arrPost[0];
                if ([dicInfo isKindOfClass:[NSDictionary class]]) {
                    NSString *strContent = dicInfo[@"context"];
                    CGFloat fHeight = [NSString conculuteRightCGSizeOfString:strContent andWidth:SCREEN_WIDTH-65 andFont:15.0].height+40;
                    return fHeight;
                    
                }
            }
            return 0.0f;
        }
        if (indexPath.row == 1) {
            NSString *strAddress = StringFormat(@"收货地址:%@",self.modelDetail.area_info);
            CGFloat fHeight = [NSString conculuteRightCGSizeOfString:strAddress andWidth:SCREEN_WIDTH-40 andFont:13.0].height+40;
            return fHeight;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 40.0f;
        }
        if (indexPath.row == 1) {
            return 100.0f;
        }
        if (indexPath.row == 2) {
            return 65.0f;
        }
    }
    if (indexPath.section==2) {
        return 105.0f;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        if (indexPath.row ==0) {
            CellOrderDetailLogistics *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderDetailLogistics"];
            
            if (self.arrPost.count>0) {
                [cell.lblTitle setTextNull:@""];
                [cell.lblTime setTextNull:[PublicFunction translateTimeHMS:@""]];
                if (self.arrPost.count>0) {
                    NSDictionary *dicInfo = self.arrPost[0];
                    if ([dicInfo isKindOfClass:[NSDictionary class]]) {
                        [cell.lblTitle setTextColor:ColorGreen];
                        [cell.lblTime setTextColor:ColorGary];
                        [cell.lblTitle setTextNull:dicInfo[@"context"]];
                        [cell.lblTime setTextNull:[PublicFunction translateTimeHMS:dicInfo[@"time"]]];
                    }
                }
                [cell.imgType setHidden:NO];
                [cell.imgArrow setHidden:NO];
            }else{
                [cell.lblTime setText:@""];
                [cell.lblTitle setText:@""];
                [cell.imgType setHidden:YES];
                [cell.imgArrow setHidden:YES];
            }
            return cell;
        }
        if (indexPath.row == 1) {
            CellOrderAddress *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderAddress"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell populateDataArea:self.modelDetail];
            return cell;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            CellOrderVendorTitle *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderVendorTitle"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            NSString *strName = @"平台自营店";
            CGFloat fWidth = [NSString conculuteRightCGSizeOfString:strName andWidth:SCREEN_WIDTH-40 andFont:15.0].width;
            cell.layoutConstrintWidth.constant = fWidth;
            [cell.lblType setHidden:YES];
            [cell.lblType setTextNull:strName];
            return cell;
        }
        if (indexPath.row == 1) {
            CellOrderDetailGiftYes *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderDetailGiftYes"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.lblName setTextNull:self.modelDetail.ig_goods_name];
            [cell.lblAttribute setTextNull:@""];
            [cell.lblPriceSale setTextNull:StringFormat(@"%@积分",[NSString stringStandardZero:self.modelDetail.integral])];
            
            [cell.lblNum setTextNull:StringFormat(@"x%@",[NSString stringStandardZero:self.modelDetail.count])];
//            [cell.imgHead setImagePathList:self.modelDetail.path];
//            [cell.btnRefund setHidden:YES];
            return cell;
        }
        if (indexPath.row == 2) {
            
            CellGoodMoney *cell=[tableView dequeueReusableCellWithIdentifier:@"CellGoodMoney"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.lblLeftUp setFont:[UIFont systemFontOfSize:13.0]];
            [cell.lblLeftDown setFont:[UIFont systemFontOfSize:15.0]];
            [cell.lblMoneyUp setFont:[UIFont systemFontOfSize:13.0]];
            [cell.lblMoneyDown setFont:[UIFont systemFontOfSize:13.0]];
            [cell.lblMoneyUp setTextColor:ColorBlack];
            [cell.lblLeftUp setText:@"运费"];
            [cell.lblLeftDown setText:@"实付款(含运费)"];
            [cell.lblMoneyUp setText:@"￥0.00"];
            NSString *strMony = [NSString stringStandardZero:self.modelDetail.integral];
            NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"%@积分",strMony)];
            [cell.lblMoneyDown setAttributedText:atrString];
            return cell;
        }
    }
    if (indexPath.section == 2) {
        
        CellOrderDetialNumber *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderDetialNumber"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.lblNum setText:StringFormat(@"订单编号: %@",self.modelDetail.orderid)];
        [cell.lblTimeCreate setText:StringFormat(@"创建时间: %@",[PublicFunction translateTimeHMS:self.modelDetail.addTime])];;
        [cell.lblTimePay setText:StringFormat(@"付款时间: %@",[PublicFunction translateTimeHMS:self.modelDetail.igo_pay_time])];;
        //            [cell.lblTimeSend setText:StringFormat(@"发货时间: %@",[LocationHeaper translateTimeHMS:self.modelOrderDetail.shipTime])];
        
//        [cell.lblTimeCreate setText:StringFormat(@"创建时间: %@",[NSString stringStandardZanwu:self.modelDetail.addTime])];;
//        [cell.lblTimePay setText:StringFormat(@"付款时间: %@",[NSString stringStandardZanwu:self.modelDetail.igo_pay_time])];;
        [cell.lblTimeSend setText:StringFormat(@"发货时间: %@",[NSString stringStandardZanwu:self.modelDetail.igo_ship_time])];
        return cell;
    }
    CellOrderTwoLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderTwoLbl"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.lblLeft setText:@""];
    [cell.lblRight setText:@""];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    return viHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (![NSString isNullString:self.modelDetail.igo_ship_code] && indexPath.row == 0 && indexPath.section == 0) {
        //        跳到物流详情
        [self pushOrderLogist];
    }
}

- (IBAction)clickButtonCheckWuliu:(UIButton *)sender {
    
    if (![NSString isNullString:self.modelDetail.igo_ship_code]) {
        //        跳到物流详情
        [self pushOrderLogist];
    }
    
}

- (void)pushOrderLogist{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
    OrderLogisticsDetailController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderLogisticsDetailController"];
    controller.strPath = self.modelDetail.path;
    controller.strCount = self.modelDetail.count;
    controller.strGoodCode = self.modelDetail.igo_ship_code;
    controller.strCompanyCode = self.modelDetail.ship_code;
    controller.strCompanyName = self.modelDetail.ship_name;
    [self.navigationController pushViewController:controller animated:YES];
}


@end
