//
//  GoodSecendTypeController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/9.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "GoodSecendTypeController.h"
#import "CLCellGoodType.h"
#import "CLCellGoodTypeNoPic.h"
#import "ReusableViewType.h"
#import "GoodsListController.h"
#import "JJHttpClient+ShopGood.h"
#import "GoodsListController.h"

@interface GoodSecendTypeController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *arrType;

@end

@implementation GoodSecendTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    [self.collectionView registerClass:[CLCellGoodType class] forCellWithReuseIdentifier:@"CLCellGoodType"];
    [self.collectionView registerClass:[CLCellGoodTypeNoPic class] forCellWithReuseIdentifier:@"CLCellGoodTypeNoPic"];
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    collectionViewLayout.headerReferenceSize = CGSizeMake(375, 20);
    [self requestData];
}

- (void)requestData{
    [self showException];
    @weakify(self)
    self.disposable = [[[JJHttpClient new] requestShopGoodTypeTwoGoodsType_id:TransformString(self.model.goodsType_id)]
                         subscribeNext:^(NSArray *array) {
        @strongify(self)
        self.arrType = [NSMutableArray arrayWithArray:array];
        [self.collectionView reloadData];
        [self hideException];
    }error:^(NSError *error) {
        @strongify(self)
        [self failedRequestException:enum_exception_timeout];
        self.disposable = nil;
    }completed:^{
        @strongify(self)
        self.disposable = nil;
    }];
}
#pragma mark --UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section{
    NSArray *arrClasss = [NSArray arrayWithArray:self.arrType[section][@"goodsClassList"]];
    D_NSLog(@"row is %ld",(long)arrClasss.count);
    return arrClasss.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    D_NSLog(@"section is %ld",(long)self.arrType.count);
    return self.arrType.count;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arrClasss = [NSArray arrayWithArray:self.arrType[indexPath.section][@"goodsClassList"]];
    if ([NSString isNullString:arrClasss[0][@"photoUrl"]]) {
        static NSString *identifier = @"CLCellGoodTypeNoPic";
        CLCellGoodTypeNoPic *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        [cell.lblTittle setTextNull:arrClasss[indexPath.row][@"className"]];
        return cell;
    }
    static NSString *identifier = @"CLCellGoodType";
    CLCellGoodType *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell populateData:arrClasss[indexPath.row]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        
        ReusableViewType *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                          withReuseIdentifier:@"ReusableViewType"
                                                                                 forIndexPath:indexPath];
        [headerView setBackgroundColor:ColorBackground];
        UILabel *lblHead = (UILabel *)[headerView viewWithTag:100];
        if (!lblHead) {
            lblHead = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                0,
                                                                CGRectGetWidth(headerView.frame),
                                                                CGRectGetHeight(headerView.frame))];
            [lblHead setFont:[UIFont systemFontOfSize:10]];
            [lblHead setTag:100];
        }
        [lblHead setText:TransformString(self.arrType[indexPath.section][@"name"])];
        [headerView addSubview:lblHead];
        reusableview = headerView;
        
    }return reusableview;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat fWithd = (SCREEN_WIDTH - 75 - 10 - 5) / 3;
    NSArray *arrClasss = [NSArray arrayWithArray:self.arrType[indexPath.section][@"goodsClassList"]];
    if ([NSString isNullString:arrClasss[0][@"photoUrl"]]) {
        return CGSizeMake(fWithd,50);
    }return CGSizeMake(fWithd,fWithd + 20);
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
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:StoryboardShopMain bundle:nil];
    GoodsListController *controller = [storyboard instantiateViewControllerWithIdentifier:@"GoodsListController"];
    controller.dicInfo = [NSDictionary dictionaryWithDictionary:self.arrType[indexPath.section][@"goodsClassList"][indexPath.row]];
    [self.navigationController pushViewController:controller
                                         animated:YES];
}


@end
