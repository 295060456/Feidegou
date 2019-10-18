//
//  NSString+extension.m
//  JiandaobaoVendor
//
//  Created by 谭自强 on 15/8/3.
//  Copyright (c) 2015年 朝花夕拾. All rights reserved.
//

#import "NSString+extension.h"

@implementation NSString (extension)
+ (BOOL)isEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isEmail = [emailTest evaluateWithObject:email];
    return isEmail;
}

+ (BOOL)isMoney:(NSString *)email{
    NSString *emailRegex = @"^[0-9]+(\\.[0-9]{1,2})?$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isEmail = [emailTest evaluateWithObject:email];
    return isEmail;
}

+ (BOOL)isPhone:(NSString *)strPhone{
    NSString *regex = @"^(1)\\d{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isPhone = [pred evaluateWithObject:strPhone];
    return isPhone;
}

+ (BOOL)isUser:(NSString *)strUser{
    NSString *regex = @"^[A-Za-z0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isUser = [pred evaluateWithObject:strUser];
    if (strUser.length<6||strUser.length>16) {
        isUser = NO;
    }
    return isUser;
}

+ (BOOL)isCardNum:(NSString *)strCardNum{
    NSString *regex = @"^(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isCardNum = [pred evaluateWithObject:strCardNum];
    return isCardNum;
}

+ (BOOL)isLineTelephone:(NSString *)strPhone{
    NSString *regex = @"^(0[0-9]{2,3}\\-)?([2-9][0-9]{6,7})+(\\-[0-9]{1,4})?$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isTelePhone = [pred evaluateWithObject:strPhone];
    return isTelePhone;
}

+ (BOOL)isPositiveInteger:(NSString *)strNum{
    NSString *regex = @"^[1-9]\\d*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isPositiveInteger = [pred evaluateWithObject:strNum];
    return isPositiveInteger;
}

+ (BOOL)isPassword:(NSString *)strPsw{
    NSString *regex = @"^[a-zA-Z0-9]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isPassword = [pred evaluateWithObject:strPsw];
    return isPassword;
}

+ (BOOL)isNullString:(NSString*)string{
    
    if (string == nil || string == NULL || [string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    string = StringFormat(@"%@",string);
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    string = [string stringByTrimmingCharactersInSet:whitespace];
    
    if (string.length == 0) {
        return YES;
    }   return NO;
}

+ (NSString *)clearWhitespaceCharacterSet:(NSString *)strFrom{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
    strFrom = [strFrom stringByTrimmingCharactersInSet:whitespace];
    return strFrom;
}

+ (NSString *)getStringFromDictionary:(id)dicValue
                               andKey:(NSString *)strKey{
    
    NSString *string = [dicValue objectForKey:strKey];
    NSString *strValue = [NSString stringWithFormat:@"%@",string];
    if (strValue == nil||
        strValue == NULL||
        [strValue isEqualToString:@"<null>"]||
        [strValue isEqualToString:@"(null)"]) {
        strValue = @"";
    }return  strValue;
}

+ (NSString *)stringStandard:(NSString *)string{
    if ([self isNullString:string]) {
        string = @"";
    }else{
        string = TransformString(string);
    }return string;
}

+ (NSString *)stringStandardZero:(NSString *)string{
    if ([self isNullString:string]) {
        string = @"0";
    }else{
        string = TransformString(string);
    }return string;
}

+ (NSString *)stringStandardZanwu:(NSString *)string{
    if ([self isNullString:string]) {
        string = @"暂无";
    }else{
        string = TransformString(string);
    }return string;
}

+ (NSString *)stringStandardFloatTwo:(NSString *)string{
    return StringFormat(@"%.2f",[[NSString stringStandardZero:string] floatValue]);
}

+ (NSString *)stringStandardGetManOrWoman:(NSString *)string{
//    如果是文字则直接返回文字,空则返回空，数字则判断男女
    
    string = TransformString(string);
    if ([NSString isNullString:string]) {
        string = @"";
    }else if ([string intValue] == 1) {
        string = @"男";
    }else if ([string intValue] == 2) {
        string = @"不限";
    }else{
        string = @"女";
    }return string;
}

+ (NSString *)SHA256Hashed_string:(NSString *)input{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    // This is an iOS5-specific method.
    // It takes in the data, how much data, and then output format, which in this case is an int array.
    CC_SHA256(data.bytes, (int)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    // Parse through the CC_SHA256 results (stored inside of digest[]).
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%2s", digest];
    }return output;
}

+ (NSString *)encodeToPercentEscapeString: (NSString *) input{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)input,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return outputStr;
}

- (BOOL)ContainsString:(NSString *)subString{
    return ([self rangeOfString:subString].location == NSNotFound) ? NO : YES;
}

+ (NSString *)countNumAndChangeformat:(NSString *)num{
    int count = 0;
    long long int a = num.longLongValue;
    while (a != 0)    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num];
    NSMutableString *newstring = [NSMutableString string];
    while (count > 3) {
        count -= 3;
        NSRange rang = NSMakeRange(string.length - 3, 3);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:@"," atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    return newstring;
}

#pragma mark------ 计算字符串长度
+ (CGSize)conculuteRightCGSizeOfString:(NSString *)strContent
                              andWidth:(float)fWidth
                               andFont:(float)fFont{
    strContent = TransformString(strContent);
    CGSize sizeExpensive = [strContent boundingRectWithSize:CGSizeMake(fWidth, 0)
                                                    options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fFont]}
                                                    context:nil].size;
    sizeExpensive = CGSizeMake(sizeExpensive.width+1, sizeExpensive.height+1);
    return sizeExpensive;
    
}

