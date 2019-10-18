//
//  GoodDetialAllController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/27.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "GoodDetialAllController.h"
#import "JJHttpClient+ShopGood.h"
#import "JJHttpClient+FourZero.h"
#import "GoodDetailController.h"
#import "GoodDetailPicController.h"
#import "GoodDetailDiscussController.h"
#import "CellGoodDetai.h"
#import "CLCellGoodProperty.h"
#import "ReusableViewProperty.h"
#import "CLCellGoodNum.h"
#import "OrderesComfilmController.h"
#import "UIButton+Joker.h"
#import "ButtonUpDown.h"
#import "JJDBHelper+ShopCart.h"
#import "GoodOtherListController.h"
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "GoodShareController.h"

typedef enum{
    GoodNone,
    GoodCart,
    GoodOrder
}GoodCartOrOrder;
@interface GoodDetialAllController ()<UIPageViewControllerDataSource,UIPageViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *viContainer;
@property (weak, nonatomic) IBOutlet UIButton *btnConmmit;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;
//商品详情
@property (strong, nonatomic) NSDictionary *dicDetail;

@property (strong, nonatomic) NSMutableArray *pages;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (assign, nonatomic) NSInteger intSelected;
@property (strong, nonatomic) UILabel *lblLine;
@property (strong, nonatomic) UIView *viHeader;




@property (strong, nonatomic) UIView *viCreateBack;
@property (strong, nonatomic) UIView *viCreateOrder;
@property (strong, nonatomic) UICollectionView *collectionSelectType;
@property (strong, nonatomic) NSMutableArray *arrSelectType;
//库存
@property (strong, nonatomic) NSString *strGoodNum;
//价格
@property (strong, nonatomic) NSString *strGoodPrice;
@property (strong, nonatomic) UILabel *lblPrice;
@property (assign, nonatomic) int intBuyNum;
@property (nonatomic,strong) RACDisposable *disposableGoodNum;
@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (assign, nonatomic) GoodCartOrOrder goodCartOrOrder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintCartAddWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintCartAddTrailing;



