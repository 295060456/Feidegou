//
//  VendorDetailShopController.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/8/24.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "VendorDetailShopController.h"
#import "CellPicture.h"
#import "JJHttpClient+ShopGood.h"
#import "CellVendorAddress.h"
#import "CellVendorWebOlny.h"
#import "UIButton+Joker.h"
#import "CellTwoLblArrow.h"
#import "CellVendorGoodList.h"
#import "CellDiscussVendor.h"
#import "CellVendorTitle.h"
#import "CellVendorDiscount.h"
#import "VendorGoosListController.h"
#import "GoodDetailDiscussController.h"
#import "VendorDetailGoodController.h"
//使用自带地图
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationManager.h"
#import "VendorPayTheBillController.h"

@interface VendorDetailShopController ()
<RefreshControlDelegate,
UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tabVendor;
@property (nonatomic,strong) RefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *arrGood;
@property (strong, nonatomic) NSMutableArray *arrDiscuss;
@property (strong, nonatomic) NSMutableArray *arrPicture;
@property (strong, nonatomic) NSMutableDictionary *dicInfo;
@property (strong, nonatomic) NSString *strDiscussNum;
@property (nonatomic,strong) RACDisposable *disposableGood;
@property (nonatomic,strong) RACDisposable *disposableDiscuss;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) UIWebView *webDetail;
//@property (assign, nonatomic) float fDetailHeight;

@end

@implementation VendorDetailShopController
- (void)refreshWebview:(NSString *)strWebUrl{
    [self.webDetail setDelegate:self];
    //    [self.webDetail.scrollView setScrollEnabled:NO];
    if ([strWebUrl rangeOfString:@"http"].location == NSNotFound) {
        strWebUrl = [NSString stringWithFormat:@"http://%@",strWebUrl];
    }
    NSLog(@"url is %@",strWebUrl);
    self.webDetail.backgroundColor=[UIColor whiteColor];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strWebUrl]];
    [self.webDetail loadData:data MIMEType:@"text/html"
            textEncodingName:@"UTF-8"
                     baseURL:[NSURL URLWithString:strWebUrl]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    D_NSLog(@"webViewDidStartLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat webViewHeight = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    D_NSLog(@"webViewDidFinishLoad须知的高度%f",webViewHeight);
    [self.webDetail setFrame:CGRectMake(0, 0, SCREEN_WIDTH, webViewHeight+10)];
    [self.webDetail.scrollView setScrollEnabled:NO];
    [self.tabVendor reloadData];
}

- (void)webView:(UIWebView *)webView
didFailLoadWithError:(NSError *)error{
    
    D_NSLog(@"didFailLoadWithError");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webDetail = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
//    self.fDetailHeight = -1;
    [self.tabVendor registerNib:[UINib nibWithNibName:@"CellPicture" bundle:nil] forCellReuseIdentifier:@"CellPicture"];
    [self.tabVendor registerNib:[UINib nibWithNibName:@"CellVendorTitle" bundle:nil] forCellReuseIdentifier:@"CellVendorTitle"];
    [self.tabVendor registerNib:[UINib nibWithNibName:@"CellVendorAddress" bundle:nil] forCellReuseIdentifier:@"CellVendorAddress"];
    [self.tabVendor registerNib:[UINib nibWithNibName:@"CellVendorWebOlny" bundle:nil] forCellReuseIdentifier:@"CellVendorWebOlny"];
    [self.tabVendor registerNib:[UINib nibWithNibName:@"CellTwoLblArrow" bundle:nil] forCellReuseIdentifier:@"CellTwoLblArrow"];
    [self.tabVendor registerNib:[UINib nibWithNibName:@"CellVendorGoodList" bundle:nil] forCellReuseIdentifier:@"CellVendorGoodList"];
    [self.tabVendor registerNib:[UINib nibWithNibName:@"CellDiscussVendor" bundle:nil] forCellReuseIdentifier:@"CellDiscussVendor"];
    [self.tabVendor registerNib:[UINib nibWithNibName:@"CellVendorDiscount" bundle:nil] forCellReuseIdentifier:@"CellVendorDiscount"];
    self.refreshControl = [[RefreshControl new] initRefreshControlWithScrollView:self.tabVendor delegate:self];
    [self.refreshControl beginRefreshingMethod];
    [self showException];
    // Do any additional setup after loading the view.
}

- (void)requestDetail{
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestShopGoodVendorDetailstore_id:[NSString stringStandard:self.strStoreID]]
                         subscribeNext:^(NSDictionary* dictionary) {
        @strongify(self)
        if ([dictionary[@"code"] intValue]==1) {
            NSDictionary *dicDetail = dictionary[@"store"];
            if ([dicDetail isKindOfClass:[NSDictionary class]]) {
                self.dicInfo = [NSMutableDictionary dictionaryWithDictionary:dicDetail];
                if (![NSString isNullString:self.dicInfo[@"detailURL"]]) {
                    [self refreshWebview:self.dicInfo[@"detailURL"]];
                }
            }
            NSArray *arrPic = dictionary[@"photoUrl"];
            if ([arrPic isKindOfClass:[NSArray class]]) {
                self.arrPicture = [NSMutableArray arrayWithArray:arrPic];
            }
            CLLocationDegrees dLat = [[NSString stringStandardZero:self.dicInfo[@"store_lat"]] doubleValue];
            CLLocationDegrees dLng = [[NSString stringStandardZero:self.dicInfo[@"store_lng"]] doubleValue];
//            CLLocationCoordinate2D LocationBD09 = (CLLocationCoordinate2D){dLat, dLng};
            self.coordinate = [LocationManager bd09Decrypt:dLat bdLon:dLng];
            [self.tabVendor reloadData];
            [self hideException];
        }else{
            [self failedRequestException:enum_exception_timeout];
        }
    }error:^(NSError *error) {
        @strongify(self)
        self.disposable = nil;
        [self.refreshControl endRefreshing];
        if (error.code!=2) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
        [self failedRequestException:enum_exception_timeout];
    }completed:^{
        @strongify(self)
        [self.refreshControl endRefreshing];
        self.disposable = nil;
    }];
}