+ (NSString *)stringStandardToIntegralOrRedPacket:(NSString *)string{
    if ([string intValue]==2) {
        string = @"红包";
    }else{
        string = @"积分";
    }return string;
}

+ (int)stringToInt:(NSString *)string {
    unichar hex_char1 = [string characterAtIndex:0]; /* 两位16进制数中的第一位(高位*16) */
    int int_ch1;
    if (hex_char1 >= '0' && hex_char1 <= '9')
        int_ch1 = (hex_char1 - 48) * 16;   /* 0 的Ascll - 48 */
    else if (hex_char1 >= 'A' && hex_char1 <='F')
        int_ch1 = (hex_char1 - 55) * 16; /* A 的Ascll - 65 */
    else
        int_ch1 = (hex_char1 - 87) * 16; /* a 的Ascll - 97 */
    unichar hex_char2 = [string characterAtIndex:1]; /* 两位16进制数中的第二位(低位) */
    int int_ch2;
    if (hex_char2 >= '0' && hex_char2 <='9')
        int_ch2 = (hex_char2 - 48); /* 0 的Ascll - 48 */
    else if (hex_char1 >= 'A' && hex_char1 <= 'F')
        int_ch2 = hex_char2 - 55; /* A 的Ascll - 65 */
    else
        int_ch2 = hex_char2 - 87; /* a 的Ascll - 97 */
    return int_ch1+int_ch2;
}

+ (UIColor *)getColor:(NSString *)hexColor{
    if (hexColor.length<6) {
        return ColorBlack;
    }
    //    NSString *string = [hexColor substringFromIndex:1];//去掉#号
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    /* 调用下面的方法处理字符串 */
    red = [NSString stringToInt:[hexColor substringWithRange:range]];
    range.location = 2;
    green = [NSString stringToInt:[hexColor substringWithRange:range]];
    range.location = 4;
    blue = [NSString stringToInt:[hexColor substringWithRange:range]];
    return [UIColor colorWithRed:(float)(red/255.0f)
                           green:(float)(green / 255.0f)
                            blue:(float)(blue / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)getColor:(NSString *)hexColor andMoren:(UIColor *)colorMoren{
    //    if (hexColor.length<6) {
    //        return ColorBlack;
    //    }
    hexColor = [NSString stringStandard:hexColor];
    if ([hexColor ContainsString:@"#"]) {
        hexColor = [hexColor substringFromIndex:1];
    }
    if (hexColor.length!=6) {
        if (colorMoren) {
            return colorMoren;
        }
        return ColorBlack;
    }
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    /* 调用下面的方法处理字符串 */
    red = [NSString stringToInt:[hexColor substringWithRange:range]];
    range.location = 2;
    green = [NSString stringToInt:[hexColor substringWithRange:range]];
    range.location = 4;
    blue = [NSString stringToInt:[hexColor substringWithRange:range]];
    return [UIColor colorWithRed:(float)(red/255.0f)
                           green:(float)(green / 255.0f)
                            blue:(float)(blue / 255.0f)
                           alpha:1.0f];
}

@end
