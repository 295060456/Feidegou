//
//  OrderDetailController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/17.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "OrderDetailController.h"
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
#import "JJHttpClient+FourZero.h"
#import "DiscussOrderController.h"
#import "GoodOtherListController.h"
#import "CellOneButton.h"
#import "JJHttpClient+ShopGood.h"
#import "CellTuihuoInfo.h"
#import "CellTwoLblArrow.h"
#import "OrderTuihuoController.h"
#import "CellTuihuoWuliu.h"


@interface OrderDetailController ()

@property (weak, nonatomic) IBOutlet UITableView *tabOrderDetail;
@property (weak, nonatomic) IBOutlet UIView *viTimes;
@property (weak, nonatomic) IBOutlet UIButton *btnOne;
@property (weak, nonatomic) IBOutlet UIButton *btnTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnThree;
@property (strong, nonatomic) ModelOrderDtail *modelOrderDetail;
@property (assign, nonatomic) enumOrderState orderState;
@property (strong, nonatomic) NSDictionary *dicPost;
@property (strong, nonatomic) NSMutableArray *arrPost;
@property (assign, nonatomic) BOOL isShowMoreDetail;
@property (nonatomic,strong) RACDisposable *disposableDelete;
@property (nonatomic,strong) RACDisposable *disposableShouhuo;
//四种状态：第一种是等待商家确认信息，第二种是拒绝退货，第三种是填写退货订单号，第四种是填写成功之后查看物流信息
//intstate大于0，则显示这四种状态
@property (assign, nonatomic) int intState;

@end

@implementation OrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    
    [self.btnOne.layer setBorderWidth:0.5];
    [self.btnOne.layer setBorderColor:ColorRed.CGColor];
    [self.btnOne setTitleColor:ColorRed forState:UIControlStateNormal];
    [self.btnTwo.layer setBorderWidth:0.5];
    [self.btnTwo.layer setBorderColor:ColorLine.CGColor];
    [self.btnTwo setTitleColor:ColorBlack forState:UIControlStateNormal];
    [self.btnThree.layer setBorderWidth:0.5];
    [self.btnThree.layer setBorderColor:ColorLine.CGColor];
    [self.btnThree setTitleColor:ColorBlack forState:UIControlStateNormal];
    [self.tabOrderDetail setBackgroundColor:ColorBackground];
    [self.tabOrderDetail registerNib:[UINib nibWithNibName:@"CellTuihuoWuliu" bundle:nil] forCellReuseIdentifier:@"CellTuihuoWuliu"];
    [self.tabOrderDetail registerNib:[UINib nibWithNibName:@"CellTwoLblArrow" bundle:nil] forCellReuseIdentifier:@"CellTwoLblArrow"];
    [self.tabOrderDetail registerNib:[UINib nibWithNibName:@"CellTuihuoInfo" bundle:nil] forCellReuseIdentifier:@"CellTuihuoInfo"];
    [self.tabOrderDetail registerNib:[UINib nibWithNibName:@"CellOneButton" bundle:nil] forCellReuseIdentifier:@"CellOneButton"];
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
    [self.btnTwo.layer setBorderWidth:0.5];
    [self.btnTwo.layer setBorderColor:ColorLine.CGColor];
    [self.btnTwo setTitleColor:ColorBlack forState:UIControlStateNormal];
    [self.btnOne setBackgroundColor:[UIColor whiteColor]];
    [self.btnTwo setBackgroundColor:[UIColor whiteColor]];
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationPaySucceedChangeData:) name:NotificationNamePaySucceedChangeData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationDiscussSucceed:) name:NotificationNameDiscussSucceed object:nil];
}

- (void)NotificationPaySucceedChangeData:(NSNotification *)notification{
    NSString *strOrderId = TransformString((NSString *)notification.object);
    NSString *strOrderIdMiddle = TransformString(self.modelList.order_id);
    if ([strOrderId isEqualToString:strOrderIdMiddle]) {
        if (!self.orderState) {
            self.modelOrderDetail.order_status = @"20";
        }
    }
    [self refreshButtonTitle];
}