@end
@implementation GoodDetialAllController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    self.goodCartOrOrder = GoodNone;
    [self.btnBuy setBackgroundColor:ColorRed];
    [self.btnConmmit setBackgroundColor:ColorYellow];
    [self requestData];
}
- (void)requestData{
    [self showException];
    __weak GoodDetialAllController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodDetailGoods_id:[NSString stringStandard:self.strGood_id]] subscribeNext:^(NSDictionary* dictionary) {
        if ([dictionary[@"code"] intValue]==0) {
            [myself failedRequestException:enum_exception_timeout];
            return ;
        }
        myself.dicDetail = [NSDictionary dictionaryWithDictionary:dictionary];
        
        NSArray *arrProperty = self.dicDetail[@"property"];
        if ([arrProperty isKindOfClass:[NSArray class]]) {
            self.arrSelectType = [NSMutableArray arrayWithArray:arrProperty];
            self.strGoodNum = self.dicDetail[@"goods"][@"goods_inventory"];
            self.strGoodPrice = self.dicDetail[@"goods"][@"store_price"];
            self.intBuyNum = 1;
        }
        [myself initHeaderView];
        [myself hideException];
    }error:^(NSError *error) {
        [myself failedRequestException:enum_exception_timeout];
        myself.disposable = nil;
    }completed:^{
        
        myself.disposable = nil;
    }];
    
}
- (void)initHeaderView{
    
    NSString *strShareUrl = self.dicDetail[@"shareGoodsUrl"];
    if ([NSString isNullString:strShareUrl]) {
        [self.btnShare setHidden:YES];
    }else{
        [self.btnShare setHidden:NO];
    }
    
    self.viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 180, 44)];
    for (int i = 0; i<3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(i*60, 0, 60, CGRectGetHeight(self.viHeader.frame))];
        [button.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [button addTarget:self action:@selector(clickButtonHeader:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:100+i];
        NSString *strTitle;
        if (i == 0) {
            strTitle = @"商品";
        }else if (i == 1){
            strTitle = @"详情";
        }else{
            strTitle = @"评价";
        }
        [button setTitleColor:ColorBlack forState:UIControlStateNormal];
        [button setTitle:strTitle forState:UIControlStateNormal];
        [self.viHeader addSubview:button];
    }
//    if ([self.dicDetail[@"goods"][@"good_area"] intValue]==2) {
//        self.layoutConstraintCartAddWidth.constant = 0;
//        self.layoutConstraintCartAddTrailing.constant = 200;
//    }else{
//        self.layoutConstraintCartAddWidth.constant = 110;
//        self.layoutConstraintCartAddTrailing.constant = 90;
//    }
    self.lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.viHeader.frame)-2, 60, 2)];
    [self.lblLine setBackgroundColor:ColorBlack];
    [self.viHeader addSubview:self.lblLine];
    self.navigationItem.titleView = self.viHeader;
    [self setLayout];
}
- (void)clickButtonHeader:(UIButton *)sender{
    [self pageControlValueChanged:sender.tag];
}
- (void)setLayout{
    /**
     *100代表商品，101代表详情，102代表评价
     */
    self.intSelected = 100;
    self.pages = [NSMutableArray array];
    for (int i =0 ; i< 3; i++) {
        if (i == 0) {
            GoodDetailController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodDetailController"];
            controller.dicDetail = self.dicDetail;
            controller.strGood_id = self.strGood_id;
            [self.pages addObject:controller];
        }else if (i == 1){
            GoodDetailPicController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodDetailPicController"];
            controller.dicDetail = self.dicDetail;
            controller.strGood_id = self.strGood_id;
            [self.pages addObject:controller];
        }else{
            GoodDetailDiscussController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"GoodDetailDiscussController"];
//            controller.dicDetail = self.dicDetail;
            controller.strGood_id = self.strGood_id;
            [self.pages addObject:controller];
        }
    }
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.viContainer.frame.size.width, self.viContainer.frame.size.height);
//    [self.pageViewController setDataSource:self];
//    [self.pageViewController setDelegate:self];
    [self.pageViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self addChildViewController:self.pageViewController];
    
    
    [self.viContainer addSubview:self.pageViewController.view];
    if ([self.pages count]>0) {
        [self pageControlValueChanged:self.intSelected];
    }
}
#pragma mark -
#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    return self.pages[--index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pages indexOfObject:viewController];
    
    if ((index == NSNotFound)||(index+1 >= [self.pages count])) {
        return nil;
    }
    
    return self.pages[++index];
}
#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)viewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed){
        return;
    }
    [self refreshSelectedButton:[self.pages indexOfObject:[viewController.viewControllers lastObject]]+100];
}

#pragma mark -
#pragma mark - Callback
- (void)pageControlValueChanged:(NSInteger)interger
{
    UIPageViewControllerNavigationDirection direction = interger > self.intSelected ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[self.pages[interger-100]]
                                      direction:direction
                                       animated:YES
                                     completion:NULL];
    [self refreshSelectedButton:interger];
}

- (void)refreshSelectedButton:(NSInteger)integer{
    self.intSelected = integer;
    CGRect rectLine = self.lblLine.frame;
    rectLine.origin.x = (integer-100)*60;
    [UIView animateWithDuration:0.27 animations:^{
        [self.lblLine setFrame:rectLine];
    }];
}

