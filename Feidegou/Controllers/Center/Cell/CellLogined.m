//
//  CellLogined.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/8.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellLogined.h"

@implementation CellLogined

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.imgBack setImage:[PublicFunction getImageWithRect:self.imgBack.frame
                                              andColorBegin:ColorFromHexRGB(0xf22a2a)
                                                andColorEnd:ColorFromHexRGB(0xf22a2a)
                                               andDerection:enumColorDirectionFrom_left]];
}

- (void)populateData:(ModelCenter *)model{
    self.imgHead.backgroundColor = kClearColor;
    if (![NSString isNullString:model.head]) {
        [self.imgHead setImagePathHead:model.head];
    }
    NSString *strName = model.userName;
    NSMutableArray *array = [NSMutableArray array];
    ModelLogin *modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    switch ([modelLogin.grade_id intValue]) {//0、普通用户;1、普通商家;2、高级商家;3、vip商家
        case 2:{
            [array addObject:@" 喵小店 #高级商家# "];
        } break;
        case 3:{
            [array addObject:@" 喵小店 #Vip商家# "];
        } break;
        default:{
            if ([model.level intValue]==2){
                [array addObject:@"  运营商  "];
            }else{
                [array addObject:@"  会员  "];
            }
            if ([model.regional boolValue]){
                [array addObject:@"  城市合伙人  "];
            }
            if ([model.corporate floatValue]>0) {
                [array addObject:@"  股东  "];
            }
        } break;
    }
    
    if (array.count==1) {
        [self.lblOne setTextNull:array[0]];
        [self.lblTwo setHidden:YES];
        [self.lblThree setHidden:YES];
    }else if (array.count==2) {
        [self.lblTwo setTextNull:array[1]];
        [self.lblTwo setHidden:NO];
        [self.lblThree setHidden:YES];
    }else if (array.count==3) {
        [self.lblTwo setTextNull:array[1]];
        [self.lblThree setTextNull:array[2]];
        [self.lblTwo setHidden:NO];
        [self.lblThree setHidden:NO];
    }
    [self.lblName setTextZanwu:strName];
    NSString *strCode = StringFormat(@"我的ID:%@",[NSString stringStandard:[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId]);
    NSString *strInviter = [[JJDBHelper sharedInstance] fetchCenterMsg].inviter_id;
    if (![NSString isNullString:strInviter]) {
        strCode = StringFormat(@"%@  邀请人ID:%@",strCode,strInviter);
    }
    [self.lblCode setTextNull:strCode];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