- (void)requestGoodList{
    @weakify(self)
    self.disposableGood = [[[JJHttpClient new] requestShopGoodVendorOtherGoodGoods_store_id:[NSString stringStandard:self.strStoreID]
                                                                                     andLimit:@"3"
                                                                                      andPage:@"1"
                                                                         andrealstore_approve:@"1"]
                             subscribeNext:^(NSArray* array) {
        @strongify(self)
        self.arrGood = [NSMutableArray arrayWithArray:array];
        [self.tabVendor reloadData];
        
    }error:^(NSError *error) {
        @strongify(self)
        self.disposableGood = nil;
    }completed:^{
        @strongify(self)
        self.disposableGood = nil;
    }];
//    myself.disposableGood = [[[JJHttpClient new] requestShopGoodVendorNearByLimit:@"3" andPage:@"1" andgoods_store_id:[NSString stringStandard:self.strStoreID]] subscribeNext:^(NSArray* array) {
//        myself.arrGood = [NSMutableArray arrayWithArray:array];
//        [myself.tabVendor reloadData];
//
//    }error:^(NSError *error) {
//        myself.disposableGood = nil;
//    }completed:^{
//        myself.disposableGood = nil;
//    }];
}

- (void)requestDiscuss{
    @weakify(self)
    self.disposableDiscuss = [[[JJHttpClient new] requestShopGoodDiscussListGoods_id:@""
                                                                              andLimit:@"3"
                                                                               andPage:@"1"
                                                                              andState:@""
                                                                           andstore_id:[NSString stringStandard:self.strStoreID]]
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
        [self.tabVendor reloadData];
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
    [self requestGoodList];
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
    if (section == 0&&self.arrPicture.count>0) {
        
        return 1;
    }
    //        名字
    if (section == 1) {
        int intNum = 0;
        if (self.dicInfo.count>0) {
            intNum++;
        }
        if ([self.dicInfo[@"gift_integral"] floatValue]>0) {
            intNum++;
        }
        return intNum;
    }
    //        地址
    if (section == 2) {
        if (![NSString isNullString:self.dicInfo[@"store_address"]]) {
            return 1;
        }
    }
    if (section == 3) {
        if (self.arrGood.count>0) {
            return 1;
        }
    }
    if (section == 4) {
        return self.arrGood.count;
    }
    if (section == 5) {
        if (self.arrDiscuss.count>0) {
            return 1;
        }
    }
    if (section == 6) {
        return self.arrDiscuss.count;
    }
    //        详情
    if (section == 7||section == 8) {
        if (![NSString isNullString:self.dicInfo[@"detailURL"]]) {
            return 1;
        }
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    图片
    if (indexPath.section == 0) {
        return SCREEN_WIDTH*5/8;
    }
//    名字
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            return 40;
        }
        NSString *strContent = self.dicInfo[@"store_name"];
        float fHeight = [NSString conculuteRightCGSizeOfString:strContent andWidth:SCREEN_WIDTH-105 andFont:15.0].height+45;
        return fHeight;
    }
//    地址
    if (indexPath.section == 2) {
        NSString *strContent = self.dicInfo[@"store_address"];
        float fHeight = [NSString conculuteRightCGSizeOfString:strContent andWidth:SCREEN_WIDTH-20 andFont:15.0].height+30;
        return fHeight;
    }
//    套餐
    if (indexPath.section == 3) {
        return 40;
    }
//    商品
    if (indexPath.section == 4) {
        return 90;
    }
//    评价总数
    if (indexPath.section == 5) {
        return 40;
    }
//    评价
    if (indexPath.section == 6) {
        NSString *strContent = self.arrDiscuss[indexPath.row][@"evaluate_info"];
        float fHeight = [NSString conculuteRightCGSizeOfString:strContent
                                                      andWidth:SCREEN_WIDTH-20
                                                       andFont:15.0].height+80;
        return fHeight;
    }
//    详情标题
    if (indexPath.section == 7) {
        if ([NSString isNullString:self.dicInfo[@"detailURL"]]) {
            return 0;
        }
        return 40;
    }
//    详情
    if (indexPath.section == 8) {
        if ([NSString isNullString:self.dicInfo[@"detailURL"]]) {
            return 0;
        }
        return self.webDetail.frame.size.height;
    }return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    if (indexPath.section == 0) {
        CellPicture *cell=[tableView dequeueReusableCellWithIdentifier:@"CellPicture"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateData:self.arrPicture];
        return cell;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
            CellVendorTitle *cell=[tableView dequeueReusableCellWithIdentifier:@"CellVendorTitle"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell populateData:self.dicInfo];
            [cell.btnBuy handleControlEvent:UIControlEventTouchUpInside
                                  withBlock:^{
                if ([[PersonalInfo sharedInstance] isLogined]) {
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardVendorDetail bundle:nil];
                    VendorPayTheBillController *controller = [storyboard instantiateViewControllerWithIdentifier:@"VendorPayTheBillController"];
                    controller.seller_user_id = self.strStoreID;
                    controller.store_name = self.dicInfo[@"store_name"];
                    controller.strTip = self.dicInfo[@"gift_integral"];
                    [self.navigationController pushViewController:controller animated:YES];
                }else{
                    [self pushLoginController];
                }
                
            }];
            return cell;
        }else{
            
            CellVendorDiscount *cell=[tableView dequeueReusableCellWithIdentifier:@"CellVendorDiscount"];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            NSString *strDiscount = TransformString(self.dicInfo[@"gift_integral"]);
            NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"线下买单送%@%%积分",strDiscount)];
            [atrStringPrice addAttributes:@{NSForegroundColorAttributeName:ColorRed} range:NSMakeRange(5, strDiscount.length+1)];
            [cell.lblDiscount setAttributedText:atrStringPrice];
            return cell;
        }
    }
    if (indexPath.section == 2) {
        CellVendorAddress *cell=[tableView dequeueReusableCellWithIdentifier:@"CellVendorAddress"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.lblAddress setTextNull:self.dicInfo[@"store_address"]];
        [cell.btnPhone handleControlEvent:UIControlEventTouchUpInside
                                withBlock:^{
            @strongify(self)
            [self dail];
        }];
        return cell;
    }
    if (indexPath.section == 3) {
        CellTwoLblArrow *cell=[tableView dequeueReusableCellWithIdentifier:@"CellTwoLblArrow"];
        [cell.lblName setTextNull:@"店铺优惠"];
        [cell.lblContent setTextNull:@""];
        [cell.imgArrow setHidden:NO];
        return cell;
    }
    if (indexPath.section == 4) {
        CellVendorGoodList *cell=[tableView dequeueReusableCellWithIdentifier:@"CellVendorGoodList"];
        [cell populataData:self.arrGood[indexPath.row]];
        return cell;
    }
    if (indexPath.section == 5) {
        CellTwoLblArrow *cell=[tableView dequeueReusableCellWithIdentifier:@"CellTwoLblArrow"];
        [cell.lblName setTextNull:@"用户评价"];
        [cell.lblContent setTextNull:@""];
        [cell.lblContent setTextNull:StringFormat(@"%@人评价",self.strDiscussNum)];
        [cell.imgArrow setHidden:NO];
        return cell;
    }
    if (indexPath.section == 6) {
        CellDiscussVendor *cell=[tableView dequeueReusableCellWithIdentifier:@"CellDiscussVendor"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populataData:self.arrDiscuss[indexPath.row]];
        return cell;
    }
    if (indexPath.section == 7) {
        CellTwoLblArrow *cell=[tableView dequeueReusableCellWithIdentifier:@"CellTwoLblArrow"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.lblName setTextNull:@"详情"];
        [cell.lblContent setTextNull:@""];
        [cell.imgArrow setHidden:YES];
        return cell;
    }
    if (indexPath.section == 8) {
        CellVendorWebOlny *cell=[tableView dequeueReusableCellWithIdentifier:@"CellVendorWebOlny"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell addSubview:self.webDetail];
        return cell;
    }
    CellPicture *cell=[tableView dequeueReusableCellWithIdentifier:@"CellPicture"];
    return cell;
}

