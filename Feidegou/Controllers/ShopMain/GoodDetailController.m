//
//  GoodDetailController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/13.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "GoodDetailController.h"
#import "MoreUp.h"
#import "JJHttpClient+ShopGood.h"
#import "CellPicture.h"
#import "CellHeaderMore.h"
#import "CellGoodEnterIn.h"
#import "UIButton+Joker.h"
#import "CellGoodDetai.h"
#import "CLCellGoodProperty.h"
#import "ReusableViewProperty.h"
#import "CLCellGoodNum.h"
#import "OrderesComfilmController.h"
#import "GoodDetialAllController.h"
#import "GoodOtherListController.h"

@interface GoodDetailController ()
<
UIScrollViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (weak, nonatomic) IBOutlet UITableView *tabDetail;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstrintHeight;
@property (weak, nonatomic) IBOutlet UIView *viUp;
@property (weak, nonatomic) IBOutlet UIWebView *webDetail;
@property (weak, nonatomic) IBOutlet UIView *viDown;
@property (strong, nonatomic) UIView *viCreateBack;
@property (strong, nonatomic) UIView *viCreateOrder;
@property (strong, nonatomic) UICollectionView *collectionSelectType;
@property (strong, nonatomic) NSMutableArray *arrSelectType;
@property (strong, nonatomic) NSString *strGoodNum;//库存
@property (copy, nonatomic) NSString *strGoodPrice;//价格
@property (strong, nonatomic) UILabel *lblPrice;
@property (assign, nonatomic) int intBuyNum;
@property (nonatomic,strong) RACDisposable *disposableGoodNum;
@end

@implementation GoodDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self.webDetail.scrollView setDelegate:self];
    [self.btnBuy setBackgroundColor:ColorRed];
    [self.tabDetail registerNib:[UINib nibWithNibName:@"CellPicture" bundle:nil] forCellReuseIdentifier:@"CellPicture"];
    [self.tabDetail registerNib:[UINib nibWithNibName:@"CellGoodDetai" bundle:nil] forCellReuseIdentifier:@"CellGoodDetai"];
    [self.tabDetail registerNib:[UINib nibWithNibName:@"CellHeaderMore" bundle:nil] forCellReuseIdentifier:@"CellHeaderMore"];
    [self.tabDetail registerNib:[UINib nibWithNibName:@"CellGoodEnterIn" bundle:nil] forCellReuseIdentifier:@"CellGoodEnterIn"];
    self.layoutConstrintHeight.constant = SCREEN_HEIGHT - 40 - 64;
    [self.view layoutIfNeeded];
    [self addViewOfMore];
}

- (void)addViewOfMore{
    CGFloat height = MAX(self.tabDetail.contentSize.height, self.tabDetail.bounds.size.height);
    
    D_NSLog(@"height is %f",height);
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MoreUp"
                                                 owner:self
                                               options:nil];
    UIView *viewMore = [nib firstObject];
    [viewMore setFrame:CGRectMake(0, height, SCREEN_WIDTH, 40)];
    [self.tabDetail addSubview:viewMore];
    [self addViewOfDetail];
}

