//
//  ApplyForVenderAttribute.h
//  Vendor
//
//  Created by 谭自强 on 2017/4/14.
//  Copyright © 2017年 朝花夕拾. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplyForVenderAttribute : NSObject


//店主姓名
@property (strong, nonatomic) NSString *strName;
//身份证号
@property (strong, nonatomic) NSString *strMemberNum;
//店铺名称
@property (strong, nonatomic) NSString *strVendorName;
//店铺分类名称
@property (strong, nonatomic) NSString *strVendorTypeName;
//店铺分类ID
@property (strong, nonatomic) NSString *strVendorTypeID;
//所在区域ID
@property (strong, nonatomic) NSString *strAreaID;
//所在区域名字
@property (strong, nonatomic) NSString *strAreaName;
//详细地址
@property (strong, nonatomic) NSString *strAddressDetail;
//邮政编码
@property (strong, nonatomic) NSString *strZIPCode;
//联系电话
@property (strong, nonatomic) NSString *strPhone;
//身份证照片正面
@property (strong, nonatomic) UIImage *imgMemberCard;
//营业执照照片
@property (strong, nonatomic) UIImage *imgBusiness;
@end
