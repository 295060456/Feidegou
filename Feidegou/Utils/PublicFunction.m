//
//  PublicFunction.m
//  Vendor
//
//  Created by 谭自强 on 2016/12/13.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "PublicFunction.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@implementation PublicFunction

+ (enumOrderState)returnStateByNum:(NSString *)strState{
    
    //    enumOrder_yqx = 0,//已取消
    //    enumOrder_dfk = 10,//待付款
    //    enumOrder_xxzfdsh = 15,//线下支付待审核
    //    enumOrder_hdfkdfh = 16,//货到付款待发货
    //    enumOrder_yfk = 20,//已付款
    //    enumOrder_yfh = 30,//已发货
    //    enumOrder_ysh = 40,//已收货
    //    enumOrder_ywc = 50,//已完成,已评价
    //    enumOrder_yjs = 60//已结束
    int intState = [strState intValue];
    if (intState>40&&intState<50) {
        return enumOrder_tksh;
    }
    if (intState == 0){
        return enumOrder_yqx;
    }else if (intState == 10) {
        return enumOrder_dfk;
    }else if (intState == 15){
        return enumOrder_xxzfdsh;
    }else if (intState == 16){
        return enumOrder_hdfkdfh;
    }else if (intState == 20){
        return enumOrder_yfk;
    }else if (intState == 30){
        return enumOrder_yfh;
    }else if (intState == 40){
        return enumOrder_ysh;
    }else if (intState == 50){
        return enumOrder_ywc;
    }else{
        return enumOrder_yjs;
    }
}

+ (NSString *)translateTime:(NSString *)strTime{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateMiddle = [NSDate dateWithTimeIntervalSince1970:[[NSString stringStandard:strTime] doubleValue]/1000];
    NSString *strTimeBack = [dateFormatter stringFromDate:dateMiddle];
    if ([NSString isNullString:strTimeBack]) {
        strTimeBack = @"";
    }
    return strTimeBack;
}

+ (NSString *)translateTimeHMS:(NSString *)strTime{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateMiddle = [NSDate dateWithTimeIntervalSince1970:[[NSString stringStandard:strTime] doubleValue]/1000];
    NSString *strTimeBack = [dateFormatter stringFromDate:dateMiddle];
    if ([NSString isNullString:strTimeBack]) {
        strTimeBack = @"";
    }
    return strTimeBack;
}