- (void)NotificationDiscussSucceed:(NSNotification *)notification{
    NSString *strOrderId = TransformString((NSString *)notification.object);
    NSString *strOrderIdMiddle = TransformString(self.modelList.order_id);
    if ([strOrderId isEqualToString:strOrderIdMiddle]) {
        if (!self.orderState) {
            self.modelOrderDetail.order_status = @"50";
        }
    }
    [self refreshButtonTitle];
}

- (void)requestLogisticsInformation{
    
    if (self.isShowMoreDetail) {
        return;
    }
    if ([NSString isNullString:self.modelOrderDetail.courierCode]) {
        return;
    }
    __weak OrderDetailController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodOrderDetailLogisticsInformationType:[NSString stringStandard:self.modelOrderDetail.company_mark]
                                                                                      andPostid:self.modelOrderDetail.courierCode]
                         subscribeNext:^(NSDictionary* dictionary) {
//        如果是字典，则表示有物流信息
//        如果数组有数据，则表示有具体的物流信息
        self.arrPost = [NSMutableArray array];
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            self.dicPost = [NSDictionary dictionaryWithDictionary:dictionary];
            NSArray *array = dictionary[@"data"];
            if ([array isKindOfClass:[NSArray class]]&&array.count>0) {
                [self.arrPost addObjectsFromArray:array];
            }
        }else{
            self.dicPost = nil;
        }
        [self.tabOrderDetail reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0
                                                                         inSection:0]]
                                   withRowAnimation:UITableViewRowAnimationFade];
        
        
    }error:^(NSError *error) {
        [myself failedRequestException:enum_exception_timeout];
        myself.disposable = nil;
    }completed:^{
        myself.disposable = nil;
    }];
}
- (void)requestData{
    [self showException];
    
    __weak OrderDetailController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodOrderDetailOrderId:[NSString stringStandard:self.modelList.ID]]
                         subscribeNext:^(ModelOrderDtail* model) {
        myself.modelOrderDetail = model;
        [myself refreshButtonTitle];
        [myself hideException];
    }error:^(NSError *error) {
        [myself failedRequestException:enum_exception_timeout];
        myself.disposable = nil;
    }completed:^{
        myself.disposable = nil;
    }];
}

- (void)refreshButtonTitle{
    self.orderState = [PublicFunction returnStateByNum:self.modelOrderDetail.order_status];
    if (self.orderState == enumOrder_dfk||self.orderState == enumOrder_yfk||self.orderState == enumOrder_tksh) {
        self.isShowMoreDetail = YES;
    }else{
        self.isShowMoreDetail = NO;
    }
    int orderState = [self.modelOrderDetail.order_status intValue];
    self.intState = 0;
    if (orderState==45) {
        self.intState = 1;
    }else if (orderState==48) {
        self.intState = 2;
    }else if (orderState==46) {
        self.intState = 3;
    }else if (orderState==47) {
        self.intState = 4;
    }
    if (self.intState>0) {
        self.isShowMoreDetail = YES;
    }
    [self requestLogisticsInformation];
    [self.tabOrderDetail reloadData];
    
    NSMutableArray *
    arrButton = [PublicFunction returnButtonNameByNum:self.modelOrderDetail.order_status
                                      andIsNeedDetail:NO
                                       andcourierCode:self.modelOrderDetail.courierCode];
    [self.btnOne setHidden:YES];
    [self.btnTwo setHidden:YES];
    [self.btnThree setHidden:YES];
    for (int i = 0; i<arrButton.count; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i+10];
        [button setHidden:NO];
        [button setTitle:arrButton[i] forState:UIControlStateNormal];
    }
    
