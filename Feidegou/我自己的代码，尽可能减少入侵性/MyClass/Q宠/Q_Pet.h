//
//  Q_Pet.h
//  Feidegou
//
//  Created by Kite on 2019/10/21.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Q_Pet : MISFloatingBall

@property(nonatomic,strong)RACSignal *reqSignal;
@property(nonatomic,strong)LOTAnimationView *laAnimation;//MISFloatingBall

@end

NS_ASSUME_NONNULL_END
