//
//  PDLocationTool.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/29.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDLocationTool.h"

static PDLocationTool *locationTool;

@interface PDLocationTool()
{
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
}
@end

@implementation PDLocationTool

- (id)init
{
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            // 加载资源
            
        });
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        locationTool = [super allocWithZone:zone];
    });
    return locationTool;
}

+ (instancetype)shareTocationTool
{
   return [[self alloc] init];
}

/**
 *  读取当前保存到城市名
 */
-(NSString *)readLastCity
{
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:lastCityNameKey];
    if (!city || city.length == 0)
    {
        city = @"定位中";
    }
    return city;
}
/**
 *  定位当前城市名
 */
- (void)getLocationCity
{
    [self startLocationService];
    
}

/**
 *  定位
 */
- (void)startLocationService
{
    // 定位
    //初始化BMKLocationService
    if (!_locService)
    {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    //启动LocationService
    [_locService startUserLocationService];
}

/**
 *  反地理编码 得到城市
 */
- (void)reverseGeocode
{
    //初始化检索对象
    if (!_geocodesearch)
    {
        _geocodesearch =[[BMKGeoCodeSearch alloc]init];
        _geocodesearch.delegate = self;
    }
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){self.Latitude, self.Longitude};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}

#pragma mark - BMKGeoCodeSearchDelegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        self.locationCity = [result.addressDetail.city substringToIndex:2];
        // 本地存一下 下次优先显示
        [[NSUserDefaults standardUserDefaults]setObject:self.locationCity forKey:lastCityNameKey];
        [[NSUserDefaults standardUserDefaults] synchronize]; // 同步
    }
    else
    {
        self.locationCity = @"抱歉，未找到结果";
        PDLog(@"抱歉，未找到结果");
    }
    if ([self.delegate respondsToSelector:@selector(PDLocationToolGetLocationCity:result:)])
    {
        [self.delegate PDLocationToolGetLocationCity:self.locationCity result:result];
    }
    if ([self.delegate respondsToSelector:@selector(PDLocationToolGetReverseGeoCodeResult:result:errorCode:)])
    {
        [self.delegate PDLocationToolGetReverseGeoCodeResult:searcher result:result errorCode:error];
    }
}
#pragma mark - BMKLocationServiceDelegate


//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation.location.coordinate.latitude)
    {
        PDLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
        
        [_locService stopUserLocationService];
        
        // 有了经纬度 可以反地理编码
        self.Latitude = userLocation.location.coordinate.latitude;
        self.Longitude = userLocation.location.coordinate.longitude;
        [self reverseGeocode];
    }
    if ([self.delegate respondsToSelector:@selector(PDLocationToolDidUpdateLocation:)])
    {
        [self.delegate PDLocationToolDidUpdateLocation:userLocation];
    }
}

@end
