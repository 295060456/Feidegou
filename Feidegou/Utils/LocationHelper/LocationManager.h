//
//  LocationManager.h
//  guanggaobao
//
//  Created by 谭自强 on 16/1/15.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <BaiduMapAPI_Location/BMKLocationService.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>//反检索
#import <BaiduMapAPI_Map/BMKOfflineMap.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>


@interface LocationManager : NSObject<
//BMKLocationServiceDelegate,
BMKGeoCodeSearchDelegate,
BMKOfflineMapDelegate,
BMKMapViewDelegate
>{
//    BMKLocationService *_locService;
    BMKOfflineMap * _offlineMap;
    BMKMapView* _mapView;
}
@property (nonatomic,strong) RACDisposable *disposable;
@property (nonatomic,strong) BMKGeoCodeSearch *geoCodeSearch;
/**
 *  初始化
 */
+(LocationManager*)sharedInstance;
/**
 *  更新位置
 */
-(void)updateLocation;
/**
 *  更新latitude
 */
- (void)updateLocalLocationLongitude:(double)longitude
                         andLatitude:(double)latidude;
/**
 *  获取latitude
 */
-(NSString *)fetchLocationLatitude;
/**
 *  获取longitude
 */
-(NSString *)fetchLocationLongitude;
+ (CLLocationCoordinate2D)bd09Decrypt:(double)bdLat
                                bdLon:(double)bdLon;
@end
