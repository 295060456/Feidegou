//
//  CellPHBTopThree.m
//  guanggaobao
//
//  Created by 谭自强 on 16/3/2.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellPHBTopThree.h"
@interface CellPHBTopThree()
@property (weak, nonatomic) IBOutlet UIImageView *imgRanking;
@property (weak, nonatomic) IBOutlet UILabel *lblRanking;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblLever;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintWidthName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintWidthNum;

@end
@implementation CellPHBTopThree

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lblRanking setTextColor:ColorRed];
    [self.lblMoney setTextColor:ColorGary];
    [self.lblLever.layer setCornerRadius:8.0];
    [self.lblLever setClipsToBounds:YES];
    [self.lblLever setBackgroundColor:ColorFromRGB(232, 180, 43)];
    // Initialization code
}



- (void)populateDataRanModel:(ModelRankList *)model andRow:(NSInteger)integer{
    
    if (integer == 0) {
        [self.imgRanking setImage:ImageNamed(@"img_phb_one")];
        [self.imgRanking setHidden:NO];
        [self.lblRanking setHidden:YES];
    }else if (integer == 1){
        [self.imgRanking setImage:ImageNamed(@"img_phb_two")];
        [self.imgRanking setHidden:NO];
        [self.lblRanking setHidden:YES];
    }else if (integer == 2){
        [self.imgRanking setImage:ImageNamed(@"img_phb_three")];
        [self.imgRanking setHidden:NO];
        [self.lblRanking setHidden:YES];
    }else{
        [self.imgRanking setHidden:YES];
        [self.lblRanking setHidden:NO];
        [self.lblRanking setText:StringFormat(@"%ld",(long)integer+1)];
    }
    [self.imgHead setImagePathHead:model.head];
    
    
    NSString *strTitle = model.userName;
    if ([NSString isNullString:strTitle]) {
        strTitle = @"暂无昵称";
    }
//    strTitle = @"带回家开始发货就的撒开户费卡萨丁交话费";
    [self.lblName setText:strTitle];
    [self.lblTime setText:[PublicFunction translateTimeHMS:model.lastLoginDate]];
    
    NSString *strMoney = StringFormat(@"%@元",[NSString stringStandardZero:model.commission]);
    [self.lblMoney setTextNull:strMoney];
    
    
    
    CGFloat fWidthNum = [NSString conculuteRightCGSizeOfString:strMoney andWidth:SCREEN_WIDTH andFont:12.0].width+2;
    self.layoutConstraintWidthNum.constant = fWidthNum;
    
    
    CGFloat fWidthName = [NSString conculuteRightCGSizeOfString:strTitle andWidth:SCREEN_WIDTH andFont:15.0].width+5;
    
    float fWidhtMax;
    if ([model.level intValue]==0) {
        fWidhtMax = SCREEN_WIDTH-105-fWidthNum;
        [self.lblLever setHidden:YES];
    }else{
        fWidhtMax = SCREEN_WIDTH-145-fWidthNum;
        [self.lblLever setHidden:NO];
    }
    if (fWidthName>fWidhtMax) {
        fWidthName = fWidhtMax;
    }
    self.layoutConstraintWidthName.constant = fWidthName;
    
    
    
    if ([model.level intValue] == 1) {
        [self.lblLever setText:@"合伙人A"];
    }else if ([model.level intValue] == 2) {
        [self.lblLever setText:@"合伙人B"];
    }else if ([model.level intValue] == 3) {
        [self.lblLever setText:@"合伙人C"];
    }else{
        [self.lblLever setText:@""];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
