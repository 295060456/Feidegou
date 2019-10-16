//
//  AreaSelectController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/25.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "AreaSelectController.h"
#import "CellOneLabel.h"
#import "JJHttpClient+ShopGood.h"

@interface AreaSelectController ()

@property (weak, nonatomic) IBOutlet UITableView *tabArea;
@property (strong, nonatomic) NSMutableArray *arrArea;
@property (strong, nonatomic) NSMutableArray *arrAreaSelected;
@property (strong, nonatomic) NSString *strID;
@property (assign, nonatomic) int  intLevel;

@end

@implementation AreaSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    
    [self.tabArea registerNib:[UINib nibWithNibName:@"CellOneLabel" bundle:nil] forCellReuseIdentifier:@"CellOneLabel"];
    [self showException];
    self.arrAreaSelected = [NSMutableArray array];
    self.intLevel = 0;
    self.strID = @"";
    [self requestData];
}

- (void)requestData{
    if (self.disposable) {
        return;
    }
    [self.tabArea reloadData];
    [SVProgressHUD showWithStatus:@"正在请求数据..."];
    __weak AreaSelectController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodAreaListLevel:StringFormat(@"%d",self.intLevel) andID:self.strID] subscribeNext:^(NSArray* array) {
        myself.arrArea = [NSMutableArray arrayWithArray:array];
        if (array.count == 0) {
            [self selectedCompelete];
        }
        [myself.tabArea reloadData];
        [myself hideException];
    }error:^(NSError *error) {
        [myself failedRequestException:enum_exception_timeout];
        myself.disposable = nil;
        [SVProgressHUD dismiss];
    }completed:^{
        myself.disposable = nil;
        [SVProgressHUD dismiss];
    }];
    
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.arrAreaSelected.count;
    }
    return self.arrArea.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellOneLabel *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOneLabel"];
    ModelArea *model;
    UIView *viBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel *lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, SCREEN_WIDTH, 0.5)];
    if (indexPath.section == 0) {
        model = self.arrAreaSelected[indexPath.row];
        [viBack setBackgroundColor:ColorBackground];
        [lblLine setBackgroundColor:ColorHeader];
    }else{
        [lblLine setBackgroundColor:ColorLine];
        model = self.arrArea[indexPath.row];
        [viBack setBackgroundColor:[UIColor whiteColor]];
    }
    [viBack addSubview:lblLine];
    [cell.lblContent setTextNull:model.areaName];
    [cell setBackgroundView:viBack];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
        ModelArea *model = self.arrArea[indexPath.row];
        self.strID = model.ID;
        [self.arrAreaSelected addObject:model];
        self.arrArea = [NSMutableArray array];
        int intLevel = [model.level intValue];
        self.intLevel ++;
        if (intLevel<2) {
            [self requestData];
        }else{
            [self selectedCompelete];
        }
    }
}

- (void)selectedCompelete{
    NSString *strAreaName = @"";
    for (int i = 0; i<self.arrAreaSelected.count; i++) {
        ModelArea *model = self.arrAreaSelected[i];
        strAreaName = StringFormat(@"%@ %@",strAreaName,model.areaName);
    }
    NSLog(@"strAreaName is %@",strAreaName);
    NSLog(@"ModelArea id is %@",self.strID);
    self.model.area_id = self.strID;
    self.model.area = strAreaName;
    self.applyForVenderAttribute.strAreaID = self.strID;
    self.applyForVenderAttribute.strAreaName = strAreaName;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
