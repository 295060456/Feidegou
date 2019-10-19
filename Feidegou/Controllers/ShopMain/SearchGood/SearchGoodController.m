//
//  SearchGoodController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/8/9.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "SearchGoodController.h"
#import "JJHttpClient+ShopGood.h"
#import "CLCellGoodTypeHead.h"
#import "ReusableViewGoods.h"
#import "CellOnlyOneLbl.h"
#import "CellHistoryClear.h"
#import "GoodsListController.h"
#import "JJDBHelper+History.h"
#import "VendorShopTypeController.h"

@interface SearchGoodController ()
@property (strong, nonatomic) UIView *viHeader;
@property (strong, nonatomic) UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionHot;
@property (weak, nonatomic) IBOutlet UIView *viTip;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintCollectionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintTipHeight;
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (strong, nonatomic) NSMutableArray *arrHot;
@property (weak, nonatomic) IBOutlet BaseTableView *tabHistory;
@property (strong, nonatomic) NSMutableArray *arrHistory;

@end

@implementation SearchGoodController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.lblTip setTextColor:ColorGary];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    
    [self.collectionHot registerClass:[CLCellGoodTypeHead class] forCellWithReuseIdentifier:@"CLCellGoodTypeHead"];
    [self.tabHistory registerNib:[UINib nibWithNibName:@"CellOnlyOneLbl" bundle:nil] forCellReuseIdentifier:@"CellOnlyOneLbl"];
    [self.tabHistory registerNib:[UINib nibWithNibName:@"CellHistoryClear" bundle:nil] forCellReuseIdentifier:@"CellHistoryClear"];
    self.arrHot = [NSMutableArray arrayWithArray:[[JJDBHelper sharedInstance] fetchSearchHot]];
    [self initHeaderView];
}
- (void)initHeaderView{
    self.viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    [self.viHeader setBackgroundColor:ColorHeader];
    [self.view addSubview:self.viHeader];
    
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setFrame:CGRectMake(0, 20, 60, 44)];
    [btnBack.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [btnBack addTarget:self action:@selector(clickButtonBackInSearchView:) forControlEvents:UIControlEventTouchUpInside];
    [btnBack setImage:ImageNamed(@"img_back") forState:UIControlStateNormal];
    [self.viHeader addSubview:btnBack];
    
    
    UIButton *btnSearch = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSearch setFrame:CGRectMake(SCREEN_WIDTH-60, 20, 60, 44)];
    [btnSearch.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [btnSearch addTarget:self action:@selector(clickButtonSearch:) forControlEvents:UIControlEventTouchUpInside];
    [btnSearch setTitle:@"搜索" forState:UIControlStateNormal];
    [btnSearch setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnSearch setTitleColor:ColorGary forState:UIControlStateSelected];
    [self.viHeader addSubview:btnSearch];
    
    
    self.txtSearch = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnBack.frame), 27, CGRectGetMinX(btnSearch.frame)-CGRectGetMaxX(btnBack.frame), 30)];
    [self.txtSearch setClipsToBounds:YES];
    [self.txtSearch.layer setCornerRadius:3.0];
    
    [self.viTip setHidden:YES];
    self.layoutConstraintTipHeight.constant = 0;
    if (self.isVendor) {
        self.layoutConstraintCollectionHeight.constant = 0;
        [self.txtSearch setPlaceholder:@"搜索附近的吃喝玩乐"];
    }else{
        [self.txtSearch setPlaceholder:@"搜索商品名称"];
        self.layoutConstraintCollectionHeight.constant = 60;
        [self requestData];
    }
    [self.collectionHot setHidden:self.isVendor];
    
    
    [self.txtSearch setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.6]];
    [self.txtSearch setTextColor:[UIColor whiteColor]];
    [self.viHeader addSubview:self.txtSearch];
    
    
    UIImageView *imageLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, CGRectGetHeight(self.txtSearch.frame))];
    [imageLeft setImage:ImageNamed(@"img_search_bai")];
    [imageLeft setContentMode:UIViewContentModeCenter];
    [self.txtSearch setLeftView:imageLeft];
    [self.txtSearch setLeftViewMode:UITextFieldViewModeAlways];
}
- (void)clickButtonBackInSearchView:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)clickButtonSearch:(UIButton *)sender{
    D_NSLog(@"clickButtonSearch");
    [self pushControllerGoodList:self.txtSearch.text];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self reloadHistory];
}
- (void)reloadHistory{
    self.arrHistory = [NSMutableArray arrayWithArray:[[JJDBHelper sharedInstance] fetchSearchHistoryIsVendor:self.isVendor]];
    [self.tabHistory reloadData];
    [self.tabHistory checkNoData:self.arrHistory.count];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)requestData{
    if (self.arrHot.count == 0) {
        [self showException];
    }
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestShopGoodSearchGoodsName:@""] subscribeNext:^(NSDictionary* dictinary) {
        @strongify(self)
        NSString *strHotSearch = dictinary[@"hotSearch"];
        NSArray *array = [strHotSearch componentsSeparatedByString:@","];
        self.arrHot = [NSMutableArray arrayWithArray:array];
        [self.collectionHot reloadData];
        [[JJDBHelper sharedInstance] saveSearchHot:self.arrHistory];
        [self hideException];
    }error:^(NSError *error) {
        @strongify(self)
        self.disposable = nil;
        [self hideException];
        if (self.arrHot.count == 0) {
            self.layoutConstraintCollectionHeight.constant = 0;
            [self.viTip setHidden:YES];
            self.layoutConstraintTipHeight.constant = 0;
        }else{
            self.layoutConstraintCollectionHeight.constant = 40;
            [self.viTip setHidden:NO];
            self.layoutConstraintTipHeight.constant = 30;
        }
    }completed:^{
        @strongify(self)
        self.disposable = nil;
        if (self.arrHot.count == 0) {
            self.layoutConstraintCollectionHeight.constant = 0;
            [self.viTip setHidden:YES];
            self.layoutConstraintTipHeight.constant = 0;
        }else{
            self.layoutConstraintCollectionHeight.constant = 40;
            [self.viTip setHidden:NO];
            self.layoutConstraintTipHeight.constant = 30;
        }
    }];
}

