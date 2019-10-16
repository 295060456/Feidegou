//
//  OrderesAddressController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/16.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "OrderesAddressController.h"
#import "CellAddress.h"
#import "AddressAddController.h"
#import "UIButton+Joker.h"
#import "JJHttpClient+ShopGood.h"
#import "JJHttpClient+FourZero.h"
#import "JJDBHelper+ShopCart.h"

@interface OrderesAddressController ()
<
RefreshControlDelegate
>

@property (weak, nonatomic) IBOutlet BaseTableView *tabAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnAddAddress;
@property (strong, nonatomic) NSMutableArray *arrAddress;
@property (nonatomic,strong) RefreshControl *refreshControl;

@end

@implementation OrderesAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self.btnAddAddress setBackgroundColor:ColorRed];
    [self.tabAddress registerNib:[UINib nibWithNibName:@"CellAddress" bundle:nil] forCellReuseIdentifier:@"CellAddress"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabAddress delegate:self];
}

- (void)clickButtonBack:(UIButton *)sender{
    NSString *strId = StringFormat(@"%@",self.orderAttribute.strAddressId);
    if (![NSString isNullString:strId]) {
        BOOL isContain = NO;
        for (int i = 0; i<self.arrAddress.count; i++) {
            ModelAddress *model = self.arrAddress[i];
            if ([StringFormat(@"%@",model.ID) isEqualToString:strId]) {
                isContain = YES;
                [self refreshOrderDetail:model];
            }
        }
        if (!isContain) {
            self.orderAttribute.strAddressId = nil;
        }
    }
    [super clickButtonBack:sender];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.refreshControl beginRefreshingMethod];
}

- (void)reloadTabView{
    bool isContain = NO;
    for (int i = 0; i<self.arrAddress.count; i++) {
        ModelAddress *model = self.arrAddress[i];
        if ([model.defaultAddr boolValue]) {
//            如果存在默认地址，则保存默认地址
            [[JJDBHelper sharedInstance] saveAddressDefault:model];
            isContain = YES;
        }
    }
//    如果不存在默认地址，删除默认地址
    if (!isContain) {
        [[JJDBHelper sharedInstance] deleteAddressDefault];
    }
    [self.tabAddress reloadData];
    [self.tabAddress checkNoData:self.arrAddress.count];
}

- (void)requestExchangeList{
    
    __weak OrderesAddressController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodAddressListUserId:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId] subscribeNext:^(NSArray* array) {
        myself.arrAddress = [NSMutableArray arrayWithArray:array];
        [myself reloadTabView];
    }error:^(NSError *error) {
        [myself.tabAddress checkNoData:myself.arrAddress.count];
        myself.disposable = nil;
        [myself.refreshControl endRefreshing];
    }completed:^{
        [myself.refreshControl endRefreshing];
        myself.disposable = nil;
    }];
    
}
#pragma mark - RefreshControlDelegate
-(void)refreshControlForRefreshData{
    //从远程服务器获取数据
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
    return NO;
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrAddress.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellAddress *cell=[tableView dequeueReusableCellWithIdentifier:@"CellAddress"];
    ModelAddress *model = self.arrAddress[indexPath.section];
    [cell.btnDefault setSelected:[model.defaultAddr boolValue]];
    [cell.lblName setTextNull:StringFormat(@"%@ %@",model.trueName,model.mobile)];
    [cell.lblTip setTextNull:StringFormat(@"%@ %@",model.area,model.area_info)];
    [cell.btnEtit handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
        AddressAddController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AddressAddController"];
        controller.model = model;
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [cell.btnDelete handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        JJAlertViewTwoButton *alertView = [[JJAlertViewTwoButton alloc] init];
        [alertView showAlertView:self andTitle:nil andMessage:@"是否删除" andCancel:@"取消" andCanelIsRed:NO andOherButton:@"立即删除" andConfirm:^{
            [self requestDataDeleteAddress:indexPath.section];
        } andCancel:^{
            D_NSLog(@"点击了取消");
        }];
    }];
    [cell.btnDefault handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (!cell.btnDefault.selected) {
            [self requestChangeAddressDefaultID:model.ID];
        }
    }];return cell;
}

- (void)requestChangeAddressDefaultID:(NSString *)strId {
    [SVProgressHUD showWithStatus:@"正在修改默认地址..."];
    __weak OrderesAddressController *myself = self;
    self.disposable = [[[JJHttpClient new] requestFourZeroChangeAddressDefaultID:strId
                                                                       andUserId:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId]
                       subscribeNext:^(NSDictionary*dictinary) {
        D_NSLog(@"msg is %@",dictinary[@"msg"]);
        if ([dictinary[@"code"] intValue]==1) {
            [SVProgressHUD dismiss];
            for (int i = 0; i<myself.arrAddress.count; i++) {
                ModelAddress *model = myself.arrAddress[i];
                if ([TransformString(model.ID) isEqualToString:TransformString(strId)]) {
                    model.defaultAddr = @"1";
                    [[JJDBHelper sharedInstance] saveAddressDefault:model];
                }else{
                    model.defaultAddr = @"0";
                }
            }
            [myself reloadTabView];
        }else{
            [SVProgressHUD showErrorWithStatus:dictinary[@"msg"]];
        }
        
    }error:^(NSError *error) {
        myself.disposable = nil;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }completed:^{
        myself.disposable = nil;
    }];
}

- (void)requestDataDeleteAddress:(NSInteger)deleteRow{
    ModelAddress *model = self.arrAddress[deleteRow];
    [SVProgressHUD showWithStatus:@"正在删除地址..."];
    __weak OrderesAddressController *myself = self;
    self.disposable = [[[JJHttpClient new] requestFourZeroID:model.ID
                                                   andDelete:@"1"
                                                andArea_info:@""
                                                   andMobile:@""
                                                andTelephone:@""
                                                 andTrueName:@""
                                                      andZip:@""
                                                  andArea_id:@""
                                                  andUser_id:@""]
                       subscribeNext:^(NSDictionary*dictinary) {
        D_NSLog(@"msg is %@",dictinary[@"msg"]);
        if ([dictinary[@"code"] intValue]==1) {
            [SVProgressHUD dismiss];
            [myself.arrAddress removeObjectAtIndex:deleteRow];
            [myself reloadTabView];
        }else{
            [SVProgressHUD showErrorWithStatus:dictinary[@"msg"]];
        }
        
    }error:^(NSError *error) {
        myself.disposable = nil;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }completed:^{
        myself.disposable = nil;
    }];
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
    if (self.orderAttribute) {
        ModelAddress *model = self.arrAddress[indexPath.section];
        [self refreshOrderDetail:model];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)refreshOrderDetail:(ModelAddress *)model{
    self.orderAttribute.strAddressId = model.ID;
    self.orderAttribute.strAddressName = model.trueName;
    self.orderAttribute.strAddressPhone = model.mobile;
    self.orderAttribute.strAddressErea = model.area;
    self.orderAttribute.strAddressDetail = model.area_info;
}

- (IBAction)clickButtonAddAddress:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
    AddressAddController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AddressAddController"];
    [self.navigationController pushViewController:controller
                                         animated:YES];
}

@end
