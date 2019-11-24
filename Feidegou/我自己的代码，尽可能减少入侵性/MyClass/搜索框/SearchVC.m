//
//  SearchVC.m
//  Feidegou
//
//  Created by Kite on 2019/11/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "SearchVC.h"
#import "SearchVC+VM.h"
#import "SearchBar.h"

#define rectOfStatusbar [[UIApplication sharedApplication] statusBarFrame].size.height//获取状态栏的高
#define rectOfNavigationbar self.navigationController.navigationBar.frame.size.height//获取导航栏的高

@interface SearchTBVCell ()

@end

@interface SearchVC ()
<
UITableViewDelegate
,UITableViewDataSource
>

@property(nonatomic,strong)SearchBar *searchBar;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,assign)BOOL isFirstComing;

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

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.searchBar.alpha = 1;
    self.tableView.alpha = 1;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark —— ,UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.dataMutArr.count;
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

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.searchBar.mas_bottom);
        }];
    }return _tableView;
}

-(SearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = SearchBar.new;
        [self.view addSubview:_searchBar];
        [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(rectOfStatusbar);
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(SCALING_RATIO(50));
        }];
        [self.view bringSubviewToFront:_searchBar];
        @weakify(self)
        __block UITextField *textField;
        [_searchBar actionBlock:^(id data,//textField 他的text是最终结果
                                  id data2,//searchBar
                                  id data3,//即将输入的字符
                                  id data4) {//调的方法
            @strongify(self)
            if ([data4 isEqualToString:@"CJTextFieldDeleteDelegate_cjTextFieldDeleteBackward"]) {//删除
                textField = (UITextField *)data;
                if ([textField.text isEqualToString:@""]) {
                    NSLog(@"没了");
                    //没有内容则不请求数据
                    [self.dataMutArr removeAllObjects];
                    [self.tableView reloadData];
                }else{
                    [self networking_type:textField.text];
                }
            }else{
                [self networking_type:textField.text];
            }
        }];
    }return _searchBar;
}

-(NSMutableArray<OrderListModel *> *)dataMutArr{
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
        cell.backgroundColor = RandomColor;
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return 50;
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    if ([model isKindOfClass:[OrderListModel class]]) {
        OrderListModel *orderListModel = (OrderListModel *)model;
        self.textLabel.text = orderListModel.ordercode;
    }
}

@end
