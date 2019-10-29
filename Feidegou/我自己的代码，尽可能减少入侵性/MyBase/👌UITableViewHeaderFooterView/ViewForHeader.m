//
//  ViewForHeader.m
//  ManVideo
//
//  Created by 刘赓 on 2019/9/26.
//  Copyright © 2019 Josee. All rights reserved.
//

#import "ViewForHeader.h"

@interface ViewForHeader()

@property(nonatomic,weak)DataBlock block;

@end

@implementation ViewForHeader

- (instancetype)initWithRequestParams:(id)requestParams{
    if (self = [super init]) {

    }return self;
}

-(void)drawRect:(CGRect)rect{

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(UIEvent *)event{
    if (self.block) {
        self.block(@1);
    }
}

-(void)actionBlock:(DataBlock)block{
    _block = block;
}

#pragma mark —— lazyLoad


@end
