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
 *  读取上次选择的城市名
 */
-(NSString *)readLastChooseCity
{
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:lastChooseCityNameKey];
    if (!city || city.length == 0)
    {
        city = @"定位中";
    }
    return city;
}

/**
  *  读取上次定位的城市
  */
-(NSString *)readLastLocationCity
{
    NSString *city = [[NSUserDefaults standardUserDefaults] objectForKey:lastLocationCityNameKey];
    if (!city || city.length == 0)
    {
        city = @"定位中...";
    }
    return city;
}

- (CGFloat)readLastLocationLatitude
{
    CGFloat la = [[NSUserDefaults standardUserDefaults] doubleForKey:lastChooseLatitudeKey];
    return la;
}
- (CGFloat)readLastLocationLongitude
{
    CGFloat lo = [[NSUserDefaults standardUserDefaults] doubleForKey:lastChooseLongitudeKey];
    return lo;
}


/**
 *  读取历史城市
 *
 *  @return <#return value description#>
 */
-(NSMutableArray *)readHistoryCity
{
    NSMutableArray *arrHis = [NSMutableArray arrayWithContentsOfFile:historyCityFileNameKey];
    if (!arrHis || arrHis.count == 0)
    {
        arrHis = [NSMutableArray array];
    }
    return arrHis;
}

// 保存选择城市
- (void)saveChooseCity:chooseCityName
{
    
    [[NSUserDefaults standardUserDefaults] setObject:chooseCityName forKey:lastChooseCityNameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    PDLog(@"更新选择城市！");
    
    // 更新历史
    if ([self updateHistoryCity:chooseCityName])
        PDLog(@"更新本地历史城市成功!");
    else
        PDLog(@"更新本地历史城市失败!");
}

/**
 *  定位当前城市名
 */
- (void)getLocationCity
{
    [self startLocationService];
}

# pragma mark - private

// 更新历史城市
- (BOOL)updateHistoryCity:(NSString *)newChooseCity
{
    // 存cache
    NSMutableArray *arrHis = [NSMutableArray arrayWithContentsOfFile:historyCityFileNameKey];
    PDLog(@"%@", arrHis);
    
    if (!arrHis || arrHis.count == 0) // 第一次
    {
        arrHis = [NSMutableArray array];
        [arrHis addObject:newChooseCity];
    }
    else
    {
        // 如果相同
        for (NSString *temp in arrHis)
        {
            if ([newChooseCity isEqualToString:temp])
            {
                PDLog(@"更新本地历史城市有重复");
                return NO;
            }
        }
        
        if (arrHis.count == 3) // 已经有3个了
        {
            [arrHis removeObjectAtIndex:0];
            [arrHis addObject:newChooseCity];
        }
        else // 小于3
        {
            [arrHis addObject:newChooseCity];
        }
    }
    
    PDLog(@"历史城市保存路径 -- %@",historyCityFileNameKey);
    return [arrHis writeToFile:historyCityFileNameKey atomically:YES];
    
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
        self.locationCity = [result.addressDetail.city substringToIndex:result.addressDetail.city.length-1];
        if ([self.locationCity hasSuffix:@"特别行政"])
        {
            self.locationCity  = [self.locationCity substringToIndex:2];
        }
        PDLog(@"定位城市---%@",self.locationCity);
        // 本地存定位城市
        // 如选择城市为空 默认选择城市也是这个
        [[NSUserDefaults standardUserDefaults] setObject:self.locationCity forKey:lastLocationCityNameKey];
        if (![[NSUserDefaults standardUserDefaults] objectForKey:lastChooseCityNameKey])
        {
            [[NSUserDefaults standardUserDefaults] setObject:self.locationCity forKey:lastChooseCityNameKey];
        }
//        
//        [[NSUserDefaults standardUserDefaults] setDouble:self.Latitude forKey:lastChooseLatitudeKey];
//        [[NSUserDefaults standardUserDefaults] setDouble:self.Longitude forKey:lastChooseLongitudeKey];
        [[NSUserDefaults standardUserDefaults] synchronize]; // 同步
    }
    else
    {
        self.locationCity = @"定位失败";
        PDLog(@"抱歉，未找到结果");
    }
    if ([self.delegate respondsToSelector:@selector(PDLocationToolGetLocationCity:result:Latitude:Longitude:)])
    {
        [self.delegate PDLocationToolGetLocationCity:self.locationCity result:result Latitude:self.Latitude Longitude:self.Longitude];
    }
    if ([self.delegate respondsToSelector:@selector(PDLocationToolGetReverseGeoCodeResult:result:errorCode:)])
    {
        [self.delegate PDLocationToolGetReverseGeoCodeResult:searcher result:result errorCode:error];
    }
    self.delegate = nil;
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
    if ([self.delegate respondsToSelector:@selector(PDLocationToolDidUpdateLocation:Latitude:Longitude:)])
    {
        [self.delegate PDLocationToolDidUpdateLocation:userLocation Latitude:self.Latitude Longitude:self.Longitude];
    }
}

@end
