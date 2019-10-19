//
//  VendorDetailGoodController.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/24.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "VendorDetailGoodController.h"
#import "JJHttpClient+ShopGood.h"
#import "CellVendorGoodPic.h"
#import "CellVendorGoodBuy.h"
#import "CellVendorGoodShopInfo.h"
#import "CellVendorWebOlny.h"
#import "CellDiscussVendor.h"
#import "CellTwoLblArrow.h"
#import "GoodDetailDiscussController.h"
#import "CellMyService.h"
#import "VendorDetailShopController.h"
#import "UIButton+Joker.h"
#import "CellVendorGoodType.h"
#import "OrderesComfilmController.h"

@interface VendorDetailGoodController ()
<
RefreshControlDelegate,
DidClickCollectionViewDelegete,
UIWebViewDelegate
>

@property (weak, nonatomic) IBOutlet BaseTableView *tabGood;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (nonatomic,strong) RACDisposable *disposableDiscuss;
@property (nonatomic,strong) RACDisposable *disposableGoodNum;
@property (strong, nonatomic) NSMutableArray *arrDiscuss;
@property (strong, nonatomic) NSMutableArray *arrPicture;
@property (strong, nonatomic) NSMutableDictionary *dicInfo;
//@property (assign, nonatomic) float fDetailHeight;
@property (assign, nonatomic) float fTypeHeight;
@property (strong, nonatomic) NSString *strDiscussNum;
@property (strong, nonatomic) NSMutableArray *arrProperty;
@property (strong, nonatomic) UIWebView *webDetail;
//请求价格获得的参数
@property (strong, nonatomic) NSString *strAttributeName;//属性名字
@property (strong, nonatomic) NSString *strAttribute;//属性值（用于下单）
@property (strong, nonatomic) NSString *strGoodPrice;//价格
@property (strong, nonatomic) NSString *strGoodPriceOld;//价格
@property (strong, nonatomic) NSString *strGive_integral;//价格
@property (assign, nonatomic) BOOL isSelectedAll;//是否选择了全部属性
//立即抢购
@property (strong, nonatomic) UIView *viBuy;
@property (strong, nonatomic) UILabel *lblMoney;
@property (strong, nonatomic) UIView *viSend;
@property (strong, nonatomic) UILabel *lblSend;
@property (strong, nonatomic) UILabel *lblLinePrice;

@end

@implementation VendorDetailGoodController

- (void)refreshWebview:(NSString *)strWebUrl{
    [self.webDetail setDelegate:self];
//    [self.webDetail.scrollView setScrollEnabled:NO];
    if ([strWebUrl rangeOfString:@"http"].location == NSNotFound) {
        strWebUrl = [NSString stringWithFormat:@"http://%@",strWebUrl];
    }
    NSLog(@"url is %@",strWebUrl);
    self.webDetail.backgroundColor=[UIColor whiteColor];
    
    
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strWebUrl]];
    [self.webDetail loadData:data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:strWebUrl]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    D_NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    D_NSLog(@"webViewDidFinishLoad须知的高度%f",webViewHeight);
    [self.webDetail setFrame:CGRectMake(0, 0, SCREEN_WIDTH, webViewHeight+10)];
    [self.webDetail.scrollView setScrollEnabled:NO];
    [self reloadDataOfTabView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    D_NSLog(@"didFailLoadWithError");
}

- (void)reloadDataOfTabView{
    [self initPriceView];
    [self.tabGood reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webDetail = [[UIWebView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 SCREEN_WIDTH,
                                                                 200)];
//    self.fDetailHeight = -1;
    self.fTypeHeight = -1;
    [self.tabGood setBackgroundColor:ColorBackground];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellVendorGoodPic" bundle:nil] forCellReuseIdentifier:@"CellVendorGoodPic"];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellVendorGoodBuy" bundle:nil] forCellReuseIdentifier:@"CellVendorGoodBuy"];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellVendorGoodShopInfo" bundle:nil] forCellReuseIdentifier:@"CellVendorGoodShopInfo"];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellVendorWebOlny" bundle:nil] forCellReuseIdentifier:@"CellVendorWebOlny"];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellDiscussVendor" bundle:nil] forCellReuseIdentifier:@"CellDiscussVendor"];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellTwoLblArrow" bundle:nil] forCellReuseIdentifier:@"CellTwoLblArrow"];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellMyService" bundle:nil] forCellReuseIdentifier:@"CellMyService"];
    [self.tabGood registerNib:[UINib nibWithNibName:@"CellVendorGoodType" bundle:nil] forCellReuseIdentifier:@"CellVendorGoodType"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabGood delegate:self];
    [self.refreshControl beginRefreshingMethod];
    [self showException];
    // Do any additional setup after loading the view.
}

