//
//  CartListController.m
//  Vendor
//
//  Created by 谭自强 on 2016/12/16.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CartListController.h"
#import "CellCartHead.h"
#import "CellCartGood.h"
#import "UIButton+Joker.h"
#import "JJHttpClient+FourZero.h"
#import "JJHttpClient+ShopGood.h"
#import "GoodDetialAllController.h"
#import "GoodOtherListController.h"
#import "OrderesComfilmController.h"
#define isSelected @"select"

@interface CartListController ()
<RefreshControlDelegate>

@property (nonatomic,strong) RACDisposable *disposableChangeNum;
@property (nonatomic,strong) RACDisposable *disposableDelete;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet BaseTableView *tabCart;
@property (weak, nonatomic) IBOutlet UIButton *btnPay;
@property (weak, nonatomic) IBOutlet UILabelBlackBig *lblMoney;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintHeight;
//@property (nonatomic,assign) NSInteger integerSection;
@property (weak, nonatomic) IBOutlet UIView *viFunction;
@property (strong, nonatomic) NSMutableArray *arrCart;
@property (nonatomic,strong) RefreshControl *refreshControl;
//@property (nonatomic,assign) int intPageIndex;
////当前页数数量
//@property (nonatomic,assign) NSInteger curCount;
@end

@implementation CartListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self.tabCart registerNib:[UINib nibWithNibName:@"CellCartHead" bundle:nil] forCellReuseIdentifier:@"CellCartHead"];
    [self.tabCart registerNib:[UINib nibWithNibName:@"CellCartGood" bundle:nil] forCellReuseIdentifier:@"CellCartGood"];
    [self.tabCart setBackgroundColor:ColorBackground];
    
    [self.btnPay setBackgroundColor:ColorHeader];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabCart
                                                                        delegate:self];
    
    UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(handleLongPress:)];
    recognizer.minimumPressDuration = 0.5; //设置最小长按时间；默认为0.5秒
    [self.tabCart addGestureRecognizer:recognizer];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self.tabCart];
    NSIndexPath *indexPath = [self.tabCart indexPathForRowAtPoint:point];
    NSString *strMsg = @"";
    NSString *strType = @"";
    if (indexPath.row == 0) {
        strType = @"1";
        strMsg = StringFormat(@"删除店铺%@所有商品",self.arrCart[indexPath.section][@"store_name"]);
    }else{
        strType = @"2";
        strMsg = StringFormat(@"删除%@",self.arrCart[indexPath.section][@"goods"][indexPath.row-1][@"goods_name"]);
    }
    @weakify(self)
    [JJAlertViewTwoButton.new showAlertView:self
                                   andTitle:@"提示"
                                 andMessage:strMsg
                                  andCancel:@"取消"
                              andCanelIsRed:NO
                              andOherButton:@"删除"
                                 andConfirm:^{
        @strongify(self)
        D_NSLog(@"删除%@",indexPath);
        [self requestDeleteCartIndexPath:indexPath
                           andDeleteType:strType];
    } andCancel:^{
        D_NSLog(@"取消");
    }];
}

