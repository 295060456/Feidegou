//
//  UILabel+helper.m
//  guanggaobao
//
//  Created by 谭自强 on 16/6/28.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "UILabel+helper.h"

@implementation UILabel (helper)

- (void)setTextNull:(NSString *)string{
    [self setText:[NSString stringStandard:string]];
}

- (void)setTextZanwu:(NSString *)string{
    [self setText:[NSString stringStandardZanwu:string]];
}

- (void)setTextFolatTwo:(NSString *)string{
    [self setText:[NSString stringStandardFloatTwo:string]];
}

- (void)setText:(NSString *)string andTip:(NSString *)strTip{
    if ([NSString isNullString:string]) {
        if ([NSString isNullString:strTip]) {
            strTip = @"";
        }
        string = strTip;
    }else{
        string = TransformString(string);
    }
    [self setText:string];
}

- (void)setTextVendorPrice:(NSString *)priceNow
               andOldPrice:(NSString *)priceOld{
    priceNow = [NSString stringStandardFloatTwo:priceNow];
    priceOld = [NSString stringStandardFloatTwo:priceOld];
    [self setFont:[UIFont systemFontOfSize:13.0]];
    [self setTextColor:ColorRed];
    NSMutableAttributedString * atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"￥%@ 门市价:￥%@",priceNow,priceOld)];
    [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]}
                            range:NSMakeRange(1, priceNow.length)];
    [atrStringPrice addAttributes:@{NSForegroundColorAttributeName:ColorGary}
                            range:NSMakeRange(priceNow.length + 2, priceOld.length + 5)];
    [self setAttributedText:atrStringPrice];
}

- (void)setTextGoodPrice:(NSString *)priceNow
                   andDB:(NSString *)db{
    
    NSString *strPriceNow = [NSString stringStandardFloatTwo:priceNow];
    NSString *strDB = [NSString stringStandardFloatTwo:db];
    [self setTextColor:ColorHeader];
    [self setFont:[UIFont systemFontOfSize:13.0]];
    NSMutableAttributedString *atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"￥%@",strPriceNow)];

    if ([strDB floatValue]==0) {
        atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"￥%@",strPriceNow)];
    }else{
        atrStringPrice = [[NSMutableAttributedString alloc] initWithString:StringFormat(@"￥%@(可报销￥%@)",strPriceNow,strDB)];
        [atrStringPrice addAttributes:@{NSForegroundColorAttributeName:ColorFromHexRGB(0x2c9b05)}
                                range:NSMakeRange(strPriceNow.length + 1, strDB.length + 6)];
    }
    [atrStringPrice addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]}
                            range:NSMakeRange(1, strPriceNow.length)];
    [self setAttributedText:atrStringPrice];
}

@end
