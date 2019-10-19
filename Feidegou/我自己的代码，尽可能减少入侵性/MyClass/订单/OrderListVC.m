//
//  OrderListVC.m
//  My_BaseProj
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 Corp. All rights reserved.
//

#import "OrderListVC.h"
#import "OrderTBVCell.h"
#import "OrderDetailVC.h"

@interface OrderListVC ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property(nonatomic,strong)UIView *viewer;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *filterBtn;

@property(nonatomic,strong)id requestParams;
@property(nonatomic,copy)DataBlock successBlock;
@property(nonatomic,assign)BOOL isPush;
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation OrderListVC

- (void)dealloc {
    NSLog(@"Running self.class = %@;NSStringFromSelector(_cmd) = '%@';__FUNCTION__ = %s", self.class, NSStringFromSelector(_cmd),__FUNCTION__);
}

+ (instancetype _Nonnull )pushFromVC:(UIViewController *_Nonnull)rootVC
                       requestParams:(nullable id)requestParams
                             success:(DataBlock _Nonnull )block
                            animated:(BOOL)animated{
    
    OrderListVC *vc = OrderListVC.new;
    vc.successBlock = block;
    vc.requestParams = requestParams;

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
    }return vc;
}

-(void)viewDidLoad{
    [super viewDidLoad];
//    self.navigationItem.title = @"订单管理";
    self.gk_navTitle = @"订单管理";
    [self.gk_navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : kBlackColor,
                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold"
                                                                                        size:17]}];
    self.gk_navRightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.filterBtn];
    self.gk_navItemRightSpace = SCALING_RATIO(30);
    
    self.tableView.alpha = 1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark —— 点击事件
-(void)filterBtnClickEvent:(UIButton *)sender{
    @weakify(self)
    UIEdgeInsets inset = [self.tableView contentInset];
    if (!sender.selected) {
        inset.top = SCALING_RATIO(50);
        [UIView animateWithDuration:1.f
                              delay:0.f
                            options:UIViewAnimationOptionTransitionCurlDown
                         animations:^{
            @strongify(self)
            self.viewer.alpha = 1;
        }
                         completion:^(BOOL finished) {
            
        }];
    }else{
        inset.top = SCALING_RATIO(0);
        [UIView animateWithDuration:1.f
                              delay:0.f
                            options:UIViewAnimationOptionTransitionCurlUp
                         animations:^{
            @strongify(self)
            self.viewer.alpha = 0;
        }
                         completion:^(BOOL finished) {
            
        }];
    }
    [self.tableView setContentInset:inset];
    //获取到需要跳转位置的行数
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0
                                                      inSection:0];
    //滚动到其相应的位置
    [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
            atScrollPosition:UITableViewScrollPositionBottom
                                    animated:YES];
    sender.selected = !sender.selected;
}

#pragma mark —— UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [OrderTBVCell cellHeightWithModel:nil];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath
                             animated:NO];
    [OrderDetailVC pushFromVC:self
                requestParams:nil
                      success:^(id data) {
        
    }
                     animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderTBVCell *cell = [OrderTBVCell cellWith:tableView];
    [cell richElementsInCellWithModel:nil];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

//给cell添加动画
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置Cell的动画效果为3D效果
    //设置x和y的初始值为0.1；
    cell.layer.transform = CATransform3DMakeScale(0.1,
                                                  0.1,
                                                  1);
    //x和y的最终值为1
    [UIView animateWithDuration:1
                     animations:^{
        cell.layer.transform = CATransform3DMakeScale(1,
                                                      1,
                                                      1);
    }];
}

#pragma mark —— lazyLoad
-(UIView *)viewer{
    if (!_viewer) {
        _viewer = UIView.new;
        _viewer.backgroundColor = kRedColor;
        [self.view addSubview:_viewer];
        [_viewer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.top.equalTo(self.gk_navigationBar.mas_bottom);
            make.height.mas_equalTo(SCALING_RATIO(50));
        }];
    }return _viewer;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                 style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;

        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }return _tableView;
}

-(UIButton *)filterBtn{
    if (!_filterBtn) {
        _filterBtn = UIButton.new;
        [_filterBtn setImage:kIMG(@"放大镜")
                    forState:UIControlStateNormal];
        [_filterBtn addTarget:self
                       action:@selector(filterBtnClickEvent:)
             forControlEvents:UIControlEventTouchUpInside];
    }return _filterBtn;
}



@end
