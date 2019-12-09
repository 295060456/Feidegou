//
//  NSObject+Time.m
//  Feidegou
//
//  Created by Kite on 2019/12/9.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "NSObject+Time.h"

@implementation NSObject (Time)
//https://blog.csdn.net/autom_lishun/article/details/79094241
+(NSArray *)dateStringAfterlocalDateForYear:(NSInteger)year
                                      Month:(NSInteger)month
                                        Day:(NSInteger)day
                                       Hour:(NSInteger)hour
                                     Minute:(NSInteger)minute
                                     Second:(NSInteger)second{
    NSDate *localDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *minDate = [calender dateByAddingComponents:comps toDate:localDate options:0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH"];
    NSDateComponents *components = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:minDate];
    NSInteger thisYear=[components year];
    NSInteger thisMonth=[components month];
    NSInteger thisDay=[components day];
    NSInteger thisHour=[components hour];
    NSString *DateTime = [NSString stringWithFormat:@"%ld-%ld-%ld-%ld",(long)thisYear,(long)thisMonth,(long)thisDay,(long)thisHour];
    NSArray *array = [DateTime componentsSeparatedByString:@"-"];
    return array;
}
//https://blog.csdn.net/weixin_34055787/article/details/91893379
//https://www.jianshu.com/p/5f4e7fabcc02
+(NSDate *)getDate:(NSDate *)date
         afterTime:(NSInteger)afterTime{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setHour:afterTime];
    NSDate *resultDate = [gregorian dateByAddingComponents:offsetComponents
                                                    toDate:date
                                                   options:0];
    return resultDate;
}

+(NSDate *)currentTime{
    NSDate *date = NSDate.date;
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval interval = [zone secondsFromGMTForDate:date];
    NSDate *current = [date dateByAddingTimeInterval:interval];
    return current;
}

@end