//    switch (self.orderState) {
//        case enumOrder_dfk:{
//            [self.btnOne setHidden:NO];
//            [self.btnTwo setHidden:NO];
//            [self.btnOne setTitle:@"去支付" forState:UIControlStateNormal];
//            [self.btnTwo setTitle:@"取消订单" forState:UIControlStateNormal];
//        }
//            break;
//        case enumOrder_yfk:{
//            [self.btnOne setHidden:NO];
//            [self.btnTwo setHidden:YES];
//            [self.btnOne setTitle:@"确认收货" forState:UIControlStateNormal];
//        }
//            break;
//        case enumOrder_yfh:{
//            [self.btnOne setHidden:NO];
//            [self.btnTwo setHidden:YES];
//            [self.btnOne setTitle:@"确认收货" forState:UIControlStateNormal];
//            if (![NSString isNullString:self.modelOrderDetail.courierCode]) {
//                [self.btnTwo setHidden:NO];
//                [self.btnTwo setTitle:@"查看物流" forState:UIControlStateNormal];
//            }
//        }
//            break;
//
//        case enumOrder_ysh:{
//            [self.btnOne setHidden:NO];
//            [self.btnTwo setHidden:YES];
//            [self.btnOne setTitle:@"去评价" forState:UIControlStateNormal];
//            if (![NSString isNullString:self.modelOrderDetail.courierCode]) {
//                [self.btnTwo setHidden:NO];
//                [self.btnTwo setTitle:@"查看物流" forState:UIControlStateNormal];
//            }
//        }
//            break;
//
//        default:{
//            [self.btnOne setHidden:YES];
//            [self.btnTwo setHidden:YES];
//            if (![NSString isNullString:self.modelOrderDetail.courierCode]) {
//                [self.btnOne setHidden:NO];
//                [self.btnOne setTitle:@"查看物流" forState:UIControlStateNormal];
//            }
//        }
//            break;
//    }
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isShowMoreDetail) {
        if (section == 0) {
//            订单号
            return 1;
        }else if (section == 1) {
//            收货地址
            return 1;
        }else if (section == 2) {
//            店铺名字
            return 1;
        }else if (section == 3) {
//            商品
            NSArray *array = self.modelOrderDetail.goods;
            return array.count;
        }else if (section == 4) {
//            联系卖家
            return 1;
        }else if (section == 5) {
//            支付方式等
            return 3;
        }else if (section == 6) {
            if (self.intState ==1) {
                return 1;
            }else if (self.intState ==2) {
                return 2;
            }else if (self.intState ==3||self.intState == 4) {
                return 3;
            }
            return 0;
        }else{
//            价格等
            return 2;
        }
    }else{
        if (section == 0) {
            //            物流信息
            return 1;
        }else if (section == 1) {
            //            收货地址
            return 1;
        }else if (section == 2) {
            //            店铺名字
            return 1;
        }else if (section == 3) {
            //            商品
            NSArray *array = self.modelOrderDetail.goods;
            return array.count;
        }else if (section == 4) {
            //            联系卖家
            return 1;
        }else if (section == 5) {
            //            支付方式等
            return 3;
        }else if (section ==6) {
            //            价格
            return 1;
        }else{
            //            订单信息
            return 1;
        }
    }return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isShowMoreDetail) {
        return 8;
    }else{
        return 8;
    }return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isShowMoreDetail) {
        if (indexPath.section == 0) {
            return 40.0f;
        }else if (indexPath.section == 1) {
            NSString *strAddress = StringFormat(@"收货地址:%@",self.modelOrderDetail.area_info);
            CGFloat fHeight = [NSString conculuteRightCGSizeOfString:strAddress andWidth:SCREEN_WIDTH-40 andFont:13.0].height+40;
            return fHeight;
        }else if (indexPath.section == 2) {
            return 30.0f;
        }else if (indexPath.section == 3) {
//            商品
            return 100.0;
        }else if (indexPath.section == 4) {
//            联系卖家
            return 50.0f;
        }else if (indexPath.section == 5) {
            return 40.0f;
        }else if (indexPath.section == 6) {
            if (indexPath.row == 0) {
                return [NSString conculuteRightCGSizeOfString:self.modelOrderDetail.refund[@"refund_log"] andWidth:SCREEN_WIDTH-20 andFont:13.0].height+40;
            }
            if (indexPath.row == 1) {
                return [NSString conculuteRightCGSizeOfString:self.modelOrderDetail.refund[@"seller_info"] andWidth:SCREEN_WIDTH-20 andFont:13.0].height+40;
            }
            if (indexPath.row ==2) {
                return 60;
            }
            return 60.0f;
        }else{
            return 65.0f;
        }
    }else{
        if (indexPath.section == 0) {
            if (self.arrPost.count>0) {
                NSDictionary *dicInfo = self.arrPost[0];
                if ([dicInfo isKindOfClass:[NSDictionary class]]) {
                    NSString *strContent = dicInfo[@"context"];
                    CGFloat fHeight = [NSString conculuteRightCGSizeOfString:strContent andWidth:SCREEN_WIDTH-65 andFont:15.0].height+40;
                    return fHeight;
                }
            }
            return 0.0f;
        }else if (indexPath.section == 1) {
            NSString *strAddress = StringFormat(@"收货地址:%@",self.modelOrderDetail.area_info);
            CGFloat fHeight = [NSString conculuteRightCGSizeOfString:strAddress andWidth:SCREEN_WIDTH-40 andFont:13.0].height+40;
            return fHeight;
        }else if (indexPath.section == 2) {
            return 30.0f;
        }else if (indexPath.section == 3) {
            //            商品
            return 100.0;
        }else if (indexPath.section == 4) {
            //            联系卖家
            return 50.0f;
        }else if (indexPath.section == 5) {
            return 40.0f;
        }else if (indexPath.section == 6) {
            return 65.0f;
        }else{
            return 105.0f;
        }
    }return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isShowMoreDetail) {
        if (indexPath.section == 0) {
            CellOrderTwoLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderTwoLbl"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.lblLeft setText:StringFormat(@"订单号:%@",self.modelOrderDetail.order_id)];
            
            
            NSString *strType = @"交易成功";
            enumOrderState state = [PublicFunction returnStateByNum:self.modelOrderDetail.order_status];
            if (state == enumOrder_dfk) {
                strType = @"等待付款";
            }
            if (state == enumOrder_yfk) {
                strType = @"等待发货";
            }
            if (state == enumOrder_yfh) {
                strType = @"商家已发货";
            }
            if (state == enumOrder_ysh) {
                strType = @"待评价";
            }
            [cell.lblRight setText:strType];
            [cell.lblLeft setTextColor:ColorBlack];
            [cell.lblRight setTextColor:ColorRed];
            return cell;
        }
        if (indexPath.section == 1) {
            CellOrderAddress *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderAddress"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell populateData:self.modelOrderDetail];
            return cell;
        }
        
        if (indexPath.section == 2) {
            CellOrderVendorTitle *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderVendorTitle"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell populateDataNoType:self.modelOrderDetail];
            return cell;
        }
        
        if (indexPath.section == 3) {
            CellOrderDetailGiftYes *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderDetailGiftYes"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:ColorCellBack];
            [cell populateData:self.modelOrderDetail.goods[indexPath.row]];
            return cell;
        }
        if (indexPath.section == 4) {
            
            CellOneButton *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOneButton"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.btnCommit handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                NSString *strPhone = self.modelOrderDetail.store_telephone;
                if ([NSString isNullString:strPhone]) {
                    [SVProgressHUD showErrorWithStatus:@"该商家未填写电话"];
                    return ;
                }
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",strPhone];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }];
            return cell;
        }
        if (indexPath.section == 5) {
            if (indexPath.row == 0) {
                CellOrderTwoLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderTwoLbl"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.lblLeft setText:@"支付方式"];
                [cell.lblRight setText:@"在线支付"];
                return cell;
            }else if (indexPath.row == 1) {
                CellOrderTwoLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderTwoLbl"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.lblLeft setText:@"配送方式"];
                if ([self.modelOrderDetail.ship_price intValue]==0) {
                    [cell.lblRight setTextNull:@"商家配送"];
                }else{
                    [cell.lblRight setTextNull:self.modelOrderDetail.transport];
                }
                return cell;
            }else{
                CellOrderTwoLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderTwoLbl"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.lblLeft setText:@"发票信息"];
                NSString *strPrice = self.modelOrderDetail.invoiceType;
                if ([strPrice floatValue]==2) {
                    [cell.lblRight setText:@"不开发票"];
                }else if ([strPrice floatValue]==1) {
                    [cell.lblRight setText:@"公司发票"];
                }else{
                    [cell.lblRight setText:@"个人发票"];
                }
                return cell;
            }
        }
        if (indexPath.section == 6) {
            if (indexPath.row == 0) {
                CellTuihuoInfo *cell=[tableView dequeueReusableCellWithIdentifier:@"CellTuihuoInfo"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.lblOne setText:@"退货信息"];
                [cell.lblTwo setTextNull:self.modelOrderDetail.refund[@"refund_log"]];
                return cell;
            }
            if (indexPath.row == 1) {
                CellTuihuoInfo *cell=[tableView dequeueReusableCellWithIdentifier:@"CellTuihuoInfo"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.lblOne setText:@"退货信息"];
                [cell.lblTwo setTextNull:self.modelOrderDetail.refund[@"seller_info"]];
                return cell;
            }
            if (indexPath.row == 2) {
                if (self.intState == 3) {
                    CellTwoLblArrow *cell=[tableView dequeueReusableCellWithIdentifier:@"CellTwoLblArrow"];
                    [cell.lblName setText:@"我要退货"];
                    [cell.lblContent setTextNull:@"填写退货退款信息"];
                    return cell;
                }
                if (self.intState == 4) {
                    
                    CellTuihuoWuliu *cell=[tableView dequeueReusableCellWithIdentifier:@"CellTuihuoWuliu"];
                    [cell.btnCheck handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                        [self pushToOrderLogisticsDetailTuihuo];
                    }];
                    [cell.btnChange handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                        
                        [self pushChangeInfo];
                    }];
                    return cell;
                }
            }
        }
        if (indexPath.section == 7) {
            if (indexPath.row == 0) {
                CellGoodMoney *cell=[tableView dequeueReusableCellWithIdentifier:@"CellGoodMoney"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.lblLeftUp setText:@"商品金额"];
                [cell.lblLeftDown setText:@"+运费"];
                [cell.lblMoneyUp setTextColor:ColorRed];
                [cell.lblMoneyDown setTextColor:ColorRed];
                [cell.lblMoneyUp setText:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:self.modelOrderDetail.goodsSumPrice])];
                [cell.lblMoneyDown setText:StringFormat(@"+￥%@",[NSString stringStandardFloatTwo:self.modelOrderDetail.ship_price])];
                return cell;
            }else{
                CellOrderMoney *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderMoney"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                NSString *strMony = [NSString stringStandardFloatTwo:self.modelOrderDetail.totalPrice];
                NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"实付款:￥%@",strMony)];
                [atrString addAttributes:@{NSForegroundColorAttributeName:ColorRed} range:NSMakeRange(4, atrString.length-4)];
                [atrString addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} range:NSMakeRange(4, atrString.length-4)];
                [cell.lblUp setAttributedText:atrString];
                [cell.lblDown setText:StringFormat(@"下单时间:%@",[NSString stringStandardZanwu:self.modelOrderDetail.addTime])];
                return cell;
            }
        }
        CellOrderTwoLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderTwoLbl"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else{
        if (indexPath.section == 0) {
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
        if (indexPath.section == 1) {
            CellOrderAddress *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderAddress"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell populateData:self.modelOrderDetail];
            return cell;
        }
        if (indexPath.section == 2) {
            CellOrderVendorTitle *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderVendorTitle"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell populateDataNoType:self.modelOrderDetail];
            return cell;
        }
        if (indexPath.section == 3) {
            CellOrderDetailGiftYes *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderDetailGiftYes"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:ColorCellBack];
            [cell populateData:self.modelOrderDetail.goods[indexPath.row]];
            return cell;
        }
        if (indexPath.section == 4) {
            
            CellOneButton *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOneButton"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.btnCommit handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                NSString *strPhone = self.modelOrderDetail.store_telephone;
                if ([NSString isNullString:strPhone]) {
                    [SVProgressHUD showErrorWithStatus:@"该商家未填写电话"];
                    return ;
                }
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",strPhone];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }];
            return cell;
        }
        if (indexPath.section == 5) {
            if (indexPath.row == 0) {
                CellOrderTwoLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderTwoLbl"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.lblLeft setText:@"支付方式"];
                [cell.lblRight setText:@"在线支付"];
                return cell;
            }else if (indexPath.row == 1) {
                CellOrderTwoLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderTwoLbl"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.lblLeft setText:@"配送方式"];
                if ([self.modelOrderDetail.ship_price intValue]==0) {
                    [cell.lblRight setTextNull:@"商家配送"];
                }else{
                    [cell.lblRight setTextNull:self.modelOrderDetail.transport];
                }
                return cell;
            }else{
                CellOrderTwoLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderTwoLbl"];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                [cell.lblLeft setText:@"发票信息"];
                NSString *strPrice = self.modelOrderDetail.invoiceType;
                if ([strPrice floatValue]==2) {
                    [cell.lblRight setText:@"不开发票"];
                }else if ([strPrice floatValue]==1) {
                    [cell.lblRight setText:@"公司发票"];
                }else{
                    [cell.lblRight setText:@"个人发票"];
                }
                return cell;
            }
        }
        if (indexPath.section == 6) {
            
            CellGoodMoney *cell=[tableView dequeueReusableCellWithIdentifier:@"CellGoodMoney"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.lblLeftUp setFont:[UIFont systemFontOfSize:13.0]];
            [cell.lblLeftDown setFont:[UIFont systemFontOfSize:15.0]];
            [cell.lblMoneyUp setFont:[UIFont systemFontOfSize:13.0]];
            [cell.lblMoneyDown setFont:[UIFont systemFontOfSize:13.0]];
            [cell.lblMoneyUp setTextColor:ColorBlack];
            [cell.lblMoneyDown setTextColor:ColorRed];
            [cell.lblLeftUp setText:@"运费"];
            [cell.lblLeftDown setText:@"实付款(含运费)"];
            [cell.lblMoneyUp setText:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:self.modelOrderDetail.ship_price])];
            NSString *strMony = [NSString stringStandardFloatTwo:self.modelOrderDetail.totalPrice];
            NSMutableAttributedString *atrString = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"￥%@",strMony)];
            [cell.lblMoneyDown setAttributedText:atrString];
            return cell;
        }

        if (indexPath.section == 7) {
            
            CellOrderDetialNumber *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderDetialNumber"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.lblNum setText:StringFormat(@"订单编号: %@",self.modelOrderDetail.order_id)];
            [cell.lblTimeCreate setText:StringFormat(@"创建时间: %@",[NSString stringStandardZanwu:self.modelOrderDetail.addTime])];;
            [cell.lblTimePay setText:StringFormat(@"付款时间: %@",[NSString stringStandardZanwu:self.modelOrderDetail.payTime])];;
            [cell.lblTimeSend setText:StringFormat(@"发货时间: %@",[NSString stringStandardZanwu:self.modelOrderDetail.shipTime])];
            [cell.btnCopy handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = self.modelOrderDetail.order_id;
                [SVProgressHUD showSuccessWithStatus:@"复制成功"];
            }];
            return cell;
        }
        
    }
    CellOrderTwoLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderTwoLbl"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.lblLeft setText:@""];
    [cell.lblRight setText:@""];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isShowMoreDetail) {
        if (section == 0||section == 3||section == 4) {
            return 0;
        }
    }else{
        if (section == 0||section == 1||section == 3||section == 4) {
            return 0;
        }
    }
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    return viHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (![NSString isNullString:self.modelOrderDetail.courierCode] && indexPath.row == 0 && indexPath.section == 0) {
//        跳到物流详情
        [self pushToOrderLogisticsDetail];
        
    }
    
    if (self.isShowMoreDetail){
        if (indexPath.section == 2&&indexPath.row == 0) {
            [self pushControllerOtherList];
        }
        if (indexPath.section == 6&&indexPath.row == 2) {
            if (self.intState == 3) {
//                去填写信息
                
                [self pushChangeInfo];
            }
        }
    }else{
        if (indexPath.section == 1&&indexPath.row == 0) {
            [self pushControllerOtherList];
        }
    }
}