- (void)requestDeleteCartIndexPath:(NSIndexPath *)indexPath
                     andDeleteType:(NSString *)deleteType{
    NSString *strGoodId = @"";
    if (indexPath.row!=0) {
        strGoodId = self.arrCart[indexPath.section][@"goods"][indexPath.row - 1][@"id"];
    }
    [SVProgressHUD showWithStatus:@"正在删除..."];
    @weakify(self)
    self.disposableDelete = [[[JJHttpClient new] requestFourZeroCartDeleteCartGoodsCartId:strGoodId
                                                                           andstoreCartId:TransformString(self.arrCart[indexPath.section][@"sc_id"])
                                                                            anddeleteType:deleteType]
                             subscribeNext:^(NSDictionary*dictionary) {
        @strongify(self)
        if ([dictionary[@"code"] intValue] == 1) {
            if ([deleteType intValue] == 1) {
                [self.arrCart removeObjectAtIndex:indexPath.section];
//                [myself.tabCart deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
            }else{
                NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionaryWithDictionary:self.arrCart[indexPath.section]];
                NSMutableArray *arrMiddle = [NSMutableArray arrayWithArray:dicMiddle[@"goods"]];
                [arrMiddle removeObjectAtIndex:indexPath.row-1];
                if (arrMiddle.count > 0) {
                    [dicMiddle setObject:dictionary[@"totalPrice"] forKey:@"total_price"];
                    [dicMiddle setObject:arrMiddle forKey:@"goods"];
                    [self.arrCart replaceObjectAtIndex:indexPath.section withObject:dicMiddle];
//                    [myself.tabCart deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                }else{
                    [self.arrCart removeObjectAtIndex:indexPath.section];
//                    [myself.tabCart deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
                }
            }
        }
        [self refrshCart];
    }error:^(NSError *error) {
        @strongify(self)
        self.disposableDelete = nil;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }completed:^{
        @strongify(self)
        [SVProgressHUD dismiss];
        self.disposableDelete = nil;
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([[PersonalInfo sharedInstance] isLogined]) {
        [self.refreshControl beginRefreshingMethod];
    }else{
//        self.arrCart = [NSMutableArray arrayWithArray:[[JJDBHelper sharedInstance] fetchShopCart]];
        self.arrCart = [NSMutableArray array];
    }
    [self refrshCart];
}

- (void)requestExchangeList{
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestShopGoodCartListLimit:@"1000"
                                                                  andPage:@"1"
                                                               anduser_id:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId]
                         subscribeNext:^(NSArray* array) {
        @strongify(self)
        if ([array isKindOfClass:[NSArray class]]) {
//            先获取以前被选择的商品id
            NSMutableArray *arrSelected = [NSMutableArray array];
            NSMutableArray *arrMiddle = [NSMutableArray arrayWithArray:self.arrCart];
            for (int i = 0; i<arrMiddle.count; i++) {
                NSArray *arrGood = arrMiddle[i][@"goods"];
                for (int j = 0; j<arrGood.count; j++) {
                    if ([arrGood[j][isSelected] boolValue]) {
                        [arrSelected addObject:arrGood[j][@"id"]];
                    }
                }
            }
            self.arrCart = [NSMutableArray arrayWithArray:array];
//            把包含已被选中的添加到新的数组里面
            for (int i = 0; i < self.arrCart.count; i++) {
                NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionaryWithDictionary:self.arrCart[i]];
                NSMutableArray *arrGood = [NSMutableArray arrayWithArray:dicMiddle[@"goods"]];
                for (int j = 0; j<arrGood.count; j++) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:arrGood[j]];
                    NSString *strId = dic[@"id"];
                    BOOL isSl = NO;
                    for (int k = 0; k<arrSelected.count; k++) {
                        NSString *strIdMiddle = arrSelected[k];
                        if ([TransformString(strId) isEqualToString:TransformString(strIdMiddle)]) {
                            isSl = YES;
                            break;
                        }
                    }
                    if (isSl) {
//                        替换单个商品
                        [dic setObject:@"1"
                                forKey:isSelected];
                        [arrGood replaceObjectAtIndex:j
                                           withObject:dic];
                    }
                }
//                替换单个商家
                [dicMiddle setObject:arrGood
                              forKey:@"goods"];
                [self.arrCart replaceObjectAtIndex:i
                                        withObject:dicMiddle];
            }
        }
        
//        if (myself.intPageIndex == 1) {
//            myself.arrCart = [NSMutableArray array];
//        }
        
//        for (int i = 0; i<array.count; i++) {
//            BOOL isContain = NO;
//            NSString *strSc_id = TransformString(array[i][@"sc_id"]);
//            for (int j = 0; j<myself.arrCart.count; j++) {
//                NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionaryWithDictionary:myself.arrCart[j]];
//                NSString *strSc_idMiddle = TransformString(dicMiddle[@"sc_id"]);
//                if ([strSc_id isEqualToString:strSc_idMiddle]) {
//                    isContain = YES;
//                    NSMutableArray *arrMiddle = [NSMutableArray arrayWithArray:dicMiddle[@"goods"]];
//                    [arrMiddle addObjectsFromArray:array[i][@"goods"]];
//                    [dicMiddle setObject:arrMiddle forKey:@"goods"];
//                    [myself.arrCart replaceObjectAtIndex:j withObject:dicMiddle];
//                }
//            }
//            if (!isContain) {
//                [myself.arrCart addObject:array[i]];
//            }
//        }
//        myself.curCount = array.count;
//        if (myself.integerSection<myself.arrCart.count) {
//        }else{
//            myself.integerSection = -1;
//        }
        [self refrshCart];
    }error:^(NSError *error) {
        @strongify(self)
        self.disposable = nil;
        [self.refreshControl endRefreshing];
        if (error.code!=2) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }else{
//            myself.curCount = 0;
        }
    }completed:^{
        @strongify(self)
//        myself.intPageIndex++;
        [self.refreshControl endRefreshing];
        self.disposable = nil;
    }];
}
#pragma mark - RefreshControlDelegate
-(void)refreshControlForRefreshData{
    //从远程服务器获取数据
//    self.intPageIndex = 1;
    if ([self respondsToSelector:@selector(requestExchangeList)]) {
        [self requestExchangeList];
    }
}

