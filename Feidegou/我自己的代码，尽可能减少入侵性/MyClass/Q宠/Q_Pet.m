//
//  Q_Pet.m
//  Feidegou
//
//  Created by Kite on 2019/10/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "Q_Pet.h"

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

@property(nonatomic,strong)LOTAnimationView *laAnimation;

@end

@implementation Q_Pet

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setContent:kIMG(@"新机器猫")
             contentType:MISFloatingBallContentTypeImage];
    }return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(UIEvent *)event{
    d++;
    if (_laAnimation) {
        [_laAnimation removeFromSuperview];
        _laAnimation = nil;
    }
    NSLog(@"KKK = %d",d %2);
    if (d % 2) {//开
       @weakify(self)
        [self setContent:kIMG(@"透明图标")
             contentType:MISFloatingBallContentTypeImage];
        [self.laAnimation playWithCompletion:^(BOOL animationFinished) {
            @strongify(self)
//            NSLog(@"123");
            [self.laAnimation removeFromSuperview];
            self.laAnimation = nil;
            [self setContent:kIMG(@"新机器猫")
                 contentType:MISFloatingBallContentTypeImage];
        }];
    }else{//关
        [self setContent:kIMG(@"新机器猫")
             contentType:MISFloatingBallContentTypeImage];
        [self.laAnimation pause];//
    }
}

-(NSString *)event_marchWithAnimationType:(DYAnimationType)animationType{
    switch (animationType) {
        case kDYAnimationOne:
            return  @"Watermelon.json";
            break;
        case kDYAnimationTwo:
            return  @"TwitterHeart.json";
            break;
        case kDYAnimationThree:
            return  @"vcTransition1.json";
            break;
        case kDYAnimationFour:
            return  @"HamburgerArrow.json";
            break;
        case kDYAnimationFive:
            return  @"LottieLogo2.json";
            break;
        case kDYAnimationSix:
            return  @"PinJump.json";
            break;
        case kDYAnimationSeven:
            return  @"G.json";
            break;
        case kDYAnimationEight:
            return  @"W.json";
            break;
        case kDYAnimationNine:
            return  @"F.json";
            break;
        case kDYAnimationTen:
            return  @"Q.json";
            break;
        default:
            break;
    }
}

#pragma mark —— lazyload
-(LOTAnimationView *)laAnimation{
    if (!_laAnimation) {
        _laAnimation = [LOTAnimationView animationNamed:@"Watermelon.json"];
        _laAnimation.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_laAnimation];
        [_laAnimation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self setNeedsLayout];
    }return _laAnimation;
}

@end