- (void)initPriceView{
    @weakify(self)
    if (!self.viBuy) {
        self.viBuy = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              SCREEN_WIDTH,
                                                              SCREEN_WIDTH,
                                                              80)];
        [self.viBuy setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.95]];
        [self.tabGood addSubview:self.viBuy];
        UIButton *btnBuy = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-75-10,
                                                                      10,
                                                                      75,
                                                                      35)];
        [btnBuy.layer setCornerRadius:3.0];
        [btnBuy setClipsToBounds:YES];
        [btnBuy setBackgroundColor:ColorHeader];
        [btnBuy setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateNormal];
        [btnBuy setTitleColor:[UIColor darkGrayColor]
                     forState:UIControlStateHighlighted];
        [btnBuy setTitle:@"立即抢购" forState:UIControlStateNormal];
        [btnBuy.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [btnBuy handleControlEvent:UIControlEventTouchUpInside
                         withBlock:^{
            @strongify(self)
            [self clickButtonCreateOrder:btnBuy];
        }];
        [self.viBuy addSubview:btnBuy];
        self.lblMoney = [[UILabel alloc] initWithFrame:CGRectMake(10,
                                                                  17,
                                                                  CGRectGetMinX(btnBuy.frame)-10,
                                                                  20)];
        [self.lblMoney setTextColor:ColorRed];
        [self.viBuy addSubview:self.lblMoney];
        
        self.viSend = [[UIView alloc] initWithFrame:CGRectMake(10,
                                                               CGRectGetHeight(self.viBuy.frame),
                                                               SCREEN_WIDTH-20,
                                                               20)];
        UILabel *lblTip = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                    (CGRectGetHeight(self.viSend.frame)-16)/2,
                                                                    16,
                                                                    16)];
        [lblTip.layer setCornerRadius:3.0];
        [lblTip setClipsToBounds:YES];
        [lblTip setText:@"送"];
        [lblTip setFont:[UIFont systemFontOfSize:10]];
        [lblTip setTextColor:[UIColor whiteColor]];
        [lblTip setBackgroundColor:ColorRed];
        [lblTip setTextAlignment:NSTextAlignmentCenter];
        [self.viSend addSubview:lblTip];
        
        self.lblSend = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lblTip.frame)+2,
                                                                 0,
                                                                 SCREEN_WIDTH-100,
                                                                 CGRectGetHeight(self.viSend.frame))];
        [self.lblSend setFont:[UIFont systemFontOfSize:13]];
        [self.lblSend setTextColor:ColorGaryDark];
        [self.viSend addSubview:self.lblSend];
        
        [self.viBuy addSubview:self.viSend];
        self.lblLinePrice = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                      CGRectGetHeight(self.viBuy.frame)-0.5,
                                                                      CGRectGetWidth(self.viBuy.frame),
                                                                      0.5)];
        [self.lblLinePrice setBackgroundColor:ColorLine];
        [self.viBuy addSubview:self.lblLinePrice];
    }
    [self.lblMoney setTextVendorPrice:self.strGoodPrice
                          andOldPrice:self.strGoodPriceOld];
    
    CGFloat fHeight;
    if ([self.strGive_integral floatValue]>0) {
        [self.viSend setHidden:NO];
        fHeight = 80;
    }else{
        fHeight = 60;
        [self.viSend setHidden:YES];
    }
    [self.viBuy setFrame:CGRectMake(0,
                                    SCREEN_WIDTH,
                                    SCREEN_WIDTH,
                                    fHeight)];
    [self.viSend setFrame:CGRectMake(10,
                                     CGRectGetHeight(self.viBuy.frame)-30,
                                     SCREEN_WIDTH-20,
                                     20)];
    [self.lblLinePrice setFrame:CGRectMake(0,
                                           CGRectGetHeight(self.viBuy.frame)-1,
                                           CGRectGetWidth(self.viBuy.frame),
                                           0.5)];
    [self.lblSend setTextNull:StringFormat(@"购买后送%@",self.strGive_integral)];
