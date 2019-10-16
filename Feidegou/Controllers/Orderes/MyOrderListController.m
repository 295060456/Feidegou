//
//  MyOrderListController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/16.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "MyOrderListController.h"
#import "CellOrderVendorTitle.h"
#import "CellOrderGood.h"
#import "CellOrderOneLbl.h"
#import "CellOrderButtones.h"
#import "CellImageMore.h"
#import "OrderDetailController.h"
#import "JJHttpClient+ShopGood.h"
#import "JJHttpClient+FourZero.h"
#import "PayMonyForGoodController.h"
#import "UIButton+Joker.h"
#import "GoodOtherListController.h"
#import "OrderDiscussController.h"
#import "OrderLogisticsDetailController.h"
#import "CellOrderGiftNo.h"
#import "DrawbackMoney.h"

@interface MyOrderListController ()
<
RefreshControlDelegate
>

@property (weak, nonatomic) IBOutlet BaseTableView *tabMyOrderList;
@property (strong, nonatomic) NSMutableArray *arrGoods;
@property (nonatomic,strong) RACDisposable *disposableDelete;
@property (nonatomic,strong) RACDisposable *disposableShouhuo;
@property (nonatomic,strong) RACDisposable *disposableShare;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic,assign) int intPageIndex;
@property (nonatomic,assign) NSInteger curCount;//当前页数数量
@property (nonatomic,strong) ModelOrderList *modelDrawback;
@property (nonatomic,copy) NSString *strTuikuanType;

@end

@implementation MyOrderListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self.tabMyOrderList setBackgroundColor:ColorBackground];
    [self.tabMyOrderList registerNib:[UINib nibWithNibName:@"CellOrderGiftNo" bundle:nil] forCellReuseIdentifier:@"CellOrderGiftNo"];
    [self.tabMyOrderList registerNib:[UINib nibWithNibName:@"CellOrderVendorTitle" bundle:nil] forCellReuseIdentifier:@"CellOrderVendorTitle"];
    [self.tabMyOrderList registerNib:[UINib nibWithNibName:@"CellOrderGood" bundle:nil] forCellReuseIdentifier:@"CellOrderGood"];
    [self.tabMyOrderList registerNib:[UINib nibWithNibName:@"CellOrderOneLbl" bundle:nil] forCellReuseIdentifier:@"CellOrderOneLbl"];
    [self.tabMyOrderList registerNib:[UINib nibWithNibName:@"CellOrderButtones" bundle:nil] forCellReuseIdentifier:@"CellOrderButtones"];
    [self.tabMyOrderList registerNib:[UINib nibWithNibName:@"CellImageMore" bundle:nil] forCellReuseIdentifier:@"CellImageMore"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabMyOrderList delegate:self];
    [self.refreshControl beginRefreshingMethod];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationPaySucceedChangeData:) name:NotificationNamePaySucceedChangeData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationDiscussSucceed:) name:NotificationNameDiscussSucceed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationOrderDelete:) name:NotificationNameOrderDelete object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationOrderGetSucceed:) name:NotificationNameOrderGetSucceed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NotificationDrawbackMoneySucceed:) name:NotificationNameDrawbackMoneySucceed object:nil];
}

- (void)NotificationPaySucceedChangeData:(NSNotification *)notification{
    NSString *strOrderId = TransformString((NSString *)notification.object);
    for (int i = 0; i<self.arrGoods.count; i++) {
        ModelOrderList *modelList = self.arrGoods[i];
        NSString *strOrderIdMiddle = TransformString(modelList.order_id);
        if ([strOrderId isEqualToString:strOrderIdMiddle]) {
            if (self.orderState == enumOrder_quanbu) {
                modelList.order_status = @"20";
            }else{
                [self.arrGoods removeObject:modelList];
            }
            [self reloadTabView];
        }
    }
}

- (void)NotificationDiscussSucceed:(NSNotification *)notification{
    NSString *strOrderId = TransformString((NSString *)notification.object);
    for (int i = 0; i<self.arrGoods.count; i++) {
        ModelOrderList *modelList = self.arrGoods[i];
        NSString *strOrderIdMiddle = TransformString(modelList.order_id);
        if ([strOrderId isEqualToString:strOrderIdMiddle]) {
            if (self.orderState == enumOrder_quanbu) {
                modelList.order_status = @"50";
            }else{
                [self.arrGoods removeObject:modelList];
            }
            [self reloadTabView];
        }
    }
}