- (void)dail{
    NSString *strPhone = self.dicInfo[@"store_telephone"];
    if ([NSString isNullString:strPhone]) {
        [JJAlertViewOneButton.new showAlertView:self
                                       andTitle:nil
                                     andMessage:@"暂无商家电话"
                                      andCancel:@"确定"
                                  andCanelIsRed:YES
                                        andBack:^{
            [[PersonalInfo sharedInstance] deleteLoginUserInfo];
        }];
    }else{
        [JJAlertViewTwoButton.new showAlertView:self
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

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 3) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardVendorDetail bundle:nil];
        VendorGoosListController *controller = [storyboard instantiateViewControllerWithIdentifier:@"VendorGoosListController"];
        controller.strStoreID = self.strStoreID;
        [self.navigationController pushViewController:controller animated:YES];
    }
    if (indexPath.section == 2) {
        [self clickGPS];
    }
    if (indexPath.section == 4) {
        ModelGood *model = self.arrGood[indexPath.row];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardVendorDetail bundle:nil];
        VendorDetailGoodController *controller = [storyboard instantiateViewControllerWithIdentifier:@"VendorDetailGoodController"];
        controller.strGoodId = model.goods_id;
        [self.navigationController pushViewController:controller animated:YES];
    }
    if (indexPath.section == 5) {
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
        GoodDetailDiscussController *controller = [storyboard instantiateViewControllerWithIdentifier:@"GoodDetailDiscussController"];
        controller.store_id = self.strStoreID;
        
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3&&self.arrGood.count>0) {
        return 10;
    }
    if (section == 5&&self.arrDiscuss.count>0) {
        return 10;
    }
    if (section == 7&&![NSString isNullString:self.dicInfo[@"detailURL"]]) {
        return 10;
    }return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView
        viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                SCREEN_WIDTH,
                                                                10)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    return viHeader;
}

