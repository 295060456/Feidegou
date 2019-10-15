//
//  AdvertiseStartController.m
//  guanggaobao
//
//  Created by 谭自强 on 2016/11/25.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "AdvertiseStartController.h"
#import "AppDelegate.h"
#import "UAProgressView.h"

@interface AdvertiseStartController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgStart;
@property (strong, nonatomic) UAProgressView *progressViewStart;
@property (weak, nonatomic) IBOutlet UAProgressView *viJump;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIButton *btnJump;
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation AdvertiseStartController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    [self.imgStart setImage:self.image];
    [self.viJump setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
    [self addTimer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickButtonJump:(UIButton *)sender {
    [self removeTimer];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setEntryByUrl:nil];
}
- (IBAction)clickButtonAdver:(UIButton *)sender {
    if (![NSString isNullString:self.strUrl]) {
        [self removeTimer];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate setEntryByUrl:self.strUrl];
    }
}

- (void)timerCountDown:(NSTimer *)timer{
    [self clickButtonJump:self.btnJump];
}
/**
 *添加计时器
 */
- (void)addTimer{
    D_NSLog(@"addTimer");
    [self removeTimer];
    self.progressViewStart = [[UAProgressView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self.viJump insertSubview:self.progressViewStart belowSubview:self.lblTime];
    [self.progressViewStart setAnimationDuration:3];
    [self.progressViewStart setProgress:1 animated:YES];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(timerCountDown:) userInfo:nil repeats:NO];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
