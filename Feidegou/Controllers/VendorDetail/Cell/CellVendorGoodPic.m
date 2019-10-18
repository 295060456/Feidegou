//
//  CellVendorGoodPic.m
//  ZhongZhi
//
//  Created by 谭自强 on 2017/9/1.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import "CellVendorGoodPic.h"

@implementation CellVendorGoodPic

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)populateData:(NSArray *)arrPicture
            andTitle:(NSDictionary *)dicInfo{
    NSMutableArray *arrImage = [NSMutableArray array];
    for (int i = 0; i<arrPicture.count; i++) {
        [arrImage addObject:[NSString stringStandard:arrPicture[i][@"photo_url"]]];
    }
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.placeholderImage = [UIImage imageNamed:@"img_defult_head"];
    if (arrImage.count<=1) {
        self.cycleScrollView.autoScroll = NO;
        self.cycleScrollView.showPageControl = NO;
    }else{
        self.cycleScrollView.autoScroll = NO;
        self.cycleScrollView.showPageControl = YES;
    }
    //             --- 模拟加载延迟
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        @strongify(self)
        self.cycleScrollView.imageURLStringsGroup = arrImage;
    });
    [self.lblTitle setTextNull:dicInfo[@"goods"][@"goods_name"]];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView
   didSelectItemAtIndex:(NSInteger)index{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
