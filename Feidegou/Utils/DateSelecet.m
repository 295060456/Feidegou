//
//  DateSelecet.m
//  fastdriveVendor
//
//  Created by 谭自强 on 15/10/14.
//  Copyright © 2015年 朝花夕拾. All rights reserved.
//

#import "DateSelecet.h"
@interface DateSelecet()
@property (strong, nonatomic) UIDatePicker *datePicker;
//@property (strong, nonatomic) UIButton *btnCacel;
@property (strong, nonatomic) UIButton *btnConfilm;
@property (strong, nonatomic) UIView *viDate;


@end
@implementation DateSelecet
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.viDate = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, 200)];
        [self.viDate setBackgroundColor:ColorFromRGBSame(250)];
        
        
        self.btnConfilm = [[UIButton alloc] init];
        [self.btnConfilm setFrame:CGRectMake(SCREEN_WIDTH-70, 0, 60, 40)];
        [self.btnConfilm setTitle:@"确定" forState:UIControlStateNormal];
        [self.btnConfilm setTitleColor:ColorBlack forState:UIControlStateNormal];
        [self.btnConfilm.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [self.btnConfilm.titleLabel setTextAlignment:NSTextAlignmentRight];
        [self.btnConfilm addTarget:self action:@selector(clickButtonComfilm:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lblLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 39.5, SCREEN_WIDTH, 0.5)];
        [lblLine setBackgroundColor:ColorLine];
        [self.viDate addSubview:lblLine];
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.btnConfilm.frame), SCREEN_WIDTH, self.viDate.frame.size.height-CGRectGetMaxY(self.btnConfilm.frame))];
        [self.datePicker setDatePickerMode:UIDatePickerModeDate];
        [self.datePicker setBackgroundColor:[UIColor whiteColor]];
        
        [self.viDate addSubview:self.btnConfilm];
        [self.viDate addSubview:self.datePicker];
        [self addSubview:self.viDate];
        [self showDatePicker];
    
    }
    return self;
}
- (void)showDatePicker{
    [UIView animateWithDuration:0.27 animations:^{
        
        [self setBackgroundColor:ColorFromHexRGBA(0, 0.4)];
        [self.viDate setFrame:CGRectMake(0, self.frame.size.height-self.viDate.frame.size.height, self.viDate.frame.size.width, self.viDate.frame.size.height)];
    }completion:^(BOOL isfinished){
    }];
}
- (void)hidenDatePicker{
    [UIView animateWithDuration:0.27 animations:^{
        [self setBackgroundColor:ColorFromHexRGBA(0, 0.4)];
        [self.viDate setFrame:CGRectMake(0, self.frame.size.height, self.viDate.frame.size.width, self.viDate.frame.size.height)];
    }completion:^(BOOL isfinished){
        [self removeFromSuperview];
    }];
}
- (void)clickButtonCancell:(UIButton *)sender {
    [self hidenDatePicker];
}
- (void)clickButtonComfilm:(UIButton *)sender {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strTime = [dateFormatter stringFromDate:self.datePicker.date];
    D_NSLog(@"strTime is %@",strTime);
    [self.delegate dateSelected:strTime];
    [self hidenDatePicker];
}
- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode{
    [self.datePicker setDatePickerMode:datePickerMode];
}
- (void)setMaximumDate:(NSDate *)maximumDate{
    [self.datePicker setMaximumDate:maximumDate];
}
- (void)setMinimumDate:(NSDate *)minimumDate{
    [self.datePicker setMinimumDate:minimumDate];
}
- (void)setDate:(NSDate *)date{
    [self.datePicker setDate:date];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self hidenDatePicker];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