- (void)addViewOfDetail{
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MoreDown"
                                                 owner:self
                                               options:nil];
    UIView *viewMore = [nib firstObject];
    [viewMore setBackgroundColor:[UIColor clearColor]];
    [viewMore setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    [self.webDetail setBackgroundColor:ColorBackground];
    [self.webDetail setScalesPageToFit:YES];
    [self.webDetail addSubview:viewMore];
    [self.webDetail sendSubviewToBack:viewMore];
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        if ([self.dicDetail[@"goods"][@"name_suffix"] isKindOfClass:[NSDictionary class]]) {
            return 1;
        }return 0;
    }return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return SCREEN_WIDTH;
    }else if (indexPath.section == 1) {
        return 95;
    }else if (indexPath.section == 2) {
        return 60;
    }return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CellPicture *cell=[tableView dequeueReusableCellWithIdentifier:@"CellPicture"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSArray *arrPic = self.dicDetail[@"photoUrl"];
        if ([arrPic isKindOfClass:[NSArray class]]) {
            [cell populateData:[NSArray arrayWithArray:self.dicDetail[@"photoUrl"]]];
        }
//        if ([self.dicDetail[@"goods"][@"name_suffix"] isKindOfClass:[NSDictionary class]]) {
//            cell.isHidden = YES;
//        }else{
//            cell.isHidden = NO;
//        }
        return cell;
    }
    if (indexPath.section == 1) {
        CellGoodDetai *cell=[tableView dequeueReusableCellWithIdentifier:@"CellGoodDetai"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateData:[NSDictionary dictionaryWithDictionary:self.dicDetail[@"goods"]]];
        return cell;
    }
    if (indexPath.section == 2) {
        CellHeaderMore *cell=[tableView dequeueReusableCellWithIdentifier:@"CellHeaderMore"];
        [cell.lblUp setTextNull:self.dicDetail[@"goods"][@"name_suffix"][@"msg1"]];
        NSArray *arrType = self.dicDetail[@"goods"][@"name_suffix"][@"markList"];
        if ([arrType isKindOfClass:[NSArray class]]) {
            NSMutableAttributedString * atrString = [[NSMutableAttributedString alloc] init];
            for (int i = 0; i<arrType.count; i++) {
                NSMutableAttributedString * atrMiddle = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"√%@ ",arrType[i])];
                [atrMiddle addAttributes:@{NSForegroundColorAttributeName:ColorRed} range:NSMakeRange(0, 1)];
                [atrString appendAttributedString:atrMiddle];
            }
            [cell.lblDown setAttributedText:atrString];
        }return cell;
    }
    CellGoodEnterIn *cell=[tableView dequeueReusableCellWithIdentifier:@"CellGoodEnterIn"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.btnCheck handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
        GoodOtherListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodOtherListController"];
        controller.strGoods_store_id = self.dicDetail[@"goods"][@"goods_store_id"];
        [self.navigationController pushViewController:controller animated:YES];
    }];
    [cell.btnPhone handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        NSString *strPhone = self.dicDetail[@"goods"][@"store_telephone"];
        if ([NSString isNullString:strPhone]) {
            [SVProgressHUD showErrorWithStatus:@"该商家未填写电话"];
            return ;
        }
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",strPhone];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }];return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 2) {
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate{
    if (scrollView == self.tabDetail) {
        
        float fOriginY = self.tabDetail.contentSize.height;
        if (self.tabDetail.contentSize.height<self.tabDetail.frame.size.height) {
            fOriginY = self.tabDetail.frame.size.height;
        }
        if (scrollView.contentOffset.y - (fOriginY - self.tabDetail.frame.size.height)> 40) {
            [self animaitonShowDetailMore];
        }
    }else{
        if (scrollView.contentOffset.y < -40) {
            [self animaitonHidenDetailMore];
        }
    }
}

- (void)animaitonShowDetailMore{
    [UIView animateWithDuration:0.27 animations:^{
        self.layoutConstraintTop.constant = -CGRectGetHeight(self.tabDetail.frame);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        D_NSLog(@"detail is %@",self.dicDetail[@"goods"][@"goods_details"]);
        [self.webDetail setScalesPageToFit:YES];
//        [self.webDetail loadHTMLString:self.dicDetail[@"goods"][@"goods_details"] baseURL:[[NSBundle mainBundle] bundleURL]];
        NSString *strUrl = self.dicDetail[@"goods"][@"detailURL"];
        if ([strUrl rangeOfString:@"http"].location == NSNotFound) {
            strUrl = [NSString stringWithFormat:@"http://%@",strUrl];
        }
        NSLog(@"url is %@",strUrl);
        self.view.backgroundColor=[UIColor whiteColor];
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:strUrl];
        //加载文件
        [self.webDetail loadRequest:[NSURLRequest requestWithURL:url]];
    }];
}

