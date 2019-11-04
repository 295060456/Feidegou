//
//  PetsInfoListModel.h
//  Feidegou
//
//  Created by Kite on 2019/10/19.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//用户宠物详细信息
@interface PetsInfoListModel : BaseModel

@property(nonatomic,copy)NSString *petsName;//宠物名称
@property(nonatomic,assign)int sex;//宠物性别
@property(nonatomic,assign)int Grade;//等级
@property(nonatomic,assign)int lifeValue;//饥饿值
@property(nonatomic,assign)int cleanValue;//清洁值
@property(nonatomic,assign)int moodValue;//心情值
@property(nonatomic,assign)int growUpValue;//成长值
@property(nonatomic,copy)NSString *deathTime;
@property(nonatomic,assign)int status;//状态   0、正常；1、去世；2、免打扰模式；3、结束免打扰模式
@property(nonatomic,assign)Boolean maritalStatus;//婚姻状态 0、未婚；1、已婚
@property(nonatomic,assign)int user_id;//用户ID
@property(nonatomic,assign)int ID;//id
@property(nonatomic,copy)NSString *addTime;
@property(nonatomic,copy)NSString *deleteStatus;

@end

NS_ASSUME_NONNULL_END

//{
//    "pest": [
//    {
//        "petsName": "小喵",    //宠物名称
//        "sex": 0,            //宠物性别
//        "Grade": 0,            //等级
//        "lifeValue": 66,    //饥饿值
//        "cleanValue": 90,    //清洁值
//        "moodValue": 90,    //心情值
//        "growUpValue": 90,    //成长值
//        "deathTime": "2019-10-13 20:53:51",
//        "status": 0,        //状态   0正常,1去世，2.免打扰模式，3.结束免 打扰模式
//        "maritalStatus": 0,    //婚姻状态   0未婚  1已婚
//        "user_id": 1,        //用户ID
//        "id": 23,            //id
//        "addTime": "2019-10-13 20:53:40",
//        "deleteStatus": false
//    }
//             ]
//}