//    NSDictionary *dicInfo = self.dicInfo[@"goods"];
    
//    NSString *strPriceNow = [NSString stringStandardFloatTwo:self.strGoodPrice];
//    if ([dicInfo[@"use_integral_set"] intValue]==2) {
//        NSString *strIntegral = [NSString stringStandardFloatTwo:dicInfo[@"use_integral_value"]];
//        NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"￥%@+%@%@",strPriceNow,strIntegral,[NSString stringStandardToIntegralOrRedPacket:dicInfo[@"good_area"]])];
//        [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} range:NSMakeRange(1, strPriceNow.length)];
//        [self.lblMoney setAttributedText:atrStringPrice];
//    }else{
//        NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"￥%@",strPriceNow)];
//        [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} range:NSMakeRange(1, strPriceNow.length)];
//        [self.lblMoney setAttributedText:atrStringPrice];
//    }
}

- (void)requestDetail{
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestShopGoodDetailGoods_id:[NSString stringStandard:self.strGoodId]]
                         subscribeNext:^(NSDictionary* dictionary) {
        @strongify(self)
        if ([dictionary[@"code"] intValue]==1) {
            self.strGoodPrice = dictionary[@"goods"][@"store_price"];
            self.strGoodPriceOld = dictionary[@"goods"][@"goods_price"];
            self.strGive_integral = dictionary[@"goods"][@"give_integral"];
            NSArray *arrPic = dictionary[@"photoUrl"];
            if ([arrPic isKindOfClass:[NSArray class]]) {
                self.arrPicture = [NSMutableArray arrayWithArray:arrPic];
            }
            NSArray *arrProperty = dictionary[@"property"];
            if ([arrProperty isKindOfClass:[NSArray class]]) {
                self.arrProperty = [NSMutableArray arrayWithArray:arrProperty];
            }
            if ([dictionary isKindOfClass:[NSDictionary class]]) {
                self.dicInfo = [NSMutableDictionary dictionaryWithDictionary:dictionary];
                if (![NSString isNullString:self.dicInfo[@"goods"][@"detailURL"]]) {
                    [self refreshWebview:self.dicInfo[@"goods"][@"detailURL"]];
                }
            }
            [self reloadDataOfTabView];
            [self hideException];
        }else{
            [self failedRequestException:enum_exception_timeout];
        }
    }error:^(NSError *error) {
        @strongify(self)
        [self failedRequestException:enum_exception_timeout];
        self.disposable = nil;
        [self.refreshControl endRefreshing];
    }completed:^{
        @strongify(self)
        self.disposable = nil;
        [self.refreshControl endRefreshing];
    }];
}

- (void)requestDiscuss{
    @weakify(self)
    self.disposableDiscuss = [[[JJHttpClient new] requestShopGoodDiscussListGoods_id:[NSString stringStandard:self.strGoodId]
                                                                              andLimit:@"3"
                                                                               andPage:@"1"
                                                                              andState:@""
                                                                           andstore_id:@""]
                                subscribeNext:^(NSDictionary* dictionary) {
        @strongify(self)
        NSArray *array;
        self.strDiscussNum = [NSString stringStandardZero:dictionary[@"all"]];
        if ([dictionary[@"evaluate"] isKindOfClass:[NSArray class]]) {
            array = [NSArray arrayWithArray:dictionary[@"evaluate"]];
        }else{
            array = [NSArray array];
        }
        self.arrDiscuss = [NSMutableArray arrayWithArray:array];
        [self reloadDataOfTabView];
        
    }error:^(NSError *error) {
        @strongify(self)
        self.disposableDiscuss = nil;
    }completed:^{
        @strongify(self)
        self.disposableDiscuss = nil;
    }];
}
#pragma mark - RefreshControlDelegate
-(void)refreshControlForRefreshData{
    //从远程服务器获取数据
    [self requestDetail];
    [self requestDiscuss];
}

-(BOOL)refreshControlEnableRefresh{
    return YES;
}

