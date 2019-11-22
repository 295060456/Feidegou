//
//  SearchVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "SearchVC.h"
#import "AbuSearchView.h"
#import "AbuStcokModel.h"

@interface SearchTBVCell ()


@end

@interface SearchVC ()
<
AbuSearchViewDelegate
,UITableViewDelegate
,UITableViewDataSource
>

@property(nonatomic,strong)AbuSearchView *searchView;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataMutArr;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;
//@property(nonatomic,assign)BOOL isDelCell;

@end

@implementation SearchVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    SearchVC *vc = SearchVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    if ([requestParams isKindOfClass:[RCConversationModel class]]) {

    }
 
    switch (comingStyle) {
        case ComingStyle_PUSH:{
            if (rootVC.navigationController) {
                vc.isPush = YES;
                vc.isPresent = NO;
                vc.isFirstComing = YES;
                [rootVC.navigationController pushViewController:vc
                                                       animated:animated];
            }else{
                vc.isPush = NO;
                vc.isPresent = YES;
                [rootVC presentViewController:vc
                                     animated:animated
                                   completion:^{}];
            }
        }break;
        case ComingStyle_PRESENT:{
            vc.isPush = NO;
            vc.isPresent = YES;
            [rootVC presentViewController:vc
                                 animated:animated
                               completion:^{}];
        }break;
        default:
            NSLog(@"错误的推进方式");
            break;
    }return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchView.alpha = 1;
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark —— AbuSearchViewDelegate
- (void)searchView:(AbuSearchView *)searchView
   resultStcokList:(NSMutableArray *)stcokList{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (self.dataMutArr.count) {
            [self.dataMutArr removeAllObjects];
        }
        if (stcokList.count > 0) {
            [self.dataMutArr addObjectsFromArray:stcokList];
        }else{
            [self.dataMutArr addObjectsFromArray:stcokList];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

-(BOOL)searchBarShouldBeginEditing:(AbuSearchView *)searchBar{
//    NSLog(@"%s: Line-%d", __func__, __LINE__);
    return YES;
    
}
- (void)searchBarTextDidBeginEditing:(AbuSearchView *)searchBar{
//    NSLog(@"%s: Line-%d", __func__, __LINE__);
    
}
- (BOOL)searchBarShouldEndEditing:(AbuSearchView *)searchBar{
//    NSLog(@"%s: Line-%d", __func__, __LINE__);
    return YES;
}
- (void)searchBarTextDidEndEditing:(AbuSearchView *)searchBar{
//    NSLog(@"%s: Line-%d", __func__, __LINE__);
    
}
- (void)searchBar:(AbuSearchView *)searchBar textDidChange:(NSString *)searchText{
//    NSLog(@"%s: Line-%d", __func__, __LINE__);
    NSLog(@"%@",searchText);
    
}
- (BOOL)searchBar:(AbuSearchView *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    NSLog(@"%s: Line-%d", __func__, __LINE__);
    return YES;
    
}
- (void)searchBarSearchButtonClicked:(AbuSearchView *)searchBar{
//    NSLog(@"%s: Line-%d", __func__, __LINE__);
    
}
- (void)searchBarCancelButtonClicked:(AbuSearchView *)searchBar{
//    NSLog(@"%s: Line-%d", __func__, __LINE__);
    if (self.dataMutArr.count > 0) {
        [self.dataMutArr removeAllObjects];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
#pragma mark —— ,UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    if (self.dataMutArr.count > 0) {
        return self.dataMutArr.count > 50 ? 50 : self.dataMutArr.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchTBVCell *cell = [SearchTBVCell cellWith:tableView];
    [cell richElementsInCellWithModel:self.dataMutArr[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [SearchTBVCell cellHeightWithModel:self.dataMutArr[indexPath.row]];
}

- (AbuSearchView *)searchView{
    if (!_searchView) {
        _searchView = [[AbuSearchView alloc]initWithFrame:CGRectMake(0,
                                                                     SCALING_RATIO(3),
                                                                     SCREEN_WIDTH,
                                                                     SCALING_RATIO(40))];
        _searchView.delegate = self;
//        _searchView.backgroundColor = kRedColor;
        _searchView.placeholder = @"股票名称/代码/全拼";
        if (self.navigationController) {
            [self.gk_navigationBar addSubview:_searchView];
        }
    }return _searchView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }return _tableView;
}

- (NSMutableArray *)dataMutArr{
    if (!_dataMutArr) {
        _dataMutArr = NSMutableArray.array;
    }return _dataMutArr;
}

@end

@implementation SearchTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    SearchTBVCell *cell = (SearchTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[SearchTBVCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:ReuseIdentifier
                                             margin:SCALING_RATIO(0)];
        [UIView cornerCutToCircleWithView:cell.contentView
                          AndCornerRadius:5.f];
        [UIView colourToLayerOfView:cell.contentView
                         WithColour:KGreenColor
                     AndBorderWidth:.1f];
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return 50;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    if ([model isKindOfClass:[AbuStcokModel class]]) {
        AbuStcokModel *abuStcokModel = (AbuStcokModel *)model;
        self.textLabel.text = abuStcokModel.cnName;
    }
}

@end
