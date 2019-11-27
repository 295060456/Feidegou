//
//  QRcodeIMGV.m
//  Feidegou
//
//  Created by Kite on 2019/11/27.
//  Copyright © 2019 朝花夕拾. All rights reserved.
//

#import "QRcodeIMGV.h"

@interface QRcodeIMGV (){
    
}

@property(nonatomic,assign)int tap;

@end

@implementation QRcodeIMGV

-(instancetype)init{
    if (self = [super init]) {
        self.tap = 0;
        self.userInteractionEnabled = YES;
    }return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches
          withEvent:(UIEvent *)event{
    if (![NSString isNullString:self.QRcodeStr]) {
        self.tap++;
        [self QRcode];
    }
}

-(void)QRcode{
    NSLog(@"A = %d",self.tap);
    NSLog(@"B = %d",self.tap % 4);
    switch (self.tap % 4) {
        case 0:{
            self.image = [SGQRCodeObtain generateQRCodeWithData:self.QRcodeStr
                                                                      size:SCREEN_WIDTH / 2
                                                                     color:kRedColor
                                                           backgroundColor:KYellowColor];
        }break;
        case 1:{
            self.image = [SGQRCodeObtain generateQRCodeWithData:self.QRcodeStr
                                                                      size:SCREEN_WIDTH / 2
                                                                 logoImage:kIMG(@"helloKitty")
                                                                     ratio:5];
        }break;
        case 2:{
            self.image = [SGQRCodeObtain generateQRCodeWithData:@"https://github.com/KeenTeam1990/SGQRCode.git"
                                                                      size:SCREEN_WIDTH / 2];
        }break;
        case 3:{
            self.image = [SGQRCodeObtain generateQRCodeWithData:self.QRcodeStr
                                                                      size:SCREEN_WIDTH / 2
                                                                 logoImage:kIMG(@"helloKitty")
                                                                     ratio:5
                                                     logoImageCornerRadius:5
                                                      logoImageBorderWidth:5
                                                      logoImageBorderColor:KLightGrayColor];
        }break;
        default:
            break;
    }
}

@end
