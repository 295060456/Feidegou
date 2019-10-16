//
//  CellPicture.m
//  guanggaobao
//
//  Created by 谭自强 on 16/7/13.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "CellPicture.h"

@implementation CellPicture

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)populateData:(NSArray *)arrPicture{
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
        self.cycleScrollView.autoScroll = YES;
        self.cycleScrollView.showPageControl = YES;
        self.cycleScrollView.autoScrollTimeInterval = 5;
    }
    //             --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.cycleScrollView.imageURLStringsGroup = arrImage;
    });
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
//    if ([self.delegeteBanner respondsToSelector:@selector(didClickDelegeteCollectionViewBannerDictionary:)]) {
//        [self.delegeteBanner didClickDelegeteCollectionViewBannerDictionary:self.array[index]];
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