//- (void)webViewDidFinishLoad:(UIWebView *)theWebView
//{
//    CGSize contentSize = theWebView.scrollView.contentSize;
//    CGSize viewSize = self.view.bounds.size;
//    float rw = viewSize.width / contentSize.width;
//    theWebView.scrollView.minimumZoomScale = rw;
//    theWebView.scrollView.maximumZoomScale = rw;
//    theWebView.scrollView.zoomScale = rw;
//}

- (void)animaitonHidenDetailMore{
    [UIView animateWithDuration:0.27 animations:^{
        self.layoutConstraintTop.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)clickButtonBuy:(UIButton *)sender {
    [self initCreateOrder];
}

- (void)initCreateOrder{
//    生成背景黑色
    self.viCreateBack = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                 0,
                                                                 SCREEN_WIDTH,
                                                                 SCREEN_HEIGHT)];
    [self.viCreateBack setBackgroundColor:[UIColor colorWithWhite:0
                                                            alpha:0.4]];
    [self.viCreateBack setAlpha:0];
//    背景黑色点击隐藏
    UIButton *btnHidden = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     SCREEN_WIDTH,
                                                                     SCREEN_HEIGHT)];
    [btnHidden setBackgroundColor:[UIColor clearColor]];
    [btnHidden addTarget:self action:@selector(animationHiddenViCreateOrder)
        forControlEvents:UIControlEventTouchUpInside];
    [self.viCreateBack addSubview:btnHidden];
    
//    生成放控件的view
    self.viCreateOrder = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                  SCREEN_HEIGHT,
                                                                  SCREEN_WIDTH,
                                                                  SCREEN_HEIGHT*2/3)];
    [self.viCreateOrder setBackgroundColor:[UIColor clearColor]];
    [self.viCreateBack addSubview:self.viCreateOrder];
//    生成头部资料的view
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                SCREEN_WIDTH,
                                                                95)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    UIView *viHeaderColor = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     15,
                                                                     SCREEN_WIDTH,
                                                                     CGRectGetHeight(viHeader.frame)-15)];
    [viHeaderColor setBackgroundColor:[UIColor whiteColor]];
    UIImageView *imgHead = [[UIImageView alloc] initWithFrame:CGRectMake(10,
                                                                         0,
                                                                         90,
                                                                         90)];
    [imgHead setImagePathHead:self.dicDetail[@"goods"][@"icon"]];
    [imgHead.layer setCornerRadius:3.0];
    [imgHead setClipsToBounds:YES];
    self.lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgHead.frame)+15,
                                                              10,
                                                              200,
                                                              20)];
    [self.lblPrice setFont:[UIFont systemFontOfSize:16.0]];
    [self.lblPrice setTextColor:ColorFromRGB(255, 0, 0)];
    [self.lblPrice setTextNull:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:self.strGoodPrice])];
    NSString *strNum = self.dicDetail[@"goods"][@"goods_serial"];
    if (![NSString isNullString:strNum]) {
        UILabel *lblNum = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgHead.frame)+15,
                                                                    CGRectGetMaxY(self.lblPrice.frame),
                                                                    200,
                                                                    20)];
        [lblNum setFont:[UIFont systemFontOfSize:13.0]];
        [lblNum setTextColor:ColorGary];
        [lblNum setTextNull:StringFormat(@"商品编号: %@",strNum)];
        [viHeaderColor addSubview:lblNum];
    }
    
    
    UIButton *btnClose = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(viHeaderColor.frame)-40,
                                                                    0,
                                                                    40,
                                                                    40)];
    [btnClose setImage:ImageNamed(@"img_close") forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(animationHiddenViCreateOrder) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *viLine = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                              CGRectGetHeight(viHeaderColor.frame)-1,
                                                              SCREEN_WIDTH,
                                                              0.5)];
    [viLine setBackgroundColor:ColorLine];
    
    [viHeader addSubview:viHeaderColor];
    [viHeader addSubview:imgHead];
    [viHeaderColor addSubview:self.lblPrice];
    [viHeaderColor addSubview:btnClose];
    [viHeaderColor addSubview:viLine];
    [self.viCreateOrder addSubview:viHeader];
    
    
