//
//  PersonalDataChangedListVC+VM.m
//  Feidegou
//
//  Created by Kite on 2019/11/20.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "PersonalDataChangedListVC+VM.h"

@implementation PersonalDataChangedListVC (VM)

-(void)PestCatFood_changelist_netWorking{
    NSString *randomStr = [EncryptUtils shuffledAlphabet:16];
    NSDictionary *dic = @{
        @"user_id":[[PersonalInfo sharedInstance] fetchLoginUserInfo].userId,
        @"currentpage":[NSString stringWithFormat:@"%d",self.page],
        @"pagesize":@"5"
    };

    FMHttpRequest *req = [FMHttpRequest urlParametersWithMethod:HTTTP_METHOD_POST
                                                           path:PestCatFood_changelistUrl
                                                     parameters:@{
                                                         @"data":dic,
                                                         @"key":[RSAUtil encryptString:randomStr
                                                                             publicKey:RSA_Public_key],
                                                         @"randomStr":randomStr
                                                     }];
    self.reqSignal = [[FMARCNetwork sharedInstance] requestNetworkData:req];
    @weakify(self)
    [self.reqSignal subscribeNext:^(FMHttpResonse *response) {
        @strongify(self)
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic = (NSDictionary *)response;
            if ([dic[@"list"] isKindOfClass:[NSArray class]]) {
                NSArray *array = [PersonalDataChangedListModel mj_objectArrayWithKeyValuesArray:dic[@"list"]];
                if (array) {
                    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj,
                                                        NSUInteger idx,
                                                        BOOL * _Nonnull stop) {
                        @strongify(self)
                        PersonalDataChangedListModel *model = array[idx];
//                        ModelLogin *modelLogin = [[PersonalInfo sharedInstance] fetchLoginUserInfo];
                        switch ([model.change_status intValue]) {
                            case 11:{//赠送增加
                                model.change_statusStr = @"赠送增加";
                            }break;
                            case 21:{//赠送减少
                                model.change_statusStr = @"赠送减少";
                            }break;
                            case 12:{//后台增加
                                model.change_statusStr = @"后台增加";
                            }break;
                            case 22:{//后台减少
                                model.change_statusStr = @"后台减少";
                            }break;
                            case 13:{//摊位购买
                                model.change_statusStr = @"摊位购买";
                            }break;
                            case 23:{//摊位出售
                                model.change_statusStr = @"摊位出售";
                            }break;
                            case 33:{//摊位发布
                                model.change_statusStr = @"摊位发布";
                            }break;
                            case 14:{//批发购买
                                model.change_statusStr = @"批发购买";
                            }break;
                            case 24:{//批发出售
                                model.change_statusStr = @"批发出售";
                            }break;
                            case 34:{//批发发布
                                model.change_statusStr = @"批发发布";
                            }break;
                            case 44:{//批发下架
                                model.change_statusStr = @"批发下架";
                            }break;
                            case 15:{//产地购买
                                model.change_statusStr = @"产地购买";
                            }break;
                            case 25:{//产地出售
                                model.change_statusStr = @"产地出售";
                            }break;
                            case 35:{//产地发布
                                model.change_statusStr = @"产地发布";
                            }break;
                            case 16:{//结束直通车增加
                                model.change_statusStr = @"结束直通车增加";
                            }break;
                            case 26:{//开启直通车减少
                                model.change_statusStr = @"开启直通车减少";
                            }break;
                            case 27:{//喂食喵粮减少
                                model.change_statusStr = @"喂食喵粮减少";
                            }break;
                            default:
                                model.change_statusStr = @"数据异常";
                                break;
                        }
                        [self.dataMutArr addObject:model];
                    }];
                }
                [self.tableView reloadData];
            }
        }
        self.tableView.mj_footer.hidden = NO;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

@end

