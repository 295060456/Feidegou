//
//  CLCellBanner.m
//  guanggaobao
//
//  Created by 谭自强 on 2018/4/27.
//  Copyright © 2018年 朝花夕拾. All rights reserved.
//

#import "CLCellBanner.h"

@implementation CLCellBanner

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)populateData:(NSArray *)arrPicture{
    self.array = [NSMutableArray arrayWithArray:arrPicture];
    NSMutableArray *arrImage = [NSMutableArray array];
    for (int i = 0; i<arrPicture.count; i++) {
        [arrImage addObject:[NSString stringStandard:arrPicture[i][@"picture"]]];
    }
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.cycleScrollView.delegate = self;
//    self.cycleScrollView.placeholderImage = [UIImage imageNamed:@""];
    if (arrImage.count<=1) {
        self.cycleScrollView.autoScroll = NO;
        self.cycleScrollView.showPageControl = NO;
    }else{
        self.cycleScrollView.autoScroll = NO;
        self.cycleScrollView.showPageControl = YES;
    }
    //             --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.cycleScrollView.imageURLStringsGroup = arrImage;
    });
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if ([self.delegeteBanner respondsToSelector:@selector(didClickDelegeteCollectionViewBannerDictionary:)]) {
        [self.delegeteBanner didClickDelegeteCollectionViewBannerDictionary:self.array[index]];
    }
}
@end
