//
//  CellPHBTopThree.h
//  guanggaobao
//
//  Created by 谭自强 on 16/3/2.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJTableViewCell.h"
#import "ModelRankList.h"


@interface CellPHBTopThree : JJTableViewCell

- (void)populateDataRanModel:(ModelRankList *)model
                      andRow:(NSInteger)integer;
@end