-(BOOL)refreshControlEnableLoadMore{
    return NO;
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    图片
    if (section == 0) {
        if (self.dicInfo.count>0) {
            return 1;
        }
    }
    //        价格
    if (section == 1) {
        if (self.dicInfo.count>0) {
            return 1;
        }
    }
    //        数量
    if (section == 2) {
        if (self.dicInfo.count>0) {
            return 1;
        }
    }
//    参数
    if (section == 3) {
        if (self.arrProperty.count>0) {
            return 1;
        }
    }
//    商家信息提示
    if (section == 4) {
        if (self.dicInfo.count>0) {
            return 1;
        }
    }
//    商家信息
    if (section == 5) {
        if (self.dicInfo.count>0) {
            return 1;
        }
    }
//    购买须知提示
    if (section == 6) {
        if (self.dicInfo.count>0) {
            return 1;
        }
    }
//    购买须知
    if (section == 7) {
        if (self.dicInfo.count>0) {
            return 1;
        }
    }
//    用户评价提示
    if (section == 8) {
        if (self.arrDiscuss.count>0) {
            return 1;
        }
    }
//    用户评价
    if (section == 9) {
        if (self.arrDiscuss.count>0) {
            return 1;
        }
    }return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    图片
    if (indexPath.section == 0) {
        return SCREEN_WIDTH;
    }
    //    价格
    if (indexPath.section == 1) {
        if ([self.strGive_integral floatValue]>0) {
            return 80;
        }else{
            return 60;
        }
    }
    //    数量
    if (indexPath.section == 2) {
        return 40;
    }
    //    属性
    if (indexPath.section == 3) {
        if (self.fTypeHeight<0) {
            return 60;
        }
        return self.fTypeHeight;
    }
    //    商家信息提示
    if (indexPath.section == 4) {
        return 40;
    }
    //    商家信息
    if (indexPath.section == 5) {
        return 60;
    }
    //    购买须知提示
    if (indexPath.section == 6) {
        if ([NSString isNullString:self.dicInfo[@"goods"][@"detailURL"]]) {
            return 0;
        }
        return 40;
    }
    //    购买须知
    if (indexPath.section == 7) {
        if ([NSString isNullString:self.dicInfo[@"goods"][@"detailURL"]]) {
            return 0;
        }
//        if (self.fDetailHeight<0) {
//            return SCREEN_WIDTH;
//        }
//        return self.fDetailHeight;
        return self.webDetail.frame.size.height;
    }
    //    评价提示
    if (indexPath.section == 8) {
        return 40;
    }
    //    评价
    if (indexPath.section == 9) {
        NSString *strContent = self.arrDiscuss[indexPath.row][@"evaluate_info"];
        float fHeight = [NSString conculuteRightCGSizeOfString:strContent andWidth:SCREEN_WIDTH-20 andFont:15.0].height+80;
        return fHeight;
    }
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    if (indexPath.section == 0) {
        CellVendorGoodPic *cell=[tableView dequeueReusableCellWithIdentifier:@"CellVendorGoodPic"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateData:self.arrPicture andTitle:self.dicInfo];
        return cell;
    }
    if (indexPath.section == 1) {
        CellVendorGoodBuy *cell=[tableView dequeueReusableCellWithIdentifier:@"CellVendorGoodBuy"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        [cell populateData:self.dicInfo[@"goods"] andPrice:self.strGoodPrice];
//        [cell.btnBuy handleControlEvent:UIControlEventTouchUpInside withBlock:^{
//            [self clickButtonCreateOrder:cell.btnBuy];
//        }];
        [cell.lblMoney setHidden:YES];
        [cell.btnBuy setHidden:YES];
        return cell;
    }
    if (indexPath.section == 2) {
        CellMyService *cell=[tableView dequeueReusableCellWithIdentifier:@"CellMyService"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.lblName setTextColor:ColorGaryDark];
        [cell.imgHead setImage:ImageNamed(@"img_vendor_ys")];
        [cell.lblName setTextNull:StringFormat(@"%@人付款",[NSString stringStandardZero:self.dicInfo[@"goods"][@"goods_salenum"]])];
        [cell.lblNum setText:@""];
        [cell.imgArrow setHidden:YES];
        return cell;
    }
    if (indexPath.section == 3) {
        CellVendorGoodType *cell = [tableView dequeueReusableCellWithIdentifier:@"CellVendorGoodType"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateDataArray:self.arrProperty];
        [cell setDelegete:self];
        [cell.collectionView performBatchUpdates:^{
            //更新collection的约束一定要写在reload完成之前,否则会导致crash
        } completion:^(BOOL finished) {
            @strongify(self)
            //这里为了防止循环调用该方法,引入isNeedRefresh属性来做控制
            if (self.fTypeHeight < 0) {
                self.fTypeHeight = cell.collectionView.collectionViewLayout.collectionViewContentSize.height;
                D_NSLog(@"须知的高度%f",self.fTypeHeight);
                [self reloadDataOfTabView];
            }
        }];return cell;
    }
    if (indexPath.section == 4) {
        CellTwoLblArrow *cell = [tableView dequeueReusableCellWithIdentifier:@"CellTwoLblArrow"];
        [cell.lblName setTextNull:@"商家信息"];
        [cell.lblContent setTextNull:@""];
        [cell.imgArrow setHidden:NO];
        return cell;
    }
    if (indexPath.section == 5) {
        CellVendorGoodShopInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"CellVendorGoodShopInfo"];
        [cell populataData:self.dicInfo];
        [cell.btnPhone handleControlEvent:UIControlEventTouchUpInside
                                withBlock:^{
            @strongify(self)
            [self dail];
        }];return cell;
    }
    if (indexPath.section == 6) {
        CellTwoLblArrow *cell=[tableView dequeueReusableCellWithIdentifier:@"CellTwoLblArrow"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.lblName setTextNull:@"购买须知"];
        [cell.lblContent setTextNull:@""];
        [cell.imgArrow setHidden:YES];
        return cell;
    }
    if (indexPath.section == 7) {
        CellVendorWebOlny *cell = [tableView dequeueReusableCellWithIdentifier:@"CellVendorWebOlny"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell addSubview:self.webDetail];
//        [cell populataData:self.dicInfo[@"goods"][@"detailURL"]];
//        cell.webViewHeight = ^(CGFloat fWebHeight){
//            if (self.fDetailHeight<0) {
//                self.fDetailHeight = fWebHeight;
//                D_NSLog(@"须知的高度%f",fWebHeight);
//                [self reloadDataOfTabView];
//            }
//        };
        return cell;
    }
    if (indexPath.section == 8) {
        CellTwoLblArrow *cell=[tableView dequeueReusableCellWithIdentifier:@"CellTwoLblArrow"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.lblName setTextNull:@"用户评价"];
        [cell.lblContent setTextNull:StringFormat(@"%@人评价",self.strDiscussNum)];
        [cell.imgArrow setHidden:NO];
        return cell;
    }
    if (indexPath.section == 9) {
        CellDiscussVendor *cell=[tableView dequeueReusableCellWithIdentifier:@"CellDiscussVendor"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populataData:self.arrDiscuss[indexPath.row]];
        return cell;
    }
    CellTwoLblArrow *cell=[tableView dequeueReusableCellWithIdentifier:@"CellTwoLblArrow"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.lblName setTextNull:@""];
    [cell.lblContent setTextNull:@""];
    [cell.imgArrow setHidden:YES];
    return cell;
}

