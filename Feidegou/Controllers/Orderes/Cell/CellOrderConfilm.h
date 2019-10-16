//
//  CellOrderConfilm.h
//  guanggaobao
//
//  Created by 谭自强 on 2018/4/25.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelOrderGoodList.h"
@protocol DidClickOrderDelegate<NSObject>
@optional
- (void)didClickOnlyPeisongfangshiRow:(NSInteger)row;
- (void)didClickOnlyFapiaoRow:(NSInteger)row;
@end
@interface CellOrderConfilm : UITableViewCell
@property (assign, nonatomic) id<DidClickOrderDelegate> delegete;
@property (weak, nonatomic) IBOutlet UITableView *tabOrder;
- (void)populateData:(ModelOrderGoodList *)model andRow:(NSInteger)row;
@end
