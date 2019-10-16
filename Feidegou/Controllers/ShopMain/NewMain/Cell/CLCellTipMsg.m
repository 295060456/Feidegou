//
//  CLCellTipMsg.m
//  guanggaobao
//
//  Created by 谭自强 on 2018/4/28.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "CLCellTipMsg.h"

@implementation CLCellTipMsg
- (void)refreshLable:(NSArray *)array{
//    [self.lblMsg refreshLabels];
//    [self.lblMsg observeApplicationNotifications];
    self.arrData = [NSMutableArray array];
    if ([array isKindOfClass:[NSArray class]]) {
        [self.arrData addObjectsFromArray:array];
    }
    [self addTimer];
}
/**
 *添加计时器
 */
- (void)addTimer{
    D_NSLog(@"addTimer");
    [self removeTimer];
    self.intRow = 0;
    [self beginShowMsg:self.timer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(beginShowMsg:) userInfo:nil repeats:YES];
    //将timer添加到RunLoop中
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
/**
 *移除计时器
 */
- (void)removeTimer{
    D_NSLog(@"removeTimer");
    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = nil;
}
- (void)beginShowMsg:(NSTimer *)timer{
    if (self.arrData.count==0) {
        [self.lblMsg setText:@""];
        [self.imgZhixun setImageNoHolder:@""];
        return;
    }
    if (self.intRow>=self.arrData.count) {
        self.intRow = 0;
    }
    [self.lblMsg setText:self.arrData[self.intRow][@"title"]];
    [self.lblMsg setTextColor:[NSString getColor:self.arrData[self.intRow][@"titleColor"] andMoren:ColorGary]];
    [self.imgZhixun setImageNoHolder:self.arrData[self.intRow][@"picture"]];
    self.intRow++;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lblMsg setTextAlignment:NSTextAlignmentLeft];
    [self.lblMsg setFont:[UIFont systemFontOfSize:14.0]];
    [self.lblMsg setTextColor:ColorGary];
    // Initialization code
}
- (void)drawRect:(CGRect)rect
{
    UIColor *color = ColorLine;
    CGContextRef context = UIGraphicsGetCurrentContext();
    //上分割线
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextStrokeRect(context, CGRectMake(0, 0, rect.size.width, 0.5));
}
@end