- (void)dail{
    NSString *strPhone = self.dicInfo[@"goods"][@"store_telephone"];
    if ([NSString isNullString:strPhone]) {
        JJAlertViewOneButton *alertView = [[JJAlertViewOneButton alloc] init];
        [alertView showAlertView:self
                        andTitle:nil
                      andMessage:@"暂无商家电话"
                       andCancel:@"确定"
                   andCanelIsRed:YES
                         andBack:^{
            D_NSLog(@"点击了确定");
            [[PersonalInfo sharedInstance] deleteLoginUserInfo];
        }];
    }else{
        JJAlertViewTwoButton *alertView = [[JJAlertViewTwoButton alloc] init];
        [alertView showAlertView:self
                        andTitle:nil
                      andMessage:@"是否拨打电话"
                       andCancel:@"取消"
                   andCanelIsRed:NO
                   andOherButton:@"立即拨打"
                      andConfirm:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:StringFormat(@"tel://%@",strPhone)]]; //拨号
        } andCancel:^{
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 8) {

        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain
                                                           bundle:nil];
        GoodDetailDiscussController *controller = [storyboard instantiateViewControllerWithIdentifier:@"GoodDetailDiscussController"];
        controller.strGood_id = self.strGoodId;
        
        [self.navigationController pushViewController:controller
                                             animated:YES];
    }
    if (indexPath.section == 4||indexPath.section == 5) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardVendorDetail
                                                             bundle:nil];
        VendorDetailShopController *controller = [storyboard instantiateViewControllerWithIdentifier:@"VendorDetailShopController"];
        controller.strStoreID = self.dicInfo[@"goods"][@"goods_store_id"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3&&self.arrProperty.count>0) {
        return 10;
    }
    if (section == 4&&self.dicInfo.count>0) {
        return 10;
    }
    if (section == 6&&![NSString isNullString:self.dicInfo[@"goods"][@"detailURL"]]) {
        return 10;
    }
    if (section == 8&&self.arrDiscuss.count>0) {
        return 10;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    return viHeader;
}