- (void)NotificationOrderDelete:(NSNotification *)notification{
    NSString *strOrderId = TransformString((NSString *)notification.object);
    for (int i = 0; i<self.arrGoods.count; i++) {
        ModelOrderList *modelList = self.arrGoods[i];
        NSString *strOrderIdMiddle = TransformString(modelList.order_id);
        if ([strOrderId isEqualToString:strOrderIdMiddle]) {
            [self.arrGoods removeObject:modelList];
            [self reloadTabView];
        }
    }
}

- (void)NotificationOrderGetSucceed:(NSNotification *)notification{
    NSString *strOrderId = TransformString((NSString *)notification.object);
    for (int i = 0; i<self.arrGoods.count; i++) {
        ModelOrderList *modelList = self.arrGoods[i];
        NSString *strOrderIdMiddle = TransformString(modelList.order_id);
        if ([strOrderId isEqualToString:strOrderIdMiddle]) {
            if (self.orderState == enumOrder_quanbu) {
                modelList.order_status = @"40";
            }else{
                [self.arrGoods removeObject:modelList];
            }
            [self reloadTabView];
        }
    }
}

- (void)NotificationDrawbackMoneySucceed:(NSNotification *)notification{
    NSString *strOrderId = self.modelDrawback.order_id;
    if ([NSString isNullString:self.modelDrawback.orderId]) {
        return;
    }
    NSString *strMsg = (NSString *)notification.object;
    if ([NSString isNullString:strMsg]) {
        return;
    }
    
    [SVProgressHUD showWithStatus:@"正在提交信息..."];
    __weak MyOrderListController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestFourZeroDarwback:strOrderId
                                                              andmsg:strMsg
                                                             andtype:[NSString stringStandard:self.strTuikuanType]]
                         subscribeNext:^(NSDictionary* dictionary) {
        if ([dictionary[@"code"] intValue]==1) {
            for (int i = 0; i<self.arrGoods.count; i++) {
                ModelOrderList *modelList = self.arrGoods[i];
                NSString *strOrderIdMiddle = TransformString(modelList.order_id);
                if ([strOrderId isEqualToString:strOrderIdMiddle]) {
                    if (self.orderState == enumOrder_quanbu) {
                        modelList.order_status = @"45";
                        modelList.state = @"卖家申请退款";
                    }else{
                        [self.arrGoods removeObject:modelList];
                    }
                    [self reloadTabView];
                }
            }
            [SVProgressHUD showSuccessWithStatus:dictionary[@"msg"]];
        }else{
            [SVProgressHUD showErrorWithStatus:dictionary[@"msg"]];
        }
    }error:^(NSError *error) {
        myself.disposable = nil;
    }completed:^{
        myself.disposable = nil;
    }];
}

- (void)requestExchangeList{
    NSString *strOrderState = @"";
    if (self.orderState != enumOrder_quanbu) {
        strOrderState = TransformNSInteger(self.orderState);
    }
    __weak MyOrderListController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodOrderListLimit:@"10"
                                                                   andPage:TransformNSInteger(self.intPageIndex)
                                                           andOrder_status:strOrderState
                                                                andUser_id:[NSString stringStandard:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId]]
                         subscribeNext:^(NSArray* array) {
        myself.curCount = array.count;
        if (myself.intPageIndex == 1) {
            myself.arrGoods = [NSMutableArray array];
        }
        [myself.arrGoods addObjectsFromArray:array];
        [myself reloadTabView];
    }error:^(NSError *error) {
        myself.disposable = nil;
        [myself reloadTabView];
        [myself.refreshControl endRefreshing];
        if (error.code!=2) {
            //            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }else{
            myself.curCount = 0;
        }
    }completed:^{
        myself.intPageIndex++;
        [myself.refreshControl endRefreshing];
        myself.disposable = nil;
    }];
}
#pragma mark - RefreshControlDelegate
-(void)refreshControlForRefreshData{
    //从远程服务器获取数据
    self.intPageIndex = 1;
    if ([self respondsToSelector:@selector(requestExchangeList)]) {
        [self requestExchangeList];
    }
}

