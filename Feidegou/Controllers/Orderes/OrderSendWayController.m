//
//  OrderSendWayController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/21.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "OrderSendWayController.h"
#import "CellSendWay.h"
#import "UIButton+Joker.h"

@interface OrderSendWayController ()
@property (weak, nonatomic) IBOutlet UITableView *tabSendWay;
@property (weak, nonatomic) IBOutlet UIButton *btnConfilm;

@property (assign, nonatomic) enumSendWay sendWay;
@end

@implementation OrderSendWayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    [self.btnConfilm setBackgroundColor:ColorRed];
    [self.tabSendWay setBackgroundColor:ColorBackground];
    [self.tabSendWay registerNib:[UINib nibWithNibName:@"CellSendWay" bundle:nil] forCellReuseIdentifier:@"CellSendWay"];
    self.sendWay = self.model.sendWay;
}
#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 190.0f;
    }
    return 166.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellSendWay *cell=[tableView dequeueReusableCellWithIdentifier:@"CellSendWay"];
    [cell populataData:self.model.goodsCart];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    UIImage *imgSelected = ImageNamed(@"img_order_select");
    if (indexPath.section == 0) {
        [cell.lblTitle setText:@"支付方式"];
        [cell.lblTip setHidden:NO];
        
        [cell.viOne setHidden:NO];
        [cell.viTwo setHidden:YES];
        [cell.viThree setHidden:YES];
        if ([self.model.strPayway intValue]==1) {
            [cell.lblOne setText:@"线下支付"];
        }else{
            [cell.lblOne setText:@"在线支付"];
        }
        [cell.lblOne setTextColor:ColorRed];
        [cell.imgOne setImage:imgSelected];
        [cell.viOne.layer setBorderColor:ColorRed.CGColor];
    }
    if (indexPath.section == 1) {
        [cell.lblTitle setText:@"配送方式"];
        [cell.lblTip setTextNull:@""];
        [cell.lblTip setHidden:YES];
        if (self.sendWay == enum_sendWay_no) {
            [cell.viOne setHidden:NO];
            [cell.viTwo setHidden:YES];
            [cell.viThree setHidden:YES];
            
            [cell.lblOne setText:@"卖家承担"];
            [cell.lblOne setTextColor:ColorRed];
            [cell.imgOne setImage:imgSelected];
            [cell.viOne.layer setBorderColor:ColorRed.CGColor];
            
        }else{
            [cell.btnOne handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                [self refreshTabBySendWay:enum_sendWay_mail];
            }];
            [cell.btnTwo handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                [self refreshTabBySendWay:enum_sendWay_express];
            }];
            [cell.btnThree handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                [self refreshTabBySendWay:enum_sendWay_ems];
            }];
            [cell.viOne setHidden:NO];
            [cell.viTwo setHidden:NO];
            [cell.viThree setHidden:NO];
            
            [cell.lblOne setTextColor:ColorGary];
            [cell.imgOne setImage:nil];
            [cell.viOne.layer setBorderColor:ColorLine.CGColor];
            
            [cell.lblTwo setTextColor:ColorGary];
            [cell.imgTwo setImage:nil];
            [cell.viTwo.layer setBorderColor:ColorLine.CGColor];
            
            [cell.lblThree setTextColor:ColorGary];
            [cell.imgThree setImage:nil];
            [cell.viThree.layer setBorderColor:ColorLine.CGColor];
            
            [cell.lblOne setText:StringFormat(@"平邮%@元",self.model.mail_trans_fee)];
            [cell.lblTwo setText:StringFormat(@"快递%@元",self.model.express_trans_fee)];
            [cell.lblThree setText:StringFormat(@"EMS%@元",self.model.ems_trans_fee)];
            
            if (self.sendWay == enum_sendWay_mail) {
                [cell.lblOne setTextColor:ColorRed];
                [cell.imgOne setImage:imgSelected];
                [cell.viOne.layer setBorderColor:ColorRed.CGColor];
            }
            if (self.sendWay == enum_sendWay_express) {
                [cell.lblTwo setTextColor:ColorRed];
                [cell.imgTwo setImage:imgSelected];
                [cell.viTwo.layer setBorderColor:ColorRed.CGColor];
            }
            if (self.sendWay == enum_sendWay_ems) {
                [cell.lblThree setTextColor:ColorRed];
                [cell.imgThree setImage:imgSelected];
                [cell.lblThree.layer setBorderColor:ColorRed.CGColor];
            }
            
            
        }
        
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 10;
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [viHeader setBackgroundColor:[UIColor clearColor]];
    return viHeader;
}
- (void)refreshTabBySendWay:(enumSendWay)sendWay{
    self.sendWay = sendWay;
    [self.tabSendWay reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickButtonConfilm:(UIButton *)sender {
    if (self.sendWay != enum_sendWay_no) {
        self.model.sendWay = self.sendWay;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