- (void)didClickCollectionViewSectionDetail:(NSArray *)arrAttribute
                     andGoodsspecpropertyId:(NSString *)GoodsspecpropertyId
           andGoodsspecpropertyValueAndName:(NSString *)GoodsspecpropertyValueAndName
                             andIsSelectAll:(BOOL)isSelected{
    self.arrProperty = [NSMutableArray arrayWithArray:arrAttribute];
    self.strAttribute = GoodsspecpropertyId;
    self.strAttributeName = GoodsspecpropertyValueAndName;
    self.isSelectedAll = isSelected;
    if (isSelected) {
        D_NSLog(@"已全部选择完毕，可以请求库存%@",GoodsspecpropertyId);
        __weak VendorDetailGoodController *myself = self;
        [myself.disposableGoodNum dispose];
        myself.disposableGoodNum = [[[JJHttpClient new] requestShopGoodGoodNumGoodsspecpropertyId:GoodsspecpropertyId
                                                                                       andGoodsId:[NSString stringStandard:self.strGoodId]]
                                    subscribeNext:^(NSDictionary* dictionary) {
            D_NSLog(@"msg is %@",dictionary[@"msg"]);
            myself.strGoodPrice = dictionary[@"store_price"];
            myself.strGoodPriceOld = dictionary[@"goods_price"];
            myself.strGive_integral = dictionary[@"give_integral"];
            [myself reloadDataOfTabView];
        }error:^(NSError *error) {
            [myself failedRequestException:enum_exception_timeout];
            myself.disposableGoodNum = nil;
        }completed:^{
            myself.disposableGoodNum = nil;
        }];
    }else{
        D_NSLog(@"未全部选择完毕，不需请求库存");
    }
}

#pragma mark--  选择了属性后跳到订单详情页面
- (void)clickButtonCreateOrder:(UIButton *)sender{
    if (self.arrProperty.count>0) {
        if (!self.isSelectedAll) {
            [SVProgressHUD showErrorWithStatus:@"请选择商品属性"];
            return;
        }
        if (self.disposableGoodNum) {
            [SVProgressHUD showErrorWithStatus:@"正在请求商品价格,请稍后..."];
            return;
        }
    }
    if ([[PersonalInfo sharedInstance] isLogined]) {
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
        OrderesComfilmController *controller=[storyboard instantiateViewControllerWithIdentifier:@"OrderesComfilmController"];
        controller.dicDetail = [NSDictionary dictionaryWithDictionary:self.dicInfo];
        controller.intBuyNum = 1;
        controller.strGoodPrice = self.strGoodPrice;
        controller.strAttribute = self.strAttribute;
        controller.strAttributeName = self.strAttributeName;
        controller.strGood_id = self.strGoodId;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [self pushLoginController];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    D_NSLog(@"self.tabGood.contentOffset.y is %f",self.tabGood.contentOffset.y);
    CGFloat fOffSet = self.tabGood.contentOffset.y;
    CGRect rect = self.viBuy.frame;
    if (fOffSet>SCREEN_WIDTH) {
        rect.origin.y = fOffSet;
    }else{
        rect.origin.y = SCREEN_WIDTH;
    }
    [self.viBuy setFrame:rect];
}


@end
