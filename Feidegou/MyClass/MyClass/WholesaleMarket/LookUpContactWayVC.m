//
//  LookUpContactWay.m
//  Feidegou
//
//  Created by Kite on 2019/11/26.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "LookUpContactWayVC.h"
#import "LookUpContactWayTBViewForHeader.h"
#import "LookUpContactWayVC+VM.h"

@interface LookUpContactWayTBVCell ()


@end

@interface LookUpContactWayVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;
@property(nonatomic,strong)NSMutableArray <NSString *>*titleMutArr;

@end

@implementation LookUpContactWayVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype)ComingFromVC:(UIViewController *)rootVC
                    withStyle:(ComingStyle)comingStyle
                requestParams:(nullable id)requestParams
                      success:(DataBlock)block
                     animated:(BOOL)animated{
    LookUpContactWayVC *vc = LookUpContactWayVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;
    switch (comingStyle) {
        case ComingStyle_PUSH:{
            if (rootVC.navigationController) {
                vc.isPush = YES;
                vc.isPresent = NO;
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
    ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    if ([model.grade_id intValue] == 3) {
        self.gk_navTitle = @"我的联系方式";
    }else if ([model.grade_id intValue] == 2){
        self.gk_navTitle = @"我上级的联系方式";
    }else{
        
    }
    self.gk_navLeftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.gk_navItemLeftSpace = SCALING_RATIO(15);
    self.gk_navItemRightSpace = SCALING_RATIO(30);
   
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
     self.tableView.alpha = 1;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
// 手动下拉刷新
-(void)pullToRefresh{
    NSLog(@"下拉刷新");
    [self netWorking];
    
}
//上拉加载更多
- (void)loadMoreRefresh{
    NSLog(@"上拉加载更多");
}
#pragma mark —— 点击事件
-(void)backBtnClickEvent:(UIButton *)sender{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    LookUpContactWayTBViewForHeader *viewForHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:ReuseIdentifier];
    if (!viewForHeader) {
        viewForHeader = [[LookUpContactWayTBViewForHeader alloc]initWithReuseIdentifier:ReuseIdentifier
                                                                          withData:@"请联系上级进货"];
        [viewForHeader headerViewWithModel:nil];
        @weakify(self)
        [viewForHeader actionBlock:^(id data) {
            @strongify(self)
            NSLog(@"联系");
            Toast(@"功能开发中,敬请期待...");
        }];
    }return viewForHeader;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return [LookUpContactWayTBViewForHeader headerViewHeightWithModel:nil];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [LookUpContactWayTBVCell cellHeightWithModel:Nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return self.titleMutArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LookUpContactWayTBVCell *cell = [LookUpContactWayTBVCell cellWith:tableView];
    if (self.contentTextMutArr.count) {
        [cell richElementsInCellWithModel:@{self.titleMutArr[indexPath.row]:[NSString ensureNonnullString:self.contentTextMutArr[indexPath.row] ReplaceStr:@"暂无"]}];
    }else{
        [cell richElementsInCellWithModel:@{self.titleMutArr[indexPath.row]:@"暂无"}];
    }return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark —— lazyLoad
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        _tableView.tableFooterView = UIView.new;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.mj_header = self.tableViewHeader;
        _tableView.mj_footer = self.tableViewFooter;
        _tableView.mj_footer.hidden = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithPatternImage:kIMG(@"builtin-wallpaper-0")];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }return _tableView;
}

-(NSMutableArray<NSString *> *)titleMutArr{
    if (!_titleMutArr) {
        _titleMutArr = NSMutableArray.array;
        [_titleMutArr addObject:@"手机号:"];
        [_titleMutArr addObject:@"QQ账号:"];
        [_titleMutArr addObject:@"微信账号:"];
    }return _titleMutArr;
}

-(NSMutableArray<NSString *> *)contentTextMutArr{
    if (!_contentTextMutArr) {
        _contentTextMutArr = NSMutableArray.array;
    }return _contentTextMutArr;
}

@end

@implementation LookUpContactWayTBVCell

+(instancetype)cellWith:(UITableView *)tableView{
    LookUpContactWayTBVCell *cell = (LookUpContactWayTBVCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    if (!cell) {
        cell = [[LookUpContactWayTBVCell alloc] initWithStyle:UITableViewCellStyleValue1
                                            reuseIdentifier:ReuseIdentifier
                                                     margin:SCALING_RATIO(5)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = kRedColor;
    }return cell;
}

+(CGFloat)cellHeightWithModel:(id _Nullable)model{
    return SCALING_RATIO(50);
}

- (void)richElementsInCellWithModel:(id _Nullable)model{
    if ([model isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)model;
        self.textLabel.text = dic.allKeys[0];
        self.detailTextLabel.text = dic.allValues[0];
    }
}



@end
