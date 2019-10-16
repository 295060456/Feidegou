//
//  CellOrderConfilm.m
//  guanggaobao
//
//  Created by 谭自强 on 2018/4/25.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "CellOrderConfilm.h"
#import "CellOrderGiftNo.h"
#import "CellDistributionInfo.h"
#import "CellBilInfo.h"
#import "CellMsgForVendor.h"
#import "CellGoodMoney.h"
#import "CellCartHead.h"
@interface CellOrderConfilm()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) ModelOrderGoodList *model;
@property (assign, nonatomic) NSInteger row;
@end
@implementation CellOrderConfilm

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tabOrder setBackgroundColor:ColorBackground];
    [self.tabOrder setDelegate:self];
    [self.tabOrder setDataSource:self];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellCartHead" bundle:nil] forCellReuseIdentifier:@"CellCartHead"];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellOrderGiftNo" bundle:nil] forCellReuseIdentifier:@"CellOrderGiftNo"];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellDistributionInfo" bundle:nil] forCellReuseIdentifier:@"CellDistributionInfo"];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellBilInfo" bundle:nil] forCellReuseIdentifier:@"CellBilInfo"];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellMsgForVendor" bundle:nil] forCellReuseIdentifier:@"CellMsgForVendor"];
    [self.tabOrder registerNib:[UINib nibWithNibName:@"CellGoodMoney" bundle:nil] forCellReuseIdentifier:@"CellGoodMoney"];
    // Initialization code
}
- (void)populateData:(ModelOrderGoodList *)model andRow:(NSInteger)row{
    self.model = model;
    self.row = row;
    [self.tabOrder reloadData];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        if (section == 0) {
            return 1;
        }
        if (section == 1) {
            return self.model.goodsCart.count;
        }
        if (section == 2) {
            return 2;
        }
        if (section == 3) {
            return 1;
        }
        if (section == 4) {
            return 1;
        }
        return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 40.0f;
    }
    
    if (indexPath.section == 1) {
        return 90.0f;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 75.0f;
        }
        if (indexPath.row == 1) {
            return 40.0f;
        }
    }
    if (indexPath.section == 3) {
        return 40;
    }
    if (indexPath.section == 4) {
        return 65;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CellCartHead *cell=[tableView dequeueReusableCellWithIdentifier:@"CellCartHead"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell.btnSelect setHidden:YES];
        cell.lblButtonWidth.constant = 10;
        
        NSString *strTitle = self.model.storeCart[@"store_name"];
        CGFloat fWidth = [NSString conculuteRightCGSizeOfString:strTitle andWidth:SCREEN_WIDTH-75 andFont:15.0].width;
        cell.layoutConstraintWidth.constant = fWidth;
        [cell.lblTitle setTextNull:strTitle];
        return cell;
    }
    if (indexPath.section == 1) {
        CellOrderGiftNo *cell=[tableView dequeueReusableCellWithIdentifier:@"CellOrderGiftNo"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell populateData:self.model.goodsCart[indexPath.row]];
        return cell;
    }
    if (indexPath.section == 2) {

        if (indexPath.row == 0) {
            CellDistributionInfo *cell=[tableView dequeueReusableCellWithIdentifier:@"CellDistributionInfo"];
                [cell.lblPinkage setTextNull:[self getSendIsPinkage]];
                [cell.lblSendWay setTextNull:[self getSendWay]];
            return cell;
        }
        if (indexPath.row == 1) {
            CellBilInfo *cell=[tableView dequeueReusableCellWithIdentifier:@"CellBilInfo"];
            if (self.model.billType == enum_billType_personal) {
                [cell.lblTip setTextNull:@"个人发票"];
            }else if (self.model.billType == enum_billType_company) {
                [cell.lblTip setTextNull:@"公司发票"];
            }else{
                [cell.lblTip setTextNull:@"不开发票"];
            }
            return cell;
        }
    }
    if (indexPath.section == 3) {
        CellMsgForVendor *cell=[tableView dequeueReusableCellWithIdentifier:@"CellMsgForVendor"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.row == 0) {
            cell.integerMost = 45;
            [cell.txtMsg setPlaceholder:@"选填:给商家留言(45字以内)"];
            [cell.txtMsg setText:self.model.strMsg];
            [cell.txtMsg addTarget:self action:@selector(textFiledEditChanged:) forControlEvents:UIControlEventEditingChanged];
        }else{
            cell.integerMost = 20;
            [cell.txtMsg setPlaceholder:@"选填:服务人账号"];
            [cell.txtMsg setText:self.model.strInviter];
            [cell.txtMsg addTarget:self action:@selector(textFiledEditChangedInviter:) forControlEvents:UIControlEventEditingChanged];
        }
        return cell;
    }
    CellGoodMoney *cell=[tableView dequeueReusableCellWithIdentifier:@"CellGoodMoney"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.lblMoneyUp setTextColor:ColorHeader];
    [cell.lblMoneyDown setTextColor:ColorHeader];
    [cell.lblLeftUp setTextColor:ColorBlack];
    [cell.lblLeftDown setTextColor:ColorBlack];
    [cell.lblLeftDown setTextNull:@"商品金额"];
    [cell.lblLeftUp setTextNull:@"+运费"];
    [cell.lblMoneyDown setTextNull:StringFormat(@"￥%@",[NSString stringStandardFloatTwo:self.model.storeCart[@"total_price"]])];
    [cell.lblMoneyUp setTextNull:StringFormat(@"+￥%@",[self getSendMoney])];
    return cell;
}
- (void)textFiledEditChanged:(UITextField *)textField{
    self.model.strMsg = textField.text;
    D_NSLog(@"text is %@",textField.text);
}
- (void)textFiledEditChangedInviter:(UITextField *)textField{
    self.model.strInviter = textField.text;
    D_NSLog(@"text is %@",textField.text);
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0||section == 2) {
//        return 0;
//    }else{
//        return 10;
//    }
//}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *viHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//    [viHeader setBackgroundColor:[UIColor clearColor]];
//    return viHeader;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self endEditing:YES];
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            if ([self.delegete respondsToSelector:@selector(didClickOnlyPeisongfangshiRow:)]) {
                [self.delegete didClickOnlyPeisongfangshiRow:self.row];
            }
        }else{
            if ([self.delegete respondsToSelector:@selector(didClickOnlyFapiaoRow:)]) {
                [self.delegete didClickOnlyFapiaoRow:self.row];
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self endEditing:YES];
}
- (NSString *)getSendIsPinkage{
    NSString *strSendWay = @"商家配送";
    //    为yes的时候表示要买家承担运费，为no时表示不用付邮费
    if (self.model.sendWay == enum_sendWay_no) {
        strSendWay = @"商家配送";
    }else{
        strSendWay = @"买家承担";
        NSString *strTip;
        if (self.model.sendWay == enum_sendWay_ems){
            strTip = @"EMS";
        }else if (self.model.sendWay == enum_sendWay_express){
            strTip = @"快递";
        }else{
            strTip = @"平邮";
        }
        strSendWay = StringFormat(@"%@(%@)",strSendWay,strTip);
    }
    return strSendWay;
}

- (NSString *)getSendWay{
    NSString *strSendWay = @"由商家选择合作快递为您配送";
    return strSendWay;
}

- (NSString *)getSendMoney{
    
    NSString *strSendWay = @"0.00";
    if (self.model.sendWay == enum_sendWay_no) {
        strSendWay = @"0.00";
    }else if (self.model.sendWay == enum_sendWay_ems){
        strSendWay = self.model.ems_trans_fee;
    }else if (self.model.sendWay == enum_sendWay_express){
        strSendWay = self.model.express_trans_fee;
    }else{
        strSendWay = self.model.mail_trans_fee;
    }
    return strSendWay;
}
@end
