//
//  Q_Pet.m
//  Feidegou
//
//  Created by Kite on 2019/10/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "Q_Pet.h"
#import "Q_Pet+VM.h"
#import <CoreMotion/CoreMotion.h>

typedef NS_ENUM  (NSInteger,DYAnimationType){
    kDYAnimationOne     = 1,
    kDYAnimationTwo     = 2,
    kDYAnimationThree   = 3,
    kDYAnimationFour    = 4,
    kDYAnimationFive    = 5,
    kDYAnimationSix     = 6,
    kDYAnimationSeven   = 7,
    kDYAnimationEight   = 8,
    kDYAnimationNine    = 9,
    kDYAnimationTen     = 10,
};

@interface Q_Pet (){
    NSString *jsonString;
    int d;
}

@property(nonatomic,strong)NSMutableArray <NSString *>*titlesMutArr;
@property(nonatomic,strong)NSMutableArray <NSString *>*imagesMutArr;

@end

@implementation Q_Pet

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }return self;
}

-(void)drawRect:(CGRect)rect{
    [self setContent:kIMG(@"NewRobotCat")//img_icon NewRobotCat
         contentType:MISFloatingBallContentTypeImage];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)actionBlock:(DataBlock)block{
    self.block = block;
}

- (void)motionBegan:(UIEventSubtype)motion
          withEvent:(nullable UIEvent *)event{
//    [self shake];
}

- (void)motionEnded:(UIEventSubtype)motion
          withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"Shake!");
    }
    if ([super respondsToSelector:@selector(motionEnded:withEvent:)]) {
        [super motionEnded:motion
                 withEvent:event];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(UIEvent *)event{
//    [self Animation];
    NSLog(@"QQQ");
    [self shake];
}

-(void)shake{
    NSLog(@"摇晃");
    NSMutableArray *obj = NSMutableArray.array;
    for (NSInteger i = 0; i < self.titlesMutArr.count; i++) {
        WBPopMenuModel *info = WBPopMenuModel.new;
        info.image = [self imagesMutArr][i];
        info.title = [self titlesMutArr][i];
        [obj addObject:info];
    }
    @weakify(self)
    [[WBPopMenuSingleton shareManager] showPopMenuSelecteWithFrame:self.frame
                                                         menuWidth:150
                                                              item:obj
                                                            action:^(NSInteger index) {
        NSLog(@"index:%ld",(long)index);
        @strongify(self)
        if (index == 0) {
            [self feed];//喂食 点一次调一次
        }
    }];
}

-(void)Animation{
    d++;
    if (_laAnimation) {
        [_laAnimation removeFromSuperview];
        _laAnimation = nil;
    }
    NSLog(@"KKK = %d",d %2);
    if (d % 2) {//开
       @weakify(self)
        [self setContent:kIMG(@"transparentIcon")
             contentType:MISFloatingBallContentTypeImage];
        [self.laAnimation playWithCompletion:^(BOOL animationFinished) {
            @strongify(self)
            [self.laAnimation removeFromSuperview];
            [self setContent:kIMG(@"NewRobotCat")
                 contentType:MISFloatingBallContentTypeImage];
        }];
    }else{//关
        [self setContent:kIMG(@"NewRobotCat")
             contentType:MISFloatingBallContentTypeImage];
        [self.laAnimation pause];//
    }
}

//-(NSString *)event_marchWithAnimationType:(DYAnimationType)animationType{
//    switch (animationType) {
//        case kDYAnimationOne:
//            return  @"Watermelon.json";
//            break;
//        case kDYAnimationTwo:
//            return  @"TwitterHeart.json";
//            break;
//        case kDYAnimationThree:
//            return  @"vcTransition1.json";
//            break;
//        case kDYAnimationFour:
//            return  @"HamburgerArrow.json";
//            break;
//        case kDYAnimationFive:
//            return  @"LottieLogo2.json";
//            break;
//        case kDYAnimationSix:
//            return  @"PinJump.json";
//            break;
//        case kDYAnimationSeven:
//            return  @"G.json";
//            break;
//        case kDYAnimationEight:
//            return  @"W.json";
//            break;
//        case kDYAnimationNine:
//            return  @"F.json";
//            break;
//        case kDYAnimationTen:
//            return  @"Q.json";
//            break;
//        default:
//            break;
//    }
//}
#pragma mark —— lazyload
-(LOTAnimationView *)laAnimation{
    if (!_laAnimation) {
        _laAnimation = [LOTAnimationView animationNamed:@"Watermelon.json"];
//        _laAnimation = [LOTAnimationView animationNamed:@"data.json"];
        _laAnimation.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_laAnimation];
        [_laAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self setNeedsLayout];
    }return _laAnimation;
}

-(NSMutableArray<NSString *> *)titlesMutArr{
    if (!_titlesMutArr) {
        _titlesMutArr = NSMutableArray.array;
        [_titlesMutArr addObject:@"喂我"];
    }return _titlesMutArr;
}

-(NSMutableArray<NSString *> *)imagesMutArr{
    if (!_imagesMutArr) {
        _imagesMutArr = NSMutableArray.array;
        [_imagesMutArr addObject:@"Rice"];
    }return _imagesMutArr;
}

@end