//黑色背景显示
+ (UIImage *)getImageWithRect:(CGRect)rectBegin
                andColorBegin:(UIColor *)colorBegin
                  andColorEnd:(UIColor *)colorEnd
                 andDerection:(enumColorDirectionFrom)derection{
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(rectBegin), CGRectGetHeight(rectBegin));
    
    CIFilter *ciFilter = [CIFilter filterWithName:@"CILinearGradient"];
    CIVector *vector0;
    CIVector *vector1;
    if (derection == enumColorDirectionFrom_up) {
        vector0 = [CIVector vectorWithX:0 Y:rect.size.height];
        vector1 = [CIVector vectorWithX:0 Y:0];
    }else if (derection == enumColorDirectionFrom_down) {
        vector0 = [CIVector vectorWithX:0 Y:0];
        vector1 = [CIVector vectorWithX:0 Y:rect.size.height];
    }else if (derection == enumColorDirectionFrom_left) {
        vector0 = [CIVector vectorWithX:0 Y:0];
        vector1 = [CIVector vectorWithX:rect.size.width Y:0];
    }else{
        vector0 = [CIVector vectorWithX:rect.size.width Y:0];
        vector1 = [CIVector vectorWithX:0 Y:0];
    }
    [ciFilter setValue:vector0 forKey:@"inputPoint0"];
    [ciFilter setValue:vector1 forKey:@"inputPoint1"];
    [ciFilter setValue:[CIColor colorWithCGColor:colorBegin.CGColor] forKey:@"inputColor0"];
    [ciFilter setValue:[CIColor colorWithCGColor:colorEnd.CGColor] forKey:@"inputColor1"];
    CIImage *ciImage = ciFilter.outputImage;
    CIContext *con = [CIContext contextWithOptions:nil];
    CGImageRef resultCGImage = [con createCGImage:ciImage
                                         fromRect:rect];
    UIImage *resultUIImage = [UIImage imageWithCGImage:resultCGImage];
    CGImageRelease(resultCGImage);
    
    [resultUIImage drawInRect:rect];
    return resultUIImage;
}
//黑色背景显示
- (UIImage *)getImageShowClear:(CGRect)rectBegin
                  andIsBeginUp:(BOOL)isBeginUp{
    UIColor *colorUp = [UIColor colorWithWhite:0 alpha:0];
    UIColor *colorDown = [UIColor colorWithWhite:0 alpha:0.3];
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(rectBegin), CGRectGetHeight(rectBegin));
    
    CIFilter *ciFilter = [CIFilter filterWithName:@"CILinearGradient"];
    CIVector *vector0;
    CIVector *vector1;
    if (isBeginUp) {
        vector0 = [CIVector vectorWithX:0 Y:rect.size.height];
        vector1 = [CIVector vectorWithX:0 Y:0];
    }else{
        vector0 = [CIVector vectorWithX:0 Y:0];
        vector1 = [CIVector vectorWithX:0 Y:rect.size.height];
    }
    [ciFilter setValue:vector0 forKey:@"inputPoint0"];
    [ciFilter setValue:vector1 forKey:@"inputPoint1"];
    [ciFilter setValue:[CIColor colorWithCGColor:colorUp.CGColor] forKey:@"inputColor0"];
    [ciFilter setValue:[CIColor colorWithCGColor:colorDown.CGColor] forKey:@"inputColor1"];
    CIImage *ciImage = ciFilter.outputImage;
    CIContext *con = [CIContext contextWithOptions:nil];
    CGImageRef resultCGImage = [con createCGImage:ciImage
                                         fromRect:rect];
    UIImage *resultUIImage = [UIImage imageWithCGImage:resultCGImage];
    CGImageRelease(resultCGImage);
    
    [resultUIImage drawInRect:rect];
    return resultUIImage;
}
+ (NSInteger)heightByInfo:(NSDictionary *)dicInfo{
    
    NSString *strType = TransformString(dicInfo[@"type"]);
    if ([strType isEqualToString:@"banner"]) {
        return SCREEN_WIDTH*324/720;
    }
    if ([strType isEqualToString:@"m2_1"]) {
        return SCREEN_WIDTH*230/720;
    }
    if ([strType isEqualToString:@"m3_1"]) {
        return SCREEN_WIDTH*276/720;
    }
    if ([strType isEqualToString:@"m3_2"]) {
        return SCREEN_WIDTH*248/720;
    }
    if ([strType isEqualToString:@"m4_1"]) {
        return SCREEN_WIDTH*230/720;
    }
    if ([strType isEqualToString:@"m4_2"]) {
        return SCREEN_WIDTH*460/720;
    }
    if ([strType isEqualToString:@"m5_1"]) {
        return SCREEN_WIDTH*460/720;
    }
    if ([strType isEqualToString:@"m7_1"]) {
        return SCREEN_WIDTH*460/720;
    }
    if ([strType isEqualToString:@"m8_1"]) {
        return SCREEN_WIDTH*690/720;
    }
    if ([strType isEqualToString:@"m10_1"]) {
        return SCREEN_WIDTH*690/720;
    }
    if ([strType isEqualToString:@"photo"]) {
        NSArray *array = dicInfo[@"modeList"];
        if (array.count>0&&[array isKindOfClass:[NSArray class]]) {
            NSInteger intHeight = [[NSString stringStandardZero:array[0][@"height"]] integerValue];
            NSInteger intWidth = [[NSString stringStandardZero:array[0][@"width"]] integerValue];
            if (intWidth>0&&intHeight>0) {
                return SCREEN_WIDTH*intHeight/intWidth;
            }
        }
        return SCREEN_WIDTH*76/720;
    }
    if ([strType isEqualToString:@"title"]) {
        return SCREEN_WIDTH*76/720;
    }
    if ([strType isEqualToString:@"type"]) {
        NSArray *array = dicInfo[@"modeList"];
        if (array.count<5) {
            return SCREEN_WIDTH*160/720;
        }
        return SCREEN_WIDTH*320/720;
    }
    if ([strType isEqualToString:@"zixun"]) {
        return SCREEN_WIDTH*92/720;
    }
    if ([strType isEqualToString:@"banner1"]) {
        return SCREEN_WIDTH*164/720+10;
    }
    return 0;
}