//    生成订单的按钮
    
    UIButton *btnOrder = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                    CGRectGetHeight(self.viCreateOrder.frame) - 40,
                                                                    CGRectGetWidth(self.viCreateOrder.frame),
                                                                    40)];
    [btnOrder setBackgroundColor:ColorRed];
    [btnOrder.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [btnOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnOrder setTitleColor:ColorGary forState:UIControlStateHighlighted];
    [btnOrder setTitle:@"立即下单" forState:UIControlStateNormal];
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
    [UIView animateWithDuration:0.27 animations:^{
        [self.viCreateBack setAlpha:1];
        [self.viCreateOrder setFrame:rectOrder];
    }];
}

- (void)animationHiddenViCreateOrder{
    CGRect rectOrder = self.viCreateOrder.frame;
    rectOrder.origin.y = SCREEN_HEIGHT;
    [UIView animateWithDuration:0.27 animations:^{
        [self.viCreateBack setAlpha:0];
        [self.viCreateOrder setFrame:rectOrder];
    } completion:^(BOOL finished){
        [self.viCreateBack removeFromSuperview];
    }];
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
        NSString *strGoodsspecpropertyId = [self fetchStringGoodsspecpropertyValueAndName];
        D_NSLog(@"您购买的商品为%@",strGoodsspecpropertyId);
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
        OrderesComfilmController *controller=[storyboard instantiateViewControllerWithIdentifier:@"OrderesComfilmController"];
        controller.dicDetail = [NSDictionary dictionaryWithDictionary:self.dicDetail];
        controller.intBuyNum = self.intBuyNum;
        controller.strGoodPrice = self.strGoodPrice;
        controller.strAttribute = [self fetchStringGoodsspecpropertyId];
        controller.strAttributeName = [self fetchStringGoodsspecpropertyValueAndName];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        [self pushLoginController];
    }
}
#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section{
    
    if (section<self.arrSelectType.count){
        NSArray *arrClasss = [NSArray arrayWithArray:self.arrSelectType[section][@"items"]];
        return arrClasss.count;
    }else{
        return 1;
    }
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.arrSelectType.count+1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableview = nil;
    if (indexPath.section<self.arrSelectType.count) {
        if (kind == UICollectionElementKindSectionHeader){
            
            ReusableViewProperty *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                  withReuseIdentifier:@"ReusableViewProperty"
                                                                                         forIndexPath:indexPath];
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
            ReusableViewProperty *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                  withReuseIdentifier:@"ReusableViewProperty"
                                                                                         forIndexPath:indexPath];
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

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section{
    if (section<self.arrSelectType.count) {
        return CGSizeMake(SCREEN_WIDTH, 30);
    }else{
        return CGSizeMake(SCREEN_WIDTH, 10);
    }
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.arrSelectType.count) {
        CGFloat fWithd = 60;
        return CGSizeMake(fWithd,40);
    }else{
        return CGSizeMake(SCREEN_WIDTH,40);
    }
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,
                            10,
                            10,
                            10);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
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
    }return selectedAll;
}

- (void)requestNum{
    if ([self isSelectedAll] && self.arrSelectType.count>0) {
        NSString *strGoodsspecpropertyId = [self fetchStringGoodsspecpropertyId];
        D_NSLog(@"已全部选择完毕，可以请求库存%@",strGoodsspecpropertyId);
        __weak GoodDetailController *myself = self;
        [myself.disposableGoodNum dispose];
        myself.disposableGoodNum = [[[JJHttpClient new] requestShopGoodGoodNumGoodsspecpropertyId:strGoodsspecpropertyId
                                                                                       andGoodsId:[NSString stringStandard:self.strGood_id]]
                                    subscribeNext:^(NSDictionary* dictionary) {
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
    }return strAttribut;
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
    }return strAttribut;
}


@end