- (void)clickGPS{
    NSString *strAddress = self.dicInfo[@"goods"][@"store_address"];
//    WGS84、GCJ-02、BD-09地图一般有三种坐标，这里是显示GCJ-02坐标（国标）
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"导航到设备"
                                                                              message:nil
                                                                       preferredStyle:UIAlertControllerStyleActionSheet];
    //自带地图
    [alertController addAction:[UIAlertAction actionWithTitle:@"自带地图"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"alertController -- 自带地图");
        //使用自带地图导航
        MKMapItem *currentLocation =[MKMapItem mapItemForCurrentLocation];
        
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.coordinate
                                                                                           addressDictionary:nil]];
        toLocation.name = strAddress; //目的地名字
        [MKMapItem openMapsWithItems:@[currentLocation,toLocation] launchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                                                                                   MKLaunchOptionsShowsTrafficKey:[NSNumber numberWithBool:YES]}];
        
        
    }]];
    
    //判断是否安装了高德地图，如果安装了高德地图，则使用高德地图导航
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        
        [alertController addAction:[UIAlertAction actionWithTitle:@"高德地图"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
            
            NSLog(@"alertController -- 高德地图");
            NSString *urlsting =[[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@ &backScheme= &lat=%f&lon=%f&dev=0&style=2",strAddress,self.coordinate.latitude,self.coordinate.longitude]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:urlsting]];
        }]];
    }
    
    //判断是否安装了百度地图，如果安装了百度地图，则使用百度地图导航
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"百度地图"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"alertController -- 百度地图");
            NSString *urlsting =[[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02",self.coordinate.latitude,self.coordinate.longitude,strAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlsting]];
        }]];
    }
    
    //添加取消选项
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    //显示alertController
    [self presentViewController:alertController
                       animated:YES
                     completion:nil];
}


@end
