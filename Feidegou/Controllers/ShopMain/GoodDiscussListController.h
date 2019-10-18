//
//  GoodDiscussListController.h
//  guanggaobao
//
//  Created by 谭自强 on 16/8/2.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "JJBaseViewController.h"
@protocol DiscussListNumDelegete<NSObject>

- (void)discussListNumDictonary:(NSDictionary *)dictionary;

@end

typedef enum {
    enum_discuss_all,
    enum_discuss_good,
    enum_discuss_middle,
    enum_discuss_bad
}enumeDiscussState;

@interface GoodDiscussListController : JJBaseViewController

@property (strong, nonatomic) id<DiscussListNumDelegete>delegete;
@property (assign, nonatomic) enumeDiscussState enumState;
@property (copy, nonatomic) NSString *strGood_id;
@property (copy, nonatomic) NSString *store_id;

@end