- (void)initCreateOrder{
    //    生成背景黑色
    self.viCreateBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.viCreateBack setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
    [self.viCreateBack setAlpha:0];
    //    背景黑色点击隐藏
    UIButton *btnHidden = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [btnHidden setBackgroundColor:[UIColor clearColor]];
    [btnHidden addTarget:self action:@selector(animationHiddenViCreateOrder) forControlEvents:UIControlEventTouchUpInside];
    [self.viCreateBack addSubview:btnHidden];
    
    //    生成放控件的view
    self.viCreateOrder = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT*2/3)];
    [self.viCreateOrder setBackgroundColor:[UIColor clearColor]];
    [self.viCreateBack addSubview:self.viCreateOrder];
    //    生成头部资料的view
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 95)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    UIView *viHeaderColor = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, CGRectGetHeight(viHeader.frame)-15)];
    [viHeaderColor setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 90, 90)];
    [imgHead setImagePathHead:self.dicDetail[@"goods"][@"icon"]];
    [imgHead.layer setCornerRadius:3.0];
    [imgHead setClipsToBounds:YES];
    self.lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgHead.frame)+15, 10, 200, 20)];
    [self.lblPrice setFont:[UIFont systemFontOfSize:16.0]];
    [self.lblPrice setTextColor:ColorFromRGB(255, 0, 0)];
    [self.lblPrice setTextNull:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:self.strGoodPrice])];
    NSString *strNum = self.dicDetail[@"goods"][@"goods_serial"];
    if (![NSString isNullString:strNum]) {
        UILabel *lblNum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgHead.frame)+15, CGRectGetMaxY(self.lblPrice.frame), 200, 20)];
        [lblNum setFont:[UIFont systemFontOfSize:13.0]];
        [lblNum setTextColor:ColorGary];
        [lblNum setTextNull:StringFormat(@"商品编号: %@",strNum)];
        [viHeaderColor addSubview:lblNum];
    }
    
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(viHeaderColor.frame)-40, 0, 40, 40)];
    [btnClose setImage:ImageNamed(@"img_close") forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(animationHiddenViCreateOrder) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *viLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(viHeaderColor.frame)-1, SCREEN_WIDTH, 0.5)];
    [viLine setBackgroundColor:ColorLine];
    
    [viHeader addSubview:viHeaderColor];
    [viHeader addSubview:imgHead];
    [viHeaderColor addSubview:self.lblPrice];
    [viHeaderColor addSubview:btnClose];
    [viHeaderColor addSubview:viLine];
    [self.viCreateOrder addSubview:viHeader];
    
    
    //    生成订单的按钮
    
    UIButton *btnOrder = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.viCreateOrder.frame)-40, CGRectGetWidth(self.viCreateOrder.frame), 40)];
    [btnOrder setBackgroundColor:ColorRed];
    [btnOrder.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [btnOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnOrder setTitleColor:ColorGary forState:UIControlStateHighlighted];
    [btnOrder setTitle:@"确定" forState:UIControlStateNormal];
    [btnOrder addTarget:self action:@selector(clickButtonCreateOrder:) forControlEvents:UIControlEventTouchUpInside];
    [self.viCreateOrder addSubview:btnOrder];
    //    生成显示类型的tabView
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    [layout setHeaderReferenceSize:CGSizeMake(320, 30)];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(0.f, 0, 0.f, 0);
    
    self.collectionSelectType = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viHeader.frame), CGRectGetWidth(self.viCreateOrder.frame), CGRectGetHeight(self.viCreateOrder.frame)-CGRectGetMaxY(viHeader.frame)-CGRectGetHeight(btnOrder.frame)) collectionViewLayout:layout];
    [self.collectionSelectType setBackgroundColor:[UIColor whiteColor]];
    self.collectionSelectType.delegate = self;
    self.collectionSelectType.dataSource =self;
    [self.viCreateOrder addSubview:self.collectionSelectType];
    
    [self.collectionSelectType registerClass:[CLCellGoodProperty class] forCellWithReuseIdentifier:@"CLCellGoodProperty"];
    [self.collectionSelectType registerClass:[CLCellGoodNum class] forCellWithReuseIdentifier:@"CLCellGoodNum"];
    [self.collectionSelectType registerClass:[ReusableViewProperty class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableViewProperty"];
    [self.view.window addSubview:self.viCreateBack];
    [self animationShowViCreateOrder];
}
- (void)animationShowViCreateOrder{
    CGRect rectOrder = self.viCreateOrder.frame;
    rectOrder.origin.y = SCREEN_HEIGHT-CGRectGetHeight(self.viCreateOrder.frame);
    UIViewController *controller = self.view.window.rootViewController;
    [UIView animateWithDuration:0.55 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [self.viCreateBack setAlpha:1];
        [self.viCreateOrder setFrame:rectOrder];
    }];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        controller.view.layer.transform = [self getFirstTransform];
    }completion:^(BOOL finished){
        [UIView animateWithDuration:0.25 animations:^{
        }completion:^(BOOL finished){
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            controller.view.layer.transform = [self getSecondTransform];
        }];
    }];
}
- (void)animationHiddenViCreateOrder{
    CGRect rectOrder = self.viCreateOrder.frame;
    rectOrder.origin.y = SCREEN_HEIGHT;
    UIViewController *controller = self.view.window.rootViewController;
    [UIView animateWithDuration:0.5 animations:^{
        [self.viCreateBack setAlpha:0];
        [self.viCreateOrder setFrame:rectOrder];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    } completion:^(BOOL finished){
        [self.viCreateBack removeFromSuperview];
    }];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        controller.view.layer.transform = [self getFirstTransform];
    }completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^{
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];

            controller.view.layer.transform = CATransform3DIdentity;
        }completion:^(BOOL finished){
        }];
    }];
}
- (CATransform3D)getFirstTransform{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -900.0;
    transform = CATransform3DScale(transform, 0.95, 0.95, 1);
    transform = CATransform3DRotate(transform, 15.0*M_PI/180.0, 1, 0, 0);
    transform = CATransform3DTranslate(transform, 0, 0, -100.0);
    return transform;
}
- (CATransform3D)getSecondTransform{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = [self getFirstTransform].m34;
    transform = CATransform3DTranslate(transform, 0, self.view.frame.size.height * -0.08, 0);
    transform = CATransform3DScale(transform, 0.8, 0.8, 1.0);
    return transform;
}
#pragma mark--  选择了属性后跳到订单详情页面
- (void)clickButtonCreateOrder:(UIButton *)sender{
    if (![self isSelectedAll]) {
        [SVProgressHUD showErrorWithStatus:@"请选择商品属性"];
        return;
    }
    if (self.disposableGoodNum) {
        [SVProgressHUD showErrorWithStatus:@"正在请求商品价格,请稍后..."];
        return;
    }
    if ([self.strGoodNum intValue]<self.intBuyNum) {
        [SVProgressHUD showErrorWithStatus:@"库存不足"];
        return;
    }
    [self animationHiddenViCreateOrder];
    if ([[PersonalInfo sharedInstance] isLogined]) {
        
        if (self.goodCartOrOrder == GoodCart) {
            [self requestAddCart];
            [self addCartHistory];
            return;
        }
        
        NSString *strGoodsspecpropertyId = [self fetchStringGoodsspecpropertyValueAndName];
        D_NSLog(@"您购买的商品为%@",strGoodsspecpropertyId);
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MyOrder" bundle:nil];
        OrderesComfilmController *controller=[storyboard instantiateViewControllerWithIdentifier:@"OrderesComfilmController"];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:[NSString stringStandard:self.dicDetail[@"isPackageMail"]] forKey:@"isPackageMail"];
        [dictionary setObject:[NSString stringStandard:self.dicDetail[@"goods"][@"ems_trans_fee"]] forKey:@"ems_trans_fee"];
        [dictionary setObject:[NSString stringStandard:self.dicDetail[@"goods"][@"express_trans_fee"]] forKey:@"express_trans_fee"];
        [dictionary setObject:[NSString stringStandard:self.dicDetail[@"goods"][@"mail_trans_fee"]] forKey:@"mail_trans_fee"];
        
        
        NSMutableDictionary *dicCart = [NSMutableDictionary dictionary];
        [dicCart setObject:self.strGoodPrice forKey:@"price"];
        [dicCart setObject:self.dicDetail[@"goods"][@"gift_d_coins"] forKey:@"gift_d_coins"];
        [dicCart setObject:TransformNSInteger(self.intBuyNum) forKey:@"count"];
        [dicCart setObject:[self fetchStringGoodsspecpropertyValueAndName] forKey:@"spec_info"];
        [dicCart setObject:[self fetchStringGoodsspecpropertyId] forKey:@"attribute"];
        [dicCart setObject:self.dicDetail[@"goods"][@"goods_id"] forKey:@"goods_id"];
        [dicCart setObject:self.dicDetail[@"goods"][@"icon"] forKey:@"path"];
        [dicCart setObject:self.dicDetail[@"goods"][@"goods_name"] forKey:@"goods_name"];
        [dicCart setObject:self.dicDetail[@"goods"][@"good_area"] forKey:@"good_area"];
        
        [dictionary setObject:[NSArray arrayWithObject:dicCart] forKey:@"goodsCart"];
        NSMutableDictionary *dicStore = [NSMutableDictionary dictionary];
        [dicStore setObject:self.dicDetail[@"goods"][@"store_name"] forKey:@"store_name"];
        
        double doublePrice = [self.dicDetail[@"goods"][@"store_price"] doubleValue]*self.intBuyNum;
        [dicStore setObject:StringFormat(@"%.2f",doublePrice) forKey:@"total_price"];
        [dictionary setObject:dicStore forKey:@"storeCart"];
        
        controller.dicFromDetial = dictionary;
        controller.outLine = self.dicDetail[@"outline"];
        //        controller.intBuyNum = self.intBuyNum;
        //        controller.strGoodPrice = self.strGoodPrice;
        //        controller.strAttribute = [self fetchStringGoodsspecpropertyId];
        //        controller.strAttributeName = [self fetchStringGoodsspecpropertyValueAndName];
        //        controller.strGood_id = self.strGood_id;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [self pushLoginController];
    }
}
- (void)requestAddCart{
    
    [SVProgressHUD showWithStatus:@"正在加入购物车..." maskType:SVProgressHUDMaskTypeBlack];
    __weak GoodDetialAllController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestFourZeroAddCartGoods_id:self.strGood_id andcount:TransformNSInteger(self.intBuyNum) andsotre_id:self.dicDetail[@"goods"][@"goods_store_id"] andproperty:[self fetchStringGoodsspecpropertyId] andspec_info:[self fetchStringGoodsspecpropertyValueAndName] andUser_id:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId] subscribeNext:^(NSDictionary* dictionary) {
        if ([dictionary[@"code"] intValue]==1) {
            [SVProgressHUD showSuccessWithStatus:@"加入购物车成功"];
        }else{
            [SVProgressHUD showErrorWithStatus:dictionary[@"msg"]];
        }
    }error:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        myself.disposable = nil;
    }completed:^{
        myself.disposable = nil;
    }];
}
- (void)addCartHistory{
    
    NSMutableDictionary *dicHistory = [NSMutableDictionary dictionaryWithDictionary:self.dicDetail];
    [dicHistory setObject:TransformNSInteger(self.intBuyNum) forKey:@"historyNum"];
    [dicHistory setObject:self.strGoodPrice forKey:@"historyPrice"];
    [dicHistory setObject:[self fetchStringGoodsspecpropertyId] forKey:@"historyAttribute"];
    [dicHistory setObject:[self fetchStringGoodsspecpropertyValueAndName] forKey:@"historyAttributeName"];
    [dicHistory setObject:self.strGood_id forKey:@"historyGood_id"];
    [[JJDBHelper sharedInstance] saveShopCart:self.dicDetail andIntBuyNum:TransformNSInteger(self.intBuyNum) andhistoryAttribute:[self fetchStringGoodsspecpropertyId] andhistoryAttributeName:[self fetchStringGoodsspecpropertyValueAndName] andhistoryGood_id:self.strGood_id andhistoryPrice:self.strGoodPrice];
}
#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if (section<self.arrSelectType.count){
        NSArray *arrClasss = [NSArray arrayWithArray:self.arrSelectType[section][@"items"]];
        return arrClasss.count;
    }else{
        return 1;
    }
    
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.arrSelectType.count+1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section<self.arrSelectType.count) {
        static NSString *identifier = @"CLCellGoodProperty";
        CLCellGoodProperty *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        NSArray *arrClasss = [NSArray arrayWithArray:self.arrSelectType[indexPath.section][@"items"]];
        [cell populateData:arrClasss[indexPath.row]];
        return cell;
    }
    static NSString *identifier = @"CLCellGoodNum";
    CLCellGoodNum *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell.lblLeave setTextNull:StringFormat(@"库存%@",[NSString stringStandardZero:self.strGoodNum])];
    [cell.btnAdd handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if ([self.strGoodNum intValue]>self.intBuyNum) {
            self.intBuyNum++;
            [self.collectionSelectType reloadData];
        }
    }];
    [cell.btnReduce handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (self.intBuyNum>1) {
            self.intBuyNum--;
            [self.collectionSelectType reloadData];
        }
    }];
    [cell.lblNum setTextNull:StringFormat(@"%d",self.intBuyNum)];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    
    UICollectionReusableView *reusableview = nil;
    if (indexPath.section<self.arrSelectType.count) {
        if (kind == UICollectionElementKindSectionHeader){
            
            ReusableViewProperty *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableViewProperty" forIndexPath:indexPath];
            [headerView setBackgroundColor:[UIColor whiteColor]];
            UILabel *lblHead = (UILabel *)[headerView viewWithTag:100];
            UILabel *lblLine = (UILabel *)[headerView viewWithTag:101];
            [lblLine removeFromSuperview];
            [lblHead removeFromSuperview];
            lblHead = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(headerView.frame), 20)];
            [lblHead setFont:[UIFont systemFontOfSize:15]];
            [lblHead setTextColor:ColorGary];
            [lblHead setTag:100];
            [lblHead setText:TransformString(self.arrSelectType[indexPath.section][@"name"])];
            [headerView addSubview:lblHead];
            reusableview = headerView;
            
        }
    }else{
        if (kind == UICollectionElementKindSectionHeader){
            ReusableViewProperty *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableViewProperty" forIndexPath:indexPath];
            [headerView setBackgroundColor:[UIColor whiteColor]];
            UILabel *lblHead = (UILabel *)[headerView viewWithTag:100];
            UILabel *lblLine = (UILabel *)[headerView viewWithTag:101];
            [lblLine removeFromSuperview];
            [lblHead removeFromSuperview];
            lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(headerView.frame), 0.5)];
            [lblLine setFont:[UIFont systemFontOfSize:15]];
            [lblLine setBackgroundColor:ColorLine];
            [lblLine setTag:101];
            [headerView addSubview:lblLine];
            reusableview = headerView;
        }
    }
    return reusableview;
    
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if (section<self.arrSelectType.count) {
        return CGSizeMake(SCREEN_WIDTH, 30);
    }else{
        return CGSizeMake(SCREEN_WIDTH, 10);
    }
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.arrSelectType.count) {
        CGFloat fWithd = 60;
        return CGSizeMake(fWithd,40);
    }else{
        return CGSizeMake(SCREEN_WIDTH,40);
    }
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 10, 10, 10);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self didSelectedItemAtIndexPath:indexPath];
}
- (void)didSelectedItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<self.arrSelectType.count) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.arrSelectType[indexPath.section][@"items"]];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int i = 0; i<array.count; i++) {
                NSMutableDictionary *dictinary = [NSMutableDictionary dictionaryWithDictionary:array[i]];
                BOOL select = [dictinary[@"select"] boolValue];
                
                if (i == indexPath.row) {
                    //                当以前未被选中时置1否则不管；
                    if (!select) {
                        [dictinary setObject:@"1" forKey:@"select"];
                        [self isSelectedAll];
                    }else{
                        return;
                    }
                }else{
                    //                当不等于选中的row全部置0
                    [dictinary setObject:@"0" forKey:@"select"];
                    [self isSelectedAll];
                }
                [array replaceObjectAtIndex:i withObject:dictinary];
            }
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:array forKey:@"items"];
        [dic setObject:self.arrSelectType[indexPath.section][@"name"] forKey:@"name"];
        [self.arrSelectType replaceObjectAtIndex:indexPath.section withObject:dic];
        [self.collectionSelectType reloadData];
        [self requestNum];
    }
}
- (BOOL)isSelectedAll{
    BOOL selectedAll = YES;
    for (int i = 0; i<self.arrSelectType.count; i++) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.arrSelectType[i][@"items"]];
        if ([array isKindOfClass:[NSArray class]]) {
            BOOL selectSection = NO;;
            for (int j = 0; j<array.count; j++) {
                NSMutableDictionary *dictinary = [NSMutableDictionary dictionaryWithDictionary:array[j]];
                if ([dictinary[@"select"] boolValue]) {
                    selectSection = YES;
                }
            }
            if (!selectSection) {
                return NO;
            }
        }
    }
    return selectedAll;
}
- (void)requestNum{
    if ([self isSelectedAll] && self.arrSelectType.count>0) {
        NSString *strGoodsspecpropertyId = [self fetchStringGoodsspecpropertyId];
        D_NSLog(@"已全部选择完毕，可以请求库存%@",strGoodsspecpropertyId);
        __weak GoodDetialAllController *myself = self;
        [myself.disposableGoodNum dispose];
        myself.disposableGoodNum = [[[JJHttpClient new] requestShopGoodGoodNumGoodsspecpropertyId:strGoodsspecpropertyId andGoodsId:[NSString stringStandard:self.strGood_id]] subscribeNext:^(NSDictionary* dictionary) {
            D_NSLog(@"msg is %@",dictionary[@"msg"]);
            myself.strGoodPrice = dictionary[@"store_price"];
            myself.strGoodNum = dictionary[@"goods_inventory"];
            [myself.lblPrice setTextNull:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:myself.strGoodPrice])];
            [myself.collectionSelectType reloadData];
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
- (NSString *)fetchStringGoodsspecpropertyId{
    NSString *strAttribut = @"";
    for (int i = 0; i<self.arrSelectType.count; i++) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.arrSelectType[i][@"items"]];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int j = 0; j<array.count; j++) {
                NSMutableDictionary *dictinary = [NSMutableDictionary dictionaryWithDictionary:array[j]];
                if ([dictinary[@"select"] boolValue]) {
                    strAttribut = StringFormat(@"%@%@_",strAttribut,dictinary[@"goodsspecpropertyId"]);
                }
            }
        }
    }
    return strAttribut;
}
- (NSString *)fetchStringGoodsspecpropertyValueAndName{
    NSString *strAttribut = @"";
    for (int i = 0; i<self.arrSelectType.count; i++) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.arrSelectType[i][@"items"]];
        NSString *strName = self.arrSelectType[i][@"name"];
        if ([array isKindOfClass:[NSArray class]]) {
            for (int j = 0; j<array.count; j++) {
                NSMutableDictionary *dictinary = [NSMutableDictionary dictionaryWithDictionary:array[j]];
                if ([dictinary[@"select"] boolValue]) {
                    if (![NSString isNullString:strAttribut]) {
                        strAttribut = StringFormat(@"%@ ",strAttribut);
                    }
                    strAttribut = StringFormat(@"%@%@:%@",strAttribut,strName,dictinary[@"value"]);
                }
            }
        }
    }
    return strAttribut;
}
- (IBAction)clickButtonShare:(UIButton *)sender {
    
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
    GoodShareController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodShareController"];
    controller.strWebUrl = self.dicDetail[@"goods"][@"screen_url"];
//    controller.strWebUrl = @"www.baidu.com";
    [self.navigationController pushViewController:controller animated:YES];
    
    
//    NSString *strShareUrl = self.dicDetail[@"shareGoodsUrl"];
//    if ([NSString isNullString:strShareUrl]) {
//        return;
//    }
//    NSArray* imageArray = @[self.dicDetail[@"goods"][@"icon"]];
////        （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//    if (imageArray) {
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:self.dicDetail[@"goods"][@"goods_name"]
//                                         images:imageArray
//                                            url:[NSURL URLWithString:strShareUrl]
//                                          title:@"非得购商城"
//                                           type:SSDKContentTypeAuto];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil customItems:nil shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//            switch (state) {
//                case SSDKResponseStateSuccess:
//                {
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                        message:nil
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"确定"
//                                                              otherButtonTitles:nil];
//                    [alertView show];
//                    break;
//                }
//                case SSDKResponseStateFail:
//                {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                    message:[NSString stringWithFormat:@"%@",error]
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"OK"
//                                                          otherButtonTitles:nil, nil];
//                    [alert show];
//                    break;
//                }
//                default:
//                    break;
//            }
//        }];
//    }
}
- (IBAction)clickButtonLianximaijia:(UIButton *)sender {
    NSString *strPhone = self.dicDetail[@"goods"][@"store_telephone"];
    if ([NSString isNullString:strPhone]) {
        [SVProgressHUD showErrorWithStatus:@"该商家未填写电话"];
        return ;
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",strPhone];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

- (IBAction)clickButtonDianpu:(UIButton *)sender {
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
    GoodOtherListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodOtherListController"];
    controller.strGoods_store_id = self.dicDetail[@"goods"][@"goods_store_id"];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)clickButtonGuanzhu:(UIButton *)sender {
    [sender setSelected:!sender.selected];
}
- (IBAction)clickButtonGouwuche:(UIButton *)sender {
    self.goodCartOrOrder = GoodCart;
    [self initCreateOrder];
}
- (IBAction)clickButtonBuy:(UIButton *)sender {
    self.goodCartOrOrder = GoodOrder;
    [self initCreateOrder];
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
