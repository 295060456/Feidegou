//
//  UnionBusinessController.m
//  guanggaobao
//
//  Created by 谭自强 on 16/8/31.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "UnionBusinessController.h"
#import "CellOneImage.h"

@interface UnionBusinessController ()
@property (weak, nonatomic) IBOutlet UITableView *tabUnionBusiness;
@property (strong, nonatomic) NSMutableArray *arrUnion;
@end

@implementation UnionBusinessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)locationControls{
    [self.tabUnionBusiness setBackgroundColor:ColorBackground];
    [self.tabUnionBusiness registerNib:[UINib nibWithNibName:@"CellOneImage" bundle:nil] forCellReuseIdentifier:@"CellOneImage"];
    self.arrUnion = [NSMutableArray array];
    [self.arrUnion addObject:@"img_union_chi"];
    [self.arrUnion addObject:@"img_union_zhu"];
    [self.arrUnion addObject:@"img_union_xing"];
    [self.arrUnion addObject:@"img_union_you"];
    [self.arrUnion addObject:@"img_union_gou"];
    [self.arrUnion addObject:@"img_union_yu"];
}

#pragma mark---tableviewdelegate---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arrUnion.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH*248/640;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellOneImage *cell = [tableView dequeueReusableCellWithIdentifier:@"CellOneImage"];
    [cell.imgHead setImage:ImageNamed(self.arrUnion[indexPath.section])];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    [viHead setBackgroundColor:[UIColor clearColor]];
    return viHead;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 1) {
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
