//
//  DateSelecet.h
//  fastdriveVendor
//
//  Created by 谭自强 on 15/10/14.
//  Copyright © 2015年 朝花夕拾. All rights reserved.
//

@protocol datePickerDeleget<NSObject>
@required
- (void)dateSelected:(NSString *__nonnull)strData;
@end
#import <UIKit/UIKit.h>

@interface DateSelecet : UIView

@property (nonatomic, assign) id<datePickerDeleget> delegate;


@property (nonatomic) UIDatePickerMode datePickerMode; // default is UIDatePickerModeDateAndTime
@property (nonatomic, strong) NSDate *date;        // default is current date when picker created. Ignored in countdown timer mode. for that mode, picker starts at 0:00
@property (nullable, nonatomic, strong) NSDate *minimumDate; // specify min/max date range. default is nil. When min > max, the values are ignored. Ignored in countdown timer mode
@property (nullable, nonatomic, strong) NSDate *maximumDate;
@end