-(BOOL)refreshControlEnableRefresh{
    if ([[PersonalInfo sharedInstance] isLogined]) {
        return YES;
    }
    return NO;
}
-(BOOL)refreshControlEnableLoadMore{
    return NO;
}
//-(void)refreshControlForLoadMoreData{
//    //从远程服务器获取数据
//    if ([self respondsToSelector:@selector(requestExchangeList)]) {
//        [self requestExchangeList];
//    }
//}
////在此代理方法中判断数据是否加载完成,
//-(BOOL)refreshControlForDataLoadingFinished{
//    //从服务器返回的每页数据数量,可以判断出服务器是否没有数据了
//    if (self.curCount == 0) {
//        return YES;
//    }
//    return NO;
//}

- (void)clickCellHead:(NSInteger)section andSelected:(BOOL)selected{
    NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionaryWithDictionary:self.arrCart[section]];
    NSMutableArray *arrMiddle = [NSMutableArray arrayWithArray:dicMiddle[@"goods"]];
    for (int i = 0; i<arrMiddle.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:arrMiddle[i]];
        if (selected) {
            [dic setObject:@"1" forKey:isSelected];
        }else{
            [dic setObject:@"0" forKey:isSelected];
        }
        [arrMiddle replaceObjectAtIndex:i
                             withObject:dic];
    }
    [dicMiddle setObject:arrMiddle forKey:@"goods"];
    [self.arrCart replaceObjectAtIndex:section withObject:dicMiddle];
    [self refreshView];
    [self refreshTab];
}

- (void)clickCellOnlyOne:(NSIndexPath *)index
             andSelected:(BOOL)selected{
    NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionaryWithDictionary:self.arrCart[index.section]];
    NSMutableArray *arrMiddle = [NSMutableArray arrayWithArray:dicMiddle[@"goods"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:arrMiddle[index.row-1]];
    if (selected) {
        [dic setObject:@"1" forKey:isSelected];
    }else{
        [dic setObject:@"0" forKey:isSelected];
    }
    [arrMiddle replaceObjectAtIndex:index.row-1 withObject:dic];
    [dicMiddle setObject:arrMiddle forKey:@"goods"];
    [self.arrCart replaceObjectAtIndex:index.section withObject:dicMiddle];
    [self refreshView];
    [self refreshTab];
}

- (void)refrshCart{
    [self refreshView];
    [self refreshTab];
}

- (void)refreshView{
    double doublePrice = 0;
    int intNum = 0;
    for (int i = 0; i<self.arrCart.count; i++) {
        NSArray *arrMiddle = self.arrCart[i][@"goods"];
        for (int j = 0; j<arrMiddle.count; j++) {
            NSDictionary *dicMiddle = [NSDictionary dictionaryWithDictionary:arrMiddle[j]];
            if ([dicMiddle[isSelected] boolValue]) {
                doublePrice += [dicMiddle[@"price"] doubleValue]*[dicMiddle[@"count"] doubleValue];
                intNum+=[dicMiddle[@"count"] intValue];
            }
        }
    }
    
    if (doublePrice>0) {
//        self.layoutConstraintHeight.constant = 40;
//        [self.viFunction setHidden:NO];
        [self.btnPay setBackgroundColor:ColorRed];
        [self.lblMoney setTextNull:StringFormat(@"合计:￥%.2f",doublePrice)];
    }else{
        [self.btnPay setBackgroundColor:ColorGaryDark];
        [self.lblMoney setTextNull:@"合计:￥0.00"];
//        self.layoutConstraintHeight.constant = 0;
//        [self.viFunction setHidden:YES];
    }
    [self.btnPay setTitle:StringFormat(@"去结算(%d)",intNum)
                 forState:UIControlStateNormal];
    [self.tabCart checkNoData:self.arrCart.count];
}

