//
//  LocationManager.m
//  guanggaobao
//
//  Created by 谭自强 on 16/1/15.
//  Copyright © 2016年 朝花夕拾. All rights reserved.
//

#import "LocationManager.h"
#define USERLOCATION_LATITUDE @"userLocation_latitude"
#define USERLOCATION_LONGITUDE @"userLocation_longitude"
@implementation LocationManager

static LocationManager *sharedManager;
+(LocationManager*)sharedInstance{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedManager = [[LocationManager alloc] init];
        
    });
    return sharedManager;
    
}

-(instancetype)init{
    
    if (self = [super init]) {
        //初始化BMKLocationService
//        self.geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
        self.geoCodeSearch.delegate = self;
//        _locService = [[BMKLocationService alloc]init];
//        _locService.delegate = self;
        //启动LocationService
        _offlineMap = [[BMKOfflineMap alloc] init];
        _mapView = [[BMKMapView alloc] init];
        [self updateLocation];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _offlineMap.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _offlineMap.delegate = nil; // 不用时，置nil
}
- (void)dealloc {
    
    if (_offlineMap != nil) {
        _offlineMap = nil;
    }
    if (_mapView) {
        _mapView = nil;
    }
}
/**
 *  更新位置
 */
-(void)updateLocation{
    
//    [_locService startUserLocationService];
    
}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    D_NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    D_NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};
    pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    [self updateLocalLocationLongitude:userLocation.location.coordinate.longitude andLatitude:userLocation.location.coordinate.latitude];
//    [_locService stopUserLocationService];
    
//    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
//    reverseGeocodeSearchOption.reverseGeoPoint = pt;
//    BOOL flag = [self.geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];//发送反编码请求.并返回是否成功
//    if(flag)
//    {
//        NSLog(@"反geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"反geo检索发送失败");
//    }
}

#pragma mark -
#pragma mark - BMKGeoCodeSearchDelegate
//-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
//
//
//    D_NSLog(@"result is %@",result.addressDetail.city);
//
//    NSString *cityId = @"";
//    if (result.addressDetail.city) {
////        首先用城市搜索，城市不行用省份，省不行就没法了。。。
//        NSArray* records = [_offlineMap searchCity:result.addressDetail.city];
//        if (records.count==0) {
//            records = [_offlineMap searchCity:result.addressDetail.province];
//
//        }
//        if (records!=0) {
//            BMKOLSearchRecord* oneRecord = [records objectAtIndex:0];
//            cityId = [NSString stringWithFormat:@"%d",oneRecord.cityID];
//        }
//    }
//}

- (void)onGetOfflineMapState:(int)type withState:(int)state{
    
}
/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error{
    D_NSLog(@"error is %@",error);
}
- (void)updateLocalLocationLongitude:(double)longitude andLatitude:(double)latidude{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:StringFormat(@"%f",longitude) forKey:USERLOCATION_LONGITUDE];
    [userDefaults setObject:StringFormat(@"%f",latidude) forKey:USERLOCATION_LATITUDE];
    [userDefaults synchronize];
}
- (NSString *)fetchLocationLatitude{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strLATITUDE = [userDefaults objectForKey:USERLOCATION_LATITUDE];
    if ([NSString isNullString:strLATITUDE]) {
        strLATITUDE = @"0";
        [self updateLocation];
    }
    return strLATITUDE;
}
/**
 *  获取longitude
 */
- (NSString *)fetchLocationLongitude{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *strLONGITUDE = [userDefaults objectForKey:USERLOCATION_LONGITUDE];
    if ([NSString isNullString:strLONGITUDE]) {
        strLONGITUDE = @"0";
        [self updateLocation];
    }
    return strLONGITUDE;
}
+ (CLLocationCoordinate2D)bd09Decrypt:(double)bdLat bdLon:(double)bdLon
{
    CLLocationCoordinate2D gcjPt;
    double x = bdLon - 0.0065, y = bdLat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) - 0.000003 * cos(x * M_PI);
    gcjPt.longitude = z * cos(theta);
    gcjPt.latitude = z * sin(theta);
    return gcjPt;
}
@end