#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section{
    return self.arrHot.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"CLCellGoodTypeHead";
    CLCellGoodTypeHead *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                         forIndexPath:indexPath];
    
    [cell.viLbel.layer setBorderColor:ColorGary.CGColor];
    [cell.viLbel.layer setBorderWidth:0.5];
    
    [cell.viLbel setBackgroundColor:[UIColor clearColor]];
    [cell.viBack setHidden:YES];
    [cell.lblLine setHidden:YES];
    [cell.lblContent setTextColor:ColorGary];
    [cell.lblContent setFont:[UIFont systemFontOfSize:13.0]];
    [cell.lblContent setTextNull:self.arrHot[indexPath.row]];
    return cell;
}
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//
//{
//
//    UICollectionReusableView *reusableview = nil;
//    if (kind == UICollectionElementKindSectionHeader){
//
//        ReusableViewGoods *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ReusableViewGoods" forIndexPath:indexPath];
//        [headerView setBackgroundColor:ColorBackground];
//
//
//        UIImageView *imageLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, CGRectGetHeight(headerView.frame))];
//        [imageLeft setImage:ImageNamed(@"img_search_bai")];
//        [imageLeft setContentMode:UIViewContentModeCenter];
//        [headerView addSubview:imageLeft];
//
//        UILabel *lblTip = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageLeft.frame), 0, 100, CGRectGetHeight(imageLeft.frame))];
//        [lblTip setFont:[UIFont systemFontOfSize:14.0]];
//        [lblTip setTextColor:ColorGary];
//        [lblTip setText:@"热门搜索"];
//        [headerView addSubview:lblTip];
//        reusableview = headerView;
//    }
//    return reusableview;
//
//
//
//}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *strContent = self.arrHot[indexPath.row];
    CGFloat fWidth = [NSString conculuteRightCGSizeOfString:strContent
                                                   andWidth:200
                                                    andFont:13.0].width+25;
    return CGSizeMake(fWidth,40);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0,
                            0,
                            0,
                            0);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    [self pushControllerGoodList:self.arrHot[indexPath.row]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.arrHistory.count==0) {
        return 0;
    }
    if (section == 1) {
        return self.arrHistory.count;
    }return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 60.0f;
    }return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        @weakify(self)
        CellHistoryClear *cell=[tableView dequeueReusableCellWithIdentifier:@"CellHistoryClear"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.btnClear handleControlEvent:UIControlEventTouchUpInside
                                withBlock:^{
            [JJAlertViewTwoButton.new showAlertView:self
                                           andTitle:nil
                                         andMessage:@"是否清空历史记录"
                                          andCancel:@"取消"
                                      andCanelIsRed:NO
                                      andOherButton:@"立即清空"
                                         andConfirm:^{
                @strongify(self)
                D_NSLog(@"点击了立即发布");
                [[JJDBHelper sharedInstance] saveSearchHistory:NSArray.array
                                                   andIsVendor:self.isVendor];
                [self reloadHistory];
            } andCancel:^{
                D_NSLog(@"点击了取消");
            }];
        }];
        return cell;
    }
    CellOnlyOneLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOnlyOneLbl"];
    if (indexPath.section == 0) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.lblContent setTextColor:ColorBlack];
        [cell.lblContent setText:@"历史记录"];
    }else{
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [cell.lblContent setTextColor:ColorGary];
        [cell.lblContent setTextNull:self.arrHistory[indexPath.row]];
    }return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view endEditing:YES];
    if (indexPath.section == 1) {
        [self pushControllerGoodList:self.arrHistory[indexPath.row]];
    }
}

- (void)pushControllerGoodList:(NSString *)strSearch{
    if ([NSString isNullString:strSearch]) {
        [SVProgressHUD showErrorWithStatus:@"搜索不能为空"];
        return;
    }
    BOOL isConttain = NO;
    for (int i = 0; i<self.arrHistory.count; i++) {
        if ([self.arrHistory[i] isEqualToString:strSearch]) {
            isConttain = YES;
            [self.arrHistory insertObject:strSearch atIndex:0];
            [self.arrHistory removeObjectAtIndex:i+1];
            
        }
    }
    if (!isConttain) {
        [self.arrHistory insertObject:strSearch atIndex:0];
    }
    [[JJDBHelper sharedInstance] saveSearchHistory:self.arrHistory
                                       andIsVendor:self.isVendor];
    [self.txtSearch setText:strSearch];
    if (self.isVendor) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardVendorDetail bundle:nil];
        VendorShopTypeController *controller = [storyboard instantiateViewControllerWithIdentifier:@"VendorShopTypeController"];
        controller.strSearch = strSearch;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain
                                                           bundle:nil];
        GoodsListController *controller=[storyboard instantiateViewControllerWithIdentifier:@"GoodsListController"];
        controller.strSearch = strSearch;
        [self.navigationController pushViewController:controller
                                             animated:YES];
    }
}


@end
