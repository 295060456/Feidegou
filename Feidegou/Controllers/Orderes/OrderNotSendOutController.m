//
//  OrderNotSendOutController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/16.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "OrderNotSendOutController.h"
#import "CellOrderVendorTitle.h"
#import "CellOrderGood.h"
#import "CellOrderOneLbl.h"
#import "CellOrderButtones.h"

@interface OrderNotSendOutController ()

@property (weak, nonatomic) IBOutlet UITableView *tabNotSendOut;
@property (strong, nonatomic) NSMutableArray *arrGoods;

@end

@implementation OrderNotSendOutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)locationControls{
    [self.tabNotSendOut setBackgroundColor:ColorBackground];
    [self.tabNotSendOut registerNib:[UINib nibWithNibName:@"CellOrderVendorTitle"
                                                   bundle:nil]
             forCellReuseIdentifier:@"CellOrderVendorTitle"];
    [self.tabNotSendOut registerNib:[UINib nibWithNibName:@"CellOrderGood"
                                                   bundle:nil]
             forCellReuseIdentifier:@"CellOrderGood"];
    [self.tabNotSendOut registerNib:[UINib nibWithNibName:@"CellOrderOneLbl"
                                                   bundle:nil]
             forCellReuseIdentifier:@"CellOrderOneLbl"];
    [self.tabNotSendOut registerNib:[UINib nibWithNibName:@"CellOrderButtones"
                                                   bundle:nil]
             forCellReuseIdentifier:@"CellOrderButtones"];
}

#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 40.0f;
    }else if (indexPath.row == 1){
        return 70.0f;
    }else if (indexPath.row == 2){
        return 40.0f;
    }else if (indexPath.row == 3){
        return 40.0f;
    }return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CellOrderVendorTitle *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderVendorTitle"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    if (indexPath.row == 1) {
        CellOrderGood *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderGood"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIView *viBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        [viBack setBackgroundColor:ColorFromRGB(246, 247, 248)];
        [cell setBackgroundView:viBack];
        return cell;
    }
    
    if (indexPath.row == 2) {
        CellOrderOneLbl *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderOneLbl"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    CellOrderButtones *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderButtones"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.btnOne.layer setBorderWidth:0.5];
    [cell.btnOne.layer setBorderColor:ColorLine.CGColor];
    [cell.btnOne setTitleColor:ColorBlack forState:UIControlStateNormal];
    [cell.btnTwo.layer setBorderWidth:0.5];
    [cell.btnTwo.layer setBorderColor:ColorRed.CGColor];
    [cell.btnTwo setTitleColor:ColorRed forState:UIControlStateNormal];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView
        viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    return viHeader;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
