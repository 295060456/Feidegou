//
//  NSString+extension.h
//  JiandaobaoVendor
//
//  Created by 谭自强 on 15/8/3.
//  Copyright (c) 2015年 朝花夕拾. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSString (extension)
/*
 *是否为邮箱
 */
+ (BOOL)isEmail:(NSString *)email;
/*
 *是否为钱，正整数，一位和两位小数点
 */
+ (BOOL)isMoney:(NSString *)email;

/*
 *是否为电话
 */
+ (BOOL)isPhone:(NSString *)strPhone;
/*
 *是否为6到16为的数字和字母组合
 */
+ (BOOL)isUser:(NSString *)strUser;
/*
 *是否为身份证号码15位的全部是数字，18为的后面一位可以为x或者X
 */
+ (BOOL)isCardNum:(NSString *)strCardNum;
/*
 *是否为固定电话
 */
+ (BOOL)isLineTelephone:(NSString *)strPhone;
/*
 *是否为正整数
 */
+ (BOOL)isPositiveInteger:(NSString *)strNum;
/*
 *是否为6-16位的英文字母和数字
 */
+ (BOOL)isPassword:(NSString *)strPsw;
/*
 *字符串是否为空
 */
+ (BOOL)isNullString:(NSString*)string;
/*
 *取出字符串两边的空白
 */
+ (NSString *)clearWhitespaceCharacterSet:(NSString *)strFrom;
/*
 *根据key从Dictionary取出字符串
 */
+ (NSString *)getStringFromDictionary:(id)dicValue andKey:(NSString *)strKey;
/*
 *如果string为空返回@""
 */
+ (NSString *)stringStandard:(NSString *)string;
/*
 *如果string为空返回@"0"
 */
+ (NSString *)stringStandardZero:(NSString *)string;
/*
 *如果string为空返回@"暂无"
 */
+ (NSString *)stringStandardZanwu:(NSString *)string;
/*
 *返回小数点两位
 */
+ (NSString *)stringStandardFloatTwo:(NSString *)string;
/*
 *获得男女
 */
+ (NSString *)stringStandardGetManOrWoman:(NSString *)string;
//字符串编码
+ (NSString *)encodeToPercentEscapeString: (NSString *) input;
//是否包含
- (BOOL)ContainsString:(NSString *)subString;
//把数字转为每三个加一个逗号
+ (NSString *)countNumAndChangeformat:(NSString *)num;

//计算字符串长度
+ (CGSize)conculuteRightCGSizeOfString:(NSString *)strContent andWidth:(float)fWidth andFont:(float)fFont;

/*
 *根据类型返回积分还是红包
 */
+ (NSString *)stringStandardToIntegralOrRedPacket:(NSString *)string;
//字符串转为颜色
+ (UIColor *)getColor:(NSString *)hexColor;

//字符串转为颜色
+ (UIColor *)getColor:(NSString *)hexColor andMoren:(UIColor *)colorMoren;

+(NSString *)ensureNonnullString:(id)nullableStr
                      ReplaceStr:(NSString *)replaceStr;
+(BOOL)isIncludeChinese:(NSString *) str;

//开始时间给定 结束时间不给定就启用现在的时间戳
+(NSTimeInterval)timeIntervalstartDate:(NSString *_Nonnull)startTime
                               endDate:(NSString *_Nullable)endTime
                         timeFormatter:(NSDateFormatter *_Nullable)timeFormatter;

@end
