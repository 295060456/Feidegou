//
//  RegisterVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/22.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "RegisterVC+VM.h"
#import "JJHttpClient+Login.h"

@implementation RegisterVC (VM)

-(void)authCode:(NSString *)iPhone{
    
    NSString *str = AK;
    NSLog(@"");
    
    self.disposable = [[JJHttpClient.new requestPswGetBackPHONE:iPhone andType:@""] subscribeNext:^(id  _Nullable x) {
        NSLog(@"");
    } error:^(NSError * _Nullable error) {
        NSLog(@"");
    } completed:^{
        NSLog(@"");
    }];
}

@end
