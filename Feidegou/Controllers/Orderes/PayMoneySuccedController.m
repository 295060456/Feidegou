//
//  PayMoneySuccedController.m
//  guanggaobao
//
//  Created by 谭自强 on 2018/7/4.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "PayMoneySuccedController.h"
#import "MyOrderListController.h"

@interface PayMoneySuccedController ()
@property (weak, nonatomic) IBOutlet UILabel *lblTip;
@property (weak, nonatomic) IBOutlet UILabel *lblTipTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnButtonOne;
@property (weak, nonatomic) IBOutlet UIButton *btnButtonTwo;

@end

@implementation PayMoneySuccedController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.lblTip setTextColor:ColorHeader];
    [self.lblTipTwo setTextColor:ColorGaryDark];
    [self.btnButtonOne setTitleColor:ColorBlack forState:UIControlStateNormal];
    [self.btnButtonOne setBackgroundColor:ColorLine];
    [self.btnButtonTwo setTitleColor:ColorBlack forState:UIControlStateNormal];
    [self.btnButtonTwo setBackgroundColor:ColorLine];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickButtonOne:(UIButton *)sender {
    
    MyOrderListController *controller = [[UIStoryboard storyboardWithName:StoryboardMyOrder bundle:nil] instantiateViewControllerWithIdentifier:@"MyOrderListController"];
    controller.orderState = enumOrder_quanbu;
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)clickButtonTwo:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