-(void)refreshControlForLoadMoreData{
    //从远程服务器获取数据
    if ([self respondsToSelector:@selector(requestExchangeList)]) {
        [self requestExchangeList];
    }
}
//在此代理方法中判断数据是否加载完成,
-(BOOL)refreshControlForDataLoadingFinished{
    //从服务器返回的每页数据数量,可以判断出服务器是否没有数据了
    if (self.curCount < 10) {
        return YES;
    }
    return NO;
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ModelOrderList *model = self.arrGoods[section];
    return model.goodsList.count+3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrGoods.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ModelOrderList *model = self.arrGoods[indexPath.section];
    if (indexPath.row == 0) {
        return 40.0f;
    }else if (indexPath.row<model.goodsList.count+1) {
        return 90.0f;
    }return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ModelOrderList *model = self.arrGoods[indexPath.section];
    if (indexPath.row == 0) {
        CellOrderVendorTitle *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderVendorTitle"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateData:self.arrGoods[indexPath.section]];
        return cell;
    }
    if (indexPath.row >0&&indexPath.row<model.goodsList.count+1) {
        NSDictionary *dicInfo = model.goodsList[indexPath.row-1];
        CellOrderGiftNo *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderGiftNo"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateDataName:dicInfo[@"goodsName"]
                       andPath:dicInfo[@"icon"]
                        andNum:dicInfo[@"count"]
                  andspec_info:dicInfo[@"spec_info"]
                      andprice:dicInfo[@"price"]
               andgift_d_coins:dicInfo[@"gift_d_coins"]];
        return cell;
    }
    if (indexPath.row == model.goodsList.count+2) {
        
        CellOrderButtones *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderButtones"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateDataOrderList:self.arrGoods[indexPath.section]];
        [cell.btnOne handleControlEvent:UIControlEventTouchUpInside
                              withBlock:^{
            [self clickButtonForListName:cell.btnOne.titleLabel.text
                            andIndexPath:self.arrGoods[indexPath.section]
                            andIndexPath:indexPath];
        }];
        [cell.btnTwo handleControlEvent:UIControlEventTouchUpInside
                              withBlock:^{
            [self clickButtonForListName:cell.btnTwo.titleLabel.text
                            andIndexPath:self.arrGoods[indexPath.section]
                            andIndexPath:indexPath];
        }];
        [cell.btnThree handleControlEvent:UIControlEventTouchUpInside
                                withBlock:^{
            [self clickButtonForListName:cell.btnThree.titleLabel.text
                            andIndexPath:self.arrGoods[indexPath.section]
                            andIndexPath:indexPath];
        }];return cell;
    }
    
    //    if (indexPath.row == model.goodsList.count+1) {
    CellOrderOneLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderOneLbl"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell populateData:self.arrGoods[indexPath.section]];
    return cell;
    //    }
    //    NSArray *array = model.goodsList;
    //    if ([array isKindOfClass:[NSArray class]]&&array.count>1) {
    //        NSArray *arrGoodMiddle = [NSArray arrayWithArray:model.goodsList];
    //        NSMutableArray *arrImage = [NSMutableArray array];
    //        for (int i = 0; i<arrGoodMiddle.count; i++) {
    //            [arrImage addObject:[NSString stringStandard:arrGoodMiddle[i][@
    //                                                                          "icon"]]];
    //        }
    //        CellImageMore *cell=[tableView dequeueReusableCellWithIdentifier:@"CellImageMore"];
    //        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //        [cell setBackgroundColor:ColorBackground];
    //        [cell populataData:arrImage];
    //        return cell;
    //    }
}