- (void)pushChangeInfo{
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
    OrderTuihuoController *controller=[storyboard instantiateViewControllerWithIdentifier:@"OrderTuihuoController"];
    controller.modelOrderDetail = self.modelOrderDetail;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pushControllerOtherList{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
    GoodOtherListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodOtherListController"];
    controller.strGoods_store_id = self.modelList.store_id;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pushToOrderLogisticsDetail{
//     跳到物流详情
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
    OrderLogisticsDetailController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderLogisticsDetailController"];
    controller.strPath = self.modelOrderDetail.goods[0][@"path"];
    controller.strCount = StringFormat(@"%ld",(long)self.modelOrderDetail.goods.count);
    controller.strGoodCode = self.modelOrderDetail.courierCode;
    controller.strCompanyCode = self.modelOrderDetail.company_mark;
    controller.strCompanyName = self.modelOrderDetail.company_name;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)pushToOrderLogisticsDetailTuihuo{
    //     跳到物流详情
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
    OrderLogisticsDetailController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderLogisticsDetailController"];
    controller.strPath = self.modelOrderDetail.goods[0][@"path"];
    controller.strCount = StringFormat(@"%ld",(long)self.modelOrderDetail.goods.count);
    controller.strGoodCode = self.modelOrderDetail.return_shipCode;
    controller.strCompanyCode = self.modelOrderDetail.return_company_mark;
    controller.strCompanyName = self.modelOrderDetail.return_company;
    [self.navigationController pushViewController:controller animated:YES];
}
 
- (IBAction)clickButtonOne:(UIButton *)sender {
    [self clickButtonForListName:sender.titleLabel.text andIndexPath:self.modelOrderDetail];
}

- (IBAction)clickButtonTwo:(UIButton *)sender {
    [self clickButtonForListName:sender.titleLabel.text andIndexPath:self.modelOrderDetail];
}

- (void)clickButtonForListName:(NSString *)strTitle andIndexPath:(ModelOrderDtail *)model{
    if ([TransformString(strTitle) isEqualToString:@"去支付"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
        PayMonyForGoodController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PayMonyForGoodController"];
        controller.strOrderId = model.order_id;
        controller.strTotalPrice = model.totalPrice;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([TransformString(strTitle) isEqualToString:@"取消订单"]) {
        
        JJAlertViewTwoButton *alertView = [[JJAlertViewTwoButton alloc] init];
        [alertView showAlertView:self andTitle:nil andMessage:@"是否删除" andCancel:@"取消" andCanelIsRed:NO andOherButton:@"立即删除" andConfirm:^{
            D_NSLog(@"点击了立即发布");
            [SVProgressHUD showWithStatus:@"正在删除..."];
            __weak OrderDetailController *myself = self;
            myself.disposableDelete = [[[JJHttpClient new] requestFourZeroDeleteOrderId:[NSString stringStandard:model.order_id] andState:@"1"] subscribeNext:^(NSDictionary* dictionary) {
                if ([dictionary[@"code"] intValue]==1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameOrderDelete object:model.order_id];
                    [myself.navigationController popViewControllerAnimated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:dictionary[@"msg"]];
                }
                
            }error:^(NSError *error) {
                myself.disposableDelete = nil;
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }completed:^{
                [SVProgressHUD dismiss];
                myself.disposableDelete = nil;
            }];
        } andCancel:^{
            D_NSLog(@"点击了取消");
        }];
        
    }else if ([TransformString(strTitle) isEqualToString:@"去评价"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
        DiscussOrderController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DiscussOrderController"];
        controller.strOfId = self.modelList.orderId;
        controller.strOrderId = self.modelList.order_id;
        NSArray *array = self.modelList.goodsList;
        if ([array isKindOfClass:[NSArray class]]) {
            NSMutableArray *arrMiddle = [NSMutableArray array];
            for (int i = 0; i<array.count; i++) {
                NSDictionary *dictionary = array[i];
                DiscussAttribute *attribute = [[DiscussAttribute alloc] init];
                attribute.strGoodsName = dictionary[@"goodsName"];
                attribute.strIcon = dictionary[@"icon"];
                attribute.strUse_integral_value = dictionary[@"use_integral_value"];
                attribute.strGoodsId = dictionary[@"goodsId"];
                attribute.strUse_integral_set = dictionary[@"use_integral_set"];
                attribute.strGood = @"1";
                attribute.strMS = @"5";
                attribute.strFH = @"5";
                attribute.strFW = @"5";
                attribute.strContent = @"";
                [arrMiddle addObject:attribute];
            }
            controller.arrDiscuss = [NSMutableArray arrayWithArray:arrMiddle];
        }
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([TransformString(strTitle) isEqualToString:@"确认收货"]) {
        [SVProgressHUD showWithStatus:@"正在提交信息..."];
        self.disposableShouhuo = [[[JJHttpClient new] requestFourZeroDeleteOrderId:TransformString(model.order_id) andState:@""] subscribeNext:^(NSDictionary* dictionary) {
            if ([dictionary[@"code"] intValue]==1) {
                model.order_status = @"40";
                [self refreshButtonTitle];
                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameOrderGetSucceed object:model.order_id];
                [SVProgressHUD dismiss];
            }else{
                [SVProgressHUD showErrorWithStatus:dictionary[@"msg"]];
            }
        }error:^(NSError *error) {
            self.disposableShouhuo = nil;
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }completed:^{
            self.disposableShouhuo = nil;
        }];
    }else if ([TransformString(strTitle) isEqualToString:@"查看物流"]) {
        [self pushToOrderLogisticsDetail];
    }else if ([TransformString(strTitle) isEqualToString:@"确认收货"]) {
        JJAlertViewTwoButton *alertView = [[JJAlertViewTwoButton alloc] init];
        [alertView showAlertView:self
                        andTitle:nil
                      andMessage:@"确认收货后不可退款"
                       andCancel:@"取消"
                   andCanelIsRed:NO
                   andOherButton:@"确认收货"
                      andConfirm:^{
            [SVProgressHUD showWithStatus:@"正在提交信息..."];
            self.disposableShouhuo = [[[JJHttpClient new] requestFourZeroDeleteOrderId:TransformString(model.order_id)
                                                                              andState:@"2"]
                                      subscribeNext:^(NSDictionary* dictionary) {
                if ([dictionary[@"code"] intValue]==1) {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showSuccessWithStatus:dictionary[@"msg"]];
                }else{
                    [SVProgressHUD showErrorWithStatus:dictionary[@"msg"]];
                }
            }error:^(NSError *error) {
                self.disposableShouhuo = nil;
                [SVProgressHUD showErrorWithStatus:error.localizedDescription];
            }completed:^{
                self.disposableShouhuo = nil;
            }];
        } andCancel:^{
            D_NSLog(@"点击了取消");
        }];
    }
}



@end