+ (NSMutableArray *)returnButtonNameByNum:(NSString *)strState
                          andIsNeedDetail:(BOOL)isDetail
                           andcourierCode:(NSString *)courierCode{
//    orderStateNameMap.put("0", "已取消");
//    orderStateNameMap.put("10", "待付款");     去支付、取消订单
//    orderStateNameMap.put("20", "已付款");      申请退款
//    orderStateNameMap.put("30", "已发货");     //申请退款 确认收货
//    orderStateNameMap.put("40", "已收货");     去评价
//    orderStateNameMap.put("45", "买家申请退款");
//    orderStateNameMap.put("48", "卖家拒绝退款");
//    orderStateNameMap.put("50", "已完成");
//    orderStateNameMap.put("60", "申请退款中");
//    orderStateNameMap.put("70", "已退款");
    NSMutableArray *array = [NSMutableArray array];
    int intState = [strState intValue];
    if (intState == 10) {
        [array addObject:@"去支付"];
        [array addObject:@"取消订单"];
    }else if (intState == 20){
        if (isDetail) {
            [array addObject:@"申请退款"];
        }
    }else if (intState == 30){
        [array addObject:@"确认收货"];
        if (isDetail) {
            [array addObject:@"申请退款"];
        }
    }else if (intState == 40){
        [array addObject:@"去评价"];
    }
    if (![NSString isNullString:courierCode]) {
        [array addObject:@"查看物流"];
    }
    if (isDetail&&array.count<3) {
        [array addObject:@"查看详情"];
    }
    return array;
}

+ (NSMutableArray *)returnButtonNameNoDetailByNum:(NSString *)strState{
    NSMutableArray *array = [NSMutableArray array];
    int intState = [strState intValue];
    if (intState == 10) {
        [array addObject:@"去支付"];
        [array addObject:@"取消订单"];
    }else if (intState == 20){
    }else if (intState == 30){
        [array addObject:@"确认收货"];
        [array addObject:@"查看物流"];
    }else if (intState == 40){
        [array addObject:@"去评价"];
        [array addObject:@"查看物流"];
    }else if (intState == 50){
        [array addObject:@"查看物流"];
    }else if (intState == 55){
    }else{
    }
    return array;
}