- (void)clickButtonForListName:(NSString *)strTitle
                  andIndexPath:(ModelOrderList *)model
                  andIndexPath:(NSIndexPath *)indexPath{
    if ([TransformString(strTitle) isEqualToString:@"去支付"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
        PayMonyForGoodController *controller = [storyboard instantiateViewControllerWithIdentifier:@"PayMonyForGoodController"];
        controller.strOrderId = model.order_id;
        controller.strTotalPrice = model.totalPrice;
        controller.strOfId = model.ID;
        if ([model.if_cart intValue]==1) {
            controller.isCart = YES;
        }
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([TransformString(strTitle) isEqualToString:@"取消订单"]) {
        
        JJAlertViewTwoButton *alertView = [[JJAlertViewTwoButton alloc] init];
        [alertView showAlertView:self
                        andTitle:nil
                      andMessage:@"是否删除"
                       andCancel:@"取消"
                   andCanelIsRed:NO
                   andOherButton:@"立即删除"
                      andConfirm:^{
            D_NSLog(@"点击了立即发布");
            [SVProgressHUD showWithStatus:@"正在删除..."];
            __weak MyOrderListController *myself = self;
            myself.disposableDelete = [[[JJHttpClient new] requestFourZeroDeleteOrderId:[NSString stringStandard:model.order_id]
                                                                               andState:@"1"]
                                       subscribeNext:^(NSDictionary* dictionary) {
                if ([dictionary[@"code"] intValue]==1) {
                    [myself.arrGoods removeObject:model];
                    [myself reloadTabView];
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
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
        OrderDiscussController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderDiscussController"];
        controller.strOrderId = model.orderId;
        controller.strGoodsId = model.goodsId;
        controller.strGoodsName = model.goods_name;
        controller.strImage = model.path;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([TransformString(strTitle) isEqualToString:@"确认收货"]) {
        JJAlertViewTwoButton *alertView = [[JJAlertViewTwoButton alloc] init];
        [alertView showAlertView:self
                        andTitle:nil
                      andMessage:@"确认收货后不可退款"
                       andCancel:@"取消"
                   andCanelIsRed:NO
                   andOherButton:@"确认收货" andConfirm:^{
            [SVProgressHUD showWithStatus:@"正在提交信息..."];
            self.disposableShouhuo = [[[JJHttpClient new] requestFourZeroDeleteOrderId:TransformString(model.order_id) andState:@"2"]
                                      subscribeNext:^(NSDictionary* dictionary) {
                if ([dictionary[@"code"] intValue]==1) {
                    if (self.orderState == enumOrder_quanbu) {
                        model.order_status = @"40";
                    }else{
                        [self.arrGoods removeObject:model];
                    }
                    [self reloadTabView];
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
        } andCancel:^{
            D_NSLog(@"点击了取消");
        }];
    }else if ([TransformString(strTitle) isEqualToString:@"查看物流"]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
        OrderLogisticsDetailController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderLogisticsDetailController"];
        controller.strPath = model.path;
        controller.strCount = model.count;
        controller.strGoodCode = model.courierCode;
        controller.strCompanyCode = model.company_mark;
        controller.strCompanyName = model.company_name;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([TransformString(strTitle) isEqualToString:@"查看详情"]){
        
        ModelOrderList *modelList = self.arrGoods[indexPath.section];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
        OrderDetailController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderDetailController"];
        controller.modelList = modelList;
        [self.navigationController pushViewController:controller animated:YES];
    }else if ([TransformString(strTitle) isEqualToString:@"申请退款"]){
        self.modelDrawback = model;
        [self tuikuanSeletct];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    return viHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ModelOrderList *modelList = self.arrGoods[indexPath.section];
    if (indexPath.row == 0) {
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
        GoodOtherListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodOtherListController"];
        controller.strGoods_store_id = modelList.store_id;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
        OrderDetailController *controller = [storyboard instantiateViewControllerWithIdentifier:@"OrderDetailController"];
        controller.modelList = modelList;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)reloadTabView{
    for (int i = 0; i<self.arrGoods.count; i++) {
        ModelOrderList *modelList =self.arrGoods[i];
        modelList.arrButton = [PublicFunction returnButtonNameByNum:modelList.order_status
                                                    andIsNeedDetail:YES
                                                     andcourierCode:modelList.courierCode];
    }
    [self.tabMyOrderList reloadData];
    [self.tabMyOrderList checkNoData:self.arrGoods.count];
}

- (void)tuikuanSeletct{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"申请退款"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];

    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"仅退款(未收到货)"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction * _Nonnull action) {
        self.strTuikuanType = @"notover";
        [self tuikuanBack];
    }];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"退货退款(已收到货)"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
        self.strTuikuanType = @"over";
        [self tuikuanBack];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    [alertController addAction:archiveAction];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
    //    alertController.popoverPresentationController.sourceView = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    //
    //    alertController.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
    //
    //    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)tuikuanBack{
    
    FDAlertView *alert = [[FDAlertView alloc] init];
    DrawbackMoney *contentView = [[NSBundle mainBundle] loadNibNamed:@"DrawbackMoney"
                                                               owner:nil
                                                             options:nil].lastObject;
    [contentView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    alert.contentView = contentView;
    [alert show];
}


@end