- (void)refreshTab{
    [self.tabCart reloadData];
}

#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *array = [NSArray arrayWithArray:self.arrCart[section][@"goods"]];
    return array.count+1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrCart.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 40.0f;
    }return 110.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    if (indexPath.row == 0) {
        CellCartHead *cell=[tableView dequeueReusableCellWithIdentifier:@"CellCartHead"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        NSArray *array = [NSArray arrayWithArray:self.arrCart[indexPath.section][@"goods"]];
        BOOL select = YES;
        for (int i = 0; i<array.count; i++) {
            if (![array[i][isSelected] boolValue]) {
                select = NO;
            }
        }
        [cell.btnSelect setSelected:select];
//        if (self.integerSection == indexPath.section) {
//            [cell.btnSelect setSelected:YES];
//        }else{
//            [cell.btnSelect setSelected:NO];
//        }
        [cell.btnSelect handleControlEvent:UIControlEventTouchUpInside
                                 withBlock:^{
            @strongify(self)
//            self.integerSection = indexPath.section;
//            [self refrshCart];
            [self clickCellHead:indexPath.section
                    andSelected:!cell.btnSelect.selected];
        }];
        
        NSString *strTitle = self.arrCart[indexPath.section][@"store_name"];
        CGFloat fWidth = [NSString conculuteRightCGSizeOfString:strTitle
                                                       andWidth:SCREEN_WIDTH-75
                                                        andFont:15.0].width;
        cell.layoutConstraintWidth.constant = fWidth;
        [cell.lblTitle setTextNull:strTitle];
        return cell;
    }
    NSArray *array = [NSArray arrayWithArray:self.arrCart[indexPath.section][@"goods"]];
    NSDictionary *dicDetail = array[indexPath.row-1];
    CellCartGood *cell=[tableView dequeueReusableCellWithIdentifier:@"CellCartGood"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.imgHead setImagePathListSquare:dicDetail[@"icon"]];
    [cell.lblTitle setTextNull:dicDetail[@"goods_name"]];
    [cell.lblAttribute setTextNull:dicDetail[@"spec_info"]];
    [cell.btnSelect setSelected:[dicDetail[isSelected] boolValue]];
    [cell.btnSelect handleControlEvent:UIControlEventTouchUpInside
                             withBlock:^{
        @strongify(self)
        [self clickCellOnlyOne:indexPath
                   andSelected:!cell.btnSelect.selected];
    }];
    [cell.lblNum setTextNull:dicDetail[@"count"]];
    if ([dicDetail[@"count"] intValue]>1) {
        [cell.btnReduce setEnabled:YES];
    }else{
        [cell.btnReduce setEnabled:NO];
    }
    [cell.btnReduce handleControlEvent:UIControlEventTouchUpInside
                             withBlock:^{
        @strongify(self)
        [self requestChangeCartNumIsAdd:NO
                           andIndexPath:indexPath];
    }];
    [cell.btnAdd handleControlEvent:UIControlEventTouchUpInside
                          withBlock:^{
        @strongify(self)
        [self requestChangeCartNumIsAdd:YES
                           andIndexPath:indexPath];
    }];
    [cell.lblPrice setTextGoodPrice:dicDetail[@"price"] andDB:dicDetail[@"gift_d_coins"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView
        viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    return viHeader;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (!self.btnEdit.selected) {
        if (indexPath.row == 0) {
            
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
            GoodOtherListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodOtherListController"];
            controller.strGoods_store_id = self.arrCart[indexPath.section][@"store_id"];
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            NSArray *array = [NSArray arrayWithArray:self.arrCart[indexPath.section][@"goods"]];
            NSDictionary *dicDetail = array[indexPath.row-1];
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
            GoodDetialAllController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodDetialAllController"];
            controller.strGood_id = dicDetail[@"goods_id"];
            [self.navigationController pushViewController:controller animated:YES];
        }
//    }
}
- (void)requestChangeCartNumIsAdd:(BOOL)isAdd
                     andIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    if (self.disposableChangeNum) {
        return;
    }
    NSString *strSCID  = TransformString(self.arrCart[indexPath.section][@"sc_id"]);
    
    NSArray *array = [NSArray arrayWithArray:self.arrCart[indexPath.section][@"goods"]];
    NSDictionary *dicDetail = array[indexPath.row-1];
    NSString *strCartId  = TransformString(dicDetail[@"id"]);
    int intNum = [dicDetail[@"count"] intValue];
    if (isAdd) {
        intNum++;
    }else{
        intNum--;
    }
    NSString *strNum = TransformNSInteger(intNum);
    self.disposableChangeNum = [[[JJHttpClient new] requestFourZeroCartChangeNumSCId:[NSString stringStandard:strSCID]
                                                                              andcount:strNum
                                                                             andcartId:strCartId]
                                  subscribeNext:^(NSDictionary* dictionary) {
        @strongify(self)
        if ([dictionary[@"code"] intValue] == 1) {
            for (int i = 0; i < self.arrCart.count; i++) {
                NSMutableDictionary *dicMiddle = [NSMutableDictionary dictionaryWithDictionary:self.arrCart[i]];
                if ([TransformString(dicMiddle[@"sc_id"]) isEqualToString:strSCID]) {
                
                    NSMutableArray *arrMiddle = [NSMutableArray arrayWithArray:dicMiddle[@"goods"]];
                    
                    for (int j = 0; j<arrMiddle.count; j++) {
                        NSMutableDictionary *dicEnd = [NSMutableDictionary dictionaryWithDictionary:arrMiddle[j]];
                        if ([TransformString(dicEnd[@"id"]) isEqualToString:strCartId]) {
                            [dicEnd setObject:strNum forKey:@"count"];
                            [arrMiddle replaceObjectAtIndex:j withObject:dicEnd];
                            [dicMiddle setObject:arrMiddle forKey:@"goods"];
                            [dicMiddle setObject:[NSString stringStandard:dictionary[@"totalPrice"]] forKey:@"total_price"];
                            [self.arrCart replaceObjectAtIndex:i withObject:dicMiddle];
                            [self refrshCart];
                        }
                    }
                }
            }
        }else{
            [SVProgressHUD showErrorWithStatus:dictionary[@"msg"]];
        }
    }error:^(NSError *error) {
        @strongify(self)
        self.disposableChangeNum = nil;
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }completed:^{
        @strongify(self)
        self.disposableChangeNum = nil;
    }];
}

- (IBAction)clickButtonEdit:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    [self refrshCart];
}

- (IBAction)clickButtonSelectAll:(UIButton *)sender {
    [sender setSelected:!sender.selected];
    [self refrshCart];
}

- (IBAction)clickButtonPay:(UIButton *)sender {
    NSMutableArray *arrGoodId = [NSMutableArray array];
    for (int i = 0; i<self.arrCart.count; i++) {
        NSDictionary *dicMiddle = [NSDictionary dictionaryWithDictionary:self.arrCart[i]];
        NSArray *arrMiddle = [NSArray arrayWithArray:dicMiddle[@"goods"]];
        NSMutableArray *arrId = [NSMutableArray array];
        for (int j = 0; j<arrMiddle.count; j++) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:arrMiddle[j]];
            if ([dic[isSelected] boolValue]) {
                [arrId addObject:dic[@"id"]];
            }
        }
        if (arrId.count>0) {
            NSMutableDictionary *dicEnd = [NSMutableDictionary dictionary];
            [dicEnd setObject:dicMiddle[@"sc_id"] forKey:@"sc_id"];
            [dicEnd setObject:arrId forKey:@"goodsid"];
            [arrGoodId addObject:dicEnd];
        }
    }
    
    if (arrGoodId.count>0) {
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
        OrderesComfilmController *controller=[storyboard instantiateViewControllerWithIdentifier:@"OrderesComfilmController"];
        controller.isCart = YES;
        controller.arrCart = [NSMutableArray arrayWithArray:arrGoodId];
        [self.navigationController pushViewController:controller
                                             animated:YES];
    }
}

- (IBAction)clickButtonShare:(UIButton *)sender {
}

- (IBAction)clickButtonAttention:(UIButton *)sender {
}

- (IBAction)clickButtonDelete:(UIButton *)sender {
}


@end