+ (UIImage *)fetchImageForShareAchievement:(NSDictionary *)dicInfo{
    UIColor *colorBack = ColorFromRGB(48, 45, 65);
    UIImage *image;
    UIView *viShare = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 640, 1136)];
    [viShare setBackgroundColor:colorBack];
    ModelLogin *model = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
    //        背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 640, 1136)];
    [imageView setImage:[UIImage imageNamed:@"achievement"]];
    [viShare addSubview:imageView];
    //        头像
    UIView *viHead = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(viShare.frame)/2-45, 55, 90, 90)];
    [viHead.layer setCornerRadius:CGRectGetWidth(viHead.frame)/2];
    [viHead setClipsToBounds:YES];
    [viHead setBackgroundColor:ColorFromRGB(251, 194, 205)];
    [viShare addSubview:viHead];
    
    UIImageView *imageHead = [[UIImageView alloc] initWithFrame:CGRectMake(2,
                                                                           2,
                                                                           CGRectGetWidth(viHead.frame)-4,
                                                                           CGRectGetWidth(viHead.frame)-4)];
    UIImage *imgHead = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:model.head];
    if (imgHead) {
        [imageHead setImage:imgHead];
    }else{
        [imageHead setImage:ImageNamed(@"img_defult_head")];
    }
    [imageHead.layer setCornerRadius:CGRectGetWidth(imageHead.frame)/2];
    [imageHead setClipsToBounds:YES];
    [viHead addSubview:imageHead];
    
    if (dicInfo.count>1) {
        CGFloat fX = 100;
        
        UILabel *lblTipUp = [[UILabel alloc] initWithFrame:CGRectMake(fX,
                                                                      CGRectGetMaxY(viHead.frame),
                                                                      CGRectGetWidth(viShare.frame)-2*fX,
                                                                      50)];
        [lblTipUp setFont:[UIFont systemFontOfSize:22.0]];
        [lblTipUp setTextColor:ColorRed];
        [lblTipUp setTextAlignment:NSTextAlignmentCenter];
        [lblTipUp setText:@"我今日在非得购商城看广告赚了"];
        [viShare addSubview:lblTipUp];
        
        // 金额
        NSString *strMoney = [NSString stringStandardFloatTwo:dicInfo[@"today"]];
        NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"%@元",strMoney)];
        [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:80],
                                        NSForegroundColorAttributeName:ColorRed}
                                range:NSMakeRange(0, strMoney.length)];
        UILabel *lblMoney = [[UILabel alloc] initWithFrame:CGRectMake(fX,
                                                                      CGRectGetMaxY(lblTipUp.frame),
                                                                      CGRectGetWidth(viShare.frame)-2*fX,
                                                                      280-CGRectGetMaxY(lblTipUp.frame))];
        [lblMoney setFont:[UIFont systemFontOfSize:22.0]];
        [lblMoney setTextColor:ColorFromRGB(241, 242, 217)];
        [lblMoney setTextAlignment:NSTextAlignmentCenter];
        [lblMoney setAttributedText:atrStringPrice];
        [viShare addSubview:lblMoney];
        
        
        NSString *strOne = [NSString stringStandardFloatTwo:dicInfo[@"total"]];
        NSString *strTwo = [NSString stringStandardZero:dicInfo[@"china"]];
        NSString *strThree = [NSString stringStandardZero:dicInfo[@"buynum"]];
        NSString *strFour = [NSString stringStandardZero:dicInfo[@"average"]];
        NSString *strFive = [NSString stringStandardZero:dicInfo[@"ranking"]];
        
        UILabel *lblTipTwo = [[UILabel alloc] initWithFrame:CGRectMake(fX, 415, CGRectGetWidth(viShare.frame)-2*fX, 80)];
        [lblTipTwo setFont:[UIFont systemFontOfSize:82.0]];
        [lblTipTwo setTextColor:ColorFromRGB(241, 242, 217)];
        [lblTipTwo setTextAlignment:NSTextAlignmentCenter];
        [lblTipTwo setTextNull:StringFormat(@"%@元",strOne)];
        [viShare addSubview:lblTipTwo];
        
        UIView *viMoney = [[UIView alloc] initWithFrame:CGRectMake(fX, 590, CGRectGetWidth(viShare.frame)-2*fX, 210)];
        [viMoney setBackgroundColor:ColorFromRGB(221, 189, 128)];
        [viMoney.layer setCornerRadius:5.0];
        [viMoney setClipsToBounds:YES];
        [viShare addSubview:viMoney];
        
        NSMutableAttributedString * atrDes = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"累计报销%@元,\n超过了全国%@的用户\n累计购买%@笔 平均每月消费%@笔\n全国排名%@名",strOne,strTwo,strThree,strFour,strFive)];
        [atrDes addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HYXiDengXianJ" size:30],NSForegroundColorAttributeName:ColorBlack} range:NSMakeRange(4, strOne.length)];
        [atrDes addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HYXiDengXianJ" size:30],NSForegroundColorAttributeName:ColorBlack} range:NSMakeRange(4+strOne.length+8, strTwo.length)];
        [atrDes addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HYXiDengXianJ" size:30],NSForegroundColorAttributeName:ColorBlack} range:NSMakeRange(5+strOne.length+8+strTwo.length+7, strThree.length)];
        [atrDes addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HYXiDengXianJ" size:30],NSForegroundColorAttributeName:ColorBlack} range:NSMakeRange(5+strOne.length+8+strTwo.length+7+strThree.length+8, strFour.length)];
        [atrDes addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HYXiDengXianJ" size:30],NSForegroundColorAttributeName:ColorBlack} range:NSMakeRange(5+strOne.length+8+strTwo.length+7+strThree.length+8+strFour.length+6, strFive.length)];
        NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle  setLineSpacing:8];
        [atrDes  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [atrDes length])];
        //        [atrDes  addAttribute:NSKernAttributeName value:@3 range:NSMakeRange(0, [atrDes length])];
        UILabel *lblDes = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, CGRectGetWidth(viMoney.frame)-40, 210)];
        [lblDes setFont:[UIFont fontWithName:@"HYXiDengXianJ" size:24]];
        [lblDes setTextColor:ColorRed];
        [lblDes setAttributedText:atrDes];
        [lblDes setNumberOfLines:0];
        [viMoney addSubview:lblDes];

        // 二维码

        UIImage *imgCode = [UIImage createNonInterpolatedUIImageFormString:StringFormat(@"%@/inviter.htm?user_id=%@",BASE_URL,[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId) withSize:128];
        UIImageView *imgVi = [[UIImageView alloc] initWithFrame:CGRectMake(392, 856, 128, 128)];
        [imgVi setBackgroundColor:[UIColor whiteColor]];
        [imgVi setImage:imgCode];
        [viShare addSubview:imgVi];
    }
    UIGraphicsBeginImageContextWithOptions(viShare.bounds.size, YES, 0);     //设置截屏大小
    [[viShare layer] renderInContext:UIGraphicsGetCurrentContext()];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
