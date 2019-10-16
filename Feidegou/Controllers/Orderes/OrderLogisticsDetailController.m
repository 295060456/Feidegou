//
//  OrderLogisticsDetailController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/19.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "OrderLogisticsDetailController.h"
#import "CellLogisticsFirst.h"
#import "CellOneLabel.h"
#import "CellLogisticsGood.h"
#import "JJHttpClient+ShopGood.h"

@interface OrderLogisticsDetailController ()

@property (weak, nonatomic) IBOutlet UITableView *tabLogistics;
@property (strong, nonatomic) NSDictionary *dicPost;
@property (strong, nonatomic) NSMutableArray *arrPost;

@end

@implementation OrderLogisticsDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    
    [self.tabLogistics setBackgroundColor:ColorBackground];
    [self.tabLogistics registerNib:[UINib nibWithNibName:@"CellLogisticsFirst" bundle:nil] forCellReuseIdentifier:@"CellLogisticsFirst"];
    [self.tabLogistics registerNib:[UINib nibWithNibName:@"CellOneLabel" bundle:nil] forCellReuseIdentifier:@"CellOneLabel"];
    [self.tabLogistics registerNib:[UINib nibWithNibName:@"CellLogisticsGood" bundle:nil] forCellReuseIdentifier:@"CellLogisticsGood"];
    [self requestData];
    [self showException];
}

- (void)requestData{
    __weak OrderLogisticsDetailController *myself = self;
    myself.disposable = [[[JJHttpClient new] requestShopGoodOrderDetailLogisticsInformationType:[NSString stringStandard:self.strCompanyCode]
                                                                                      andPostid:self.strGoodCode]
                         subscribeNext:^(NSDictionary* dictionary) {
        //        如果是字典，则表示有物流信息
        //        如果数组有数据，则表示有具体的物流信息
        self.arrPost = [NSMutableArray array];
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            self.dicPost = [NSDictionary dictionaryWithDictionary:dictionary];
            NSArray *array = dictionary[@"data"];
            if ([array isKindOfClass:[NSArray class]]&&array.count>0) {
                [self.arrPost addObjectsFromArray:array];
            }
        }else{
            self.dicPost = nil;
        }
        [self.tabLogistics reloadData];
    }error:^(NSError *error) {
        [myself failedRequestException:enum_exception_timeout];
        myself.disposable = nil;
    }completed:^{
        [self hideException];
        myself.disposable = nil;
    }];
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return self.arrPost.count;
    }return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100.0f;
    }else if (indexPath.section == 1){
        return 45.0f;
    }
    
    NSDictionary *dicInfo = self.arrPost[indexPath.row];
    if ([dicInfo isKindOfClass:[NSDictionary class]]) {
        NSString *strContent = dicInfo[@"context"];
        CGFloat fHeight = [NSString conculuteRightCGSizeOfString:strContent andWidth:SCREEN_WIDTH-55 andFont:15.0].height+40;
        return fHeight;
    }return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CellLogisticsGood *cell=[tableView dequeueReusableCellWithIdentifier:@"CellLogisticsGood"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.imgHead setImagePathListSquare:self.strPath];
        [cell.lblNum setText:StringFormat(@"%@件商品",[NSString stringStandardZero:self.strCount])];
        [cell.lblState setTextColor:ColorGreen];
        int intState = [self.dicPost[@"state"] intValue];
        // 0：在途，即货物处于运输过程中；
        // 1：揽件，货物已由快递公司揽收并且产生了第一条跟踪信息；
        // 2：疑难，货物寄送过程出了问题；
        // 3：签收，收件人已签收；
        // 4：退签，即货物由于用户拒签、超区等原因退回，而且发件人已经签收；
        // 5：派件，即快递正在进行同城派件；
        // 6：退回，货物正处于退回发件人的途中
        switch (intState) {
            case 1:
                [cell.lblState setText:@"正在揽件"];
                break;
            case 2:
                [cell.lblState setText:@"货物出问题"];
                break;
            case 3:
                [cell.lblState setText:@"已签收"];
                break;
            case 4:
                [cell.lblState setText:@"已签退"];
                break;
            case 5:
                [cell.lblState setText:@"派件中"];
                break;
            case 6:
                [cell.lblState setText:@"退回中"];
                break;
                
            default:
                [cell.lblState setText:@"正在路途中"];
                break;
        }
        [cell.lblCompy setText:StringFormat(@"承运公司: %@",self.strCompanyName)];
        [cell.lblPostNum setText:StringFormat(@"运单编号: %@",self.strGoodCode)];
        
        return cell;
    }
    if (indexPath.section == 1) {
        CellOneLabel *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOneLabel"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.fWidthPre = 10;
        [cell.lblContent setText:@"物流跟踪"];
        return cell;
    }
    CellLogisticsFirst *cell=[tableView dequeueReusableCellWithIdentifier:@"CellLogisticsFirst"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.fWidthPre = 45;
    NSDictionary *dicInfo = self.arrPost[indexPath.row];
    if ([dicInfo isKindOfClass:[NSDictionary class]]) {
        [cell.lblContent setTextNull:dicInfo[@"context"]];
        [cell.lblTime setTextNull:dicInfo[@"time"]];
    }
    if (_arrPost.count == 1) {
//        如果只有一条，则上下线都隐藏
        [cell.lblLineUp setHidden:YES];
        [cell.lblLineDown setHidden:YES];
        cell.layoutConstraintHeight.constant = 13;
        [cell.imgPoint setImage:ImageNamed(@"img_order_wlzt")];
        [cell.imgPoint setBackgroundColor:[UIColor clearColor]];
        [cell.lblContent setTextColor:ColorGreen];
        [cell.lblTime setTextColor:ColorGreen];
    }else{
        if (indexPath.row == 0) {
//            第一条，隐藏上面，显示下面的线
            [cell.lblLineUp setHidden:YES];
            [cell.lblLineDown setHidden:NO];
            cell.layoutConstraintHeight.constant = 13;
            [cell.imgPoint setImage:ImageNamed(@"img_order_wlzt")];
            [cell.imgPoint setBackgroundColor:[UIColor clearColor]];
            [cell.lblContent setTextColor:ColorGreen];
            [cell.lblTime setTextColor:ColorGreen];
        }else if (indexPath.row == self.arrPost.count-1){
//            最后一行显示上面，隐藏下面的线
            [cell.lblLineUp setHidden:NO];
            [cell.lblLineDown setHidden:YES];
            cell.layoutConstraintHeight.constant = 10;
            [cell.imgPoint setImage:nil];
            [cell.imgPoint setBackgroundColor:ColorGary];
            [cell.lblContent setTextColor:ColorGary];
            [cell.lblTime setTextColor:ColorGary];
        }else{
//            两个线都不隐藏
            [cell.lblLineUp setHidden:NO];
            [cell.lblLineDown setHidden:NO];
            cell.layoutConstraintHeight.constant = 10;
            [cell.imgPoint setImage:nil];
            [cell.imgPoint setBackgroundColor:ColorGary];
            [cell.lblContent setTextColor:ColorGary];
            [cell.lblTime setTextColor:ColorGary];
        }
        [cell.imgPoint.layer setCornerRadius:5.0];
        [cell.imgPoint setClipsToBounds:YES];
        [cell.lblLineUp setBackgroundColor:ColorGary];
        [cell.lblLineDown setBackgroundColor:ColorGary];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    return viHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil];
}


@end
